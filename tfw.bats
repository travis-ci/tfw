#!/usr/bin/env bats

setup() {
  rm -rf "${BATS_TMPDIR}/tfw"

  for d in \
    "${BATS_TMPDIR}/tfw/etc/default" \
    "${BATS_TMPDIR}/tfw/etc/systemd/system" \
    "${BATS_TMPDIR}/tfw/usr/sbin" \
    "${BATS_TMPDIR}/tfw/var/tmp/travis-run.d"
  do
    mkdir -p "${d}"
  done

  export ETCDIR="${BATS_TMPDIR}/tfw/etc"
  export RUNDIR="${BATS_TMPDIR}/tfw/var/tmp/travis-run.d"
  export USRSBINDIR="${BATS_TMPDIR}/tfw/usr/sbin"
  : "${TFWTEST_IMAGE:=travisci/nat-conntracker:0.3.0-10-g143f6c0}"
  export TFWTEST_IMAGE

  cat >"${ETCDIR}/default/travis-enterprise" <<'EOF'
export TFW_BOOPS=8999
EOF

  cat >"${ETCDIR}/default/tfwtest-chef" <<'EOF'
export TFW_BOOPS=9000
EOF

  cat >"${ETCDIR}/default/tfwtest" <<'EOF'
export TFW_BOOPS=9001

# ignored as heck
EOF

  cat >"${ETCDIR}/default/tfwtest-cloud-init" <<'EOF'
export TFW_BOOPS=9002
EOF

  cat >"${ETCDIR}/default/tfwtest-local" <<'EOF'
export TFW_BOOPS=9003
EOF
}

teardown() {
  rm -rf "${BATS_TMPDIR}/tfw"
}

@test "tfw help system" {
  for word in '-h' '--help' 'help' 'h'; do
    run ./tfw "${word}"
    [[ "${status}" -eq 0 ]]
  done
}

@test "tfw urldecode" {
  run ./tfw urldecode 'what%2Fthe+what%3F'
  [[ "${output}" == "what/the what?" ]]
}

@test "tfw d" {
  run ./tfw d 'how+does+one%3F%3A'
  [[ "${output}" == "how does one?:" ]]
}

@test "tfw printenv" {
  run ./tfw printenv
  [[ "${status}" -eq 2 ]]
}

@test "tfw printenv tfwtest" {
  run ./tfw printenv tfwtest
  eval "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${TFW_BOOPS}" == 9003 ]]
}

@test "tfw p tfwtest" {
  run ./tfw p tfwtest
  eval "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${TFW_BOOPS}" == 9003 ]]
}

@test "tfw printenv notset" {
  run ./tfw printenv notset
  eval "${output}"
  [[ "${status}" -eq 0 ]]
  [[ "${TFW_BOOPS}" == 8999 ]]
}

@test "tfw writeenv" {
  run ./tfw writeenv
  [[ "${status}" -eq 2 ]]
}

@test "tfw writeenv tfwtest" {
  run ./tfw writeenv tfwtest
  source "${RUNDIR}/tfwtest.env"
  [[ "${status}" -eq 0 ]]
  [[ "${TFW_BOOPS}" == 9003 ]]
}

@test "tfw w tfwtest" {
  run ./tfw w tfwtest
  source "${RUNDIR}/tfwtest.env"
  [[ "${status}" -eq 0 ]]
  [[ "${TFW_BOOPS}" == 9003 ]]
}

@test "tfw writeenv tfwtest tfwtest-1" {
  run ./tfw writeenv tfwtest tfwtest-1
  source "${RUNDIR}/tfwtest-1.env"
  [[ "${status}" -eq 0 ]]
  [[ "${TFW_BOOPS}" == 9003 ]]
}

@test "tfw extract" {
  run ./tfw extract
  [[ "${status}" -eq 2 ]]
}

@test "tfw extract tfwtest" {
  run ./tfw extract tfwtest
  [[ "${status}" -eq 2 ]]
}

@test "tfw extract tfwtest <image>" {
  run ./tfw extract tfwtest "${TFWTEST_IMAGE}"
  [[ "${status}" -eq 0 ]]
  [[ -f "${ETCDIR}/systemd/system/tfwtest.service" ]]
  [[ -f "${USRSBINDIR}/tfwtest-wrapper" ]]
  [[ "${output}" =~ Extracted.+tfwtest.service ]]
  [[ "${output}" =~ Extracted.*tfwtest-wrapper ]]
}
