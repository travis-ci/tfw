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

@test "tfw -h/--help/help/h exits 0" {
  for word in '-h' '--help' 'help' 'h'; do
    run ./tfw "${word}"
    [[ "${status}" -eq 0 ]]
  done
}

@test "tfw urldecode/d decodes stuff and exits 0" {
  for word in 'urldecode' 'd'; do
    run ./tfw "${word}" 'what%2Fthe+what%3F'
    [[ "${output}" == "what/the what?" ]]
    [[ "${status}" -eq 0 ]]
  done
}

@test "tfw printenv/p without args exits 2" {
  for word in 'printenv' 'p'; do
    run ./tfw "${word}"
    [[ "${status}" -eq 2 ]]
  done
}

@test "tfw printenv/p tfwtest prints stuff and exits 0" {
  for word in 'printenv' 'p'; do
    run ./tfw "${word}" tfwtest
    eval "${output}"
    [[ "${status}" -eq 0 ]]
    [[ "${TFW_BOOPS}" == 9003 ]]
  done
}

@test "tfw printenv/p notset prints stuff and exits 0" {
  for word in 'printenv' 'p'; do
    run ./tfw "${word}" notset
    eval "${output}"
    [[ "${status}" -eq 0 ]]
    [[ "${TFW_BOOPS}" == 8999 ]]
  done
}

@test "tfw writeenv/w without args exits 2" {
  for word in 'writeenv' 'w'; do
    run ./tfw "${word}"
    [[ "${status}" -eq 2 ]]
  done
}

@test "tfw writeenv/w tfwtest writes stuff and exits 0" {
  for word in 'writeenv' 'w'; do
    run ./tfw "${word}" tfwtest
    source "${RUNDIR}/tfwtest.env"
    [[ "${status}" -eq 0 ]]
    [[ "${TFW_BOOPS}" == 9003 ]]
  done
}

@test "tfw writeenv/w tfwtest tfwtest-1 writes stuff and exits 0" {
  for word in 'writeenv' 'w'; do
    run ./tfw "${word}" tfwtest tfwtest-1
    source "${RUNDIR}/tfwtest-1.env"
    [[ "${status}" -eq 0 ]]
    [[ "${TFW_BOOPS}" == 9003 ]]
  done
}

@test "tfw extract/e without args exits 2" {
  for word in 'extract' 'e'; do
    run ./tfw "${word}"
    [[ "${status}" -eq 2 ]]
  done
}

@test "tfw extract/e tfwtest exits 2" {
  for word in 'extract' 'e'; do
    run ./tfw "${word}" tfwtest
    [[ "${status}" -eq 2 ]]
  done
}

@test "tfw extract/e tfwtest <image> extracts stuff and exits 0" {
  for word in 'extract' 'e'; do
    run ./tfw "${word}" tfwtest "${TFWTEST_IMAGE}"
    [[ "${status}" -eq 0 ]]
    [[ -f "${ETCDIR}/systemd/system/tfwtest.service" ]]
    [[ -f "${USRSBINDIR}/tfwtest-wrapper" ]]
    [[ "${output}" =~ Extracted.+tfwtest.service ]]
    [[ "${output}" =~ Extracted.*tfwtest-wrapper ]]
  done
}
