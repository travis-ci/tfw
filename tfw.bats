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
  : "${TFWTEST_IMAGE:=travisci/sleepy-snoozer}"
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

  echo 'i-1337801' >"${RUNDIR}/instance-id"
  echo 'local-test-1337801' >"${RUNDIR}/instance-name"
  echo '128.0.0.1' >"${RUNDIR}/instance-ipv4"
  echo 'nz-grayhavens-2' >"${RUNDIR}/instance-region-zone"
}

teardown() {
  rm -rf "${BATS_TMPDIR}/tfw"
}

@test "tfw -h/--help/help/h exits 0" {
  for word in '-h' '--help' 'help' 'h'; do
    run ./bin/tfw "${word}"
    [[ "${status}" -eq 0 ]]
  done
}

@test "tfw help urldecode/d shows help" {
  for word in 'urldecode' 'd'; do
    run ./bin/tfw help "${word}"
    [[ "${output}" =~ Usage: ]]
    [[ "${status}" -eq 0 ]]
  done
}

@test "tfw urldecode/d decodes stuff and exits 0" {
  for word in 'urldecode' 'd'; do
    run ./bin/tfw "${word}" 'what%2Fthe+what%3F'
    [[ "${output}" == "what/the what?" ]]
    [[ "${status}" -eq 0 ]]
  done
}

@test "tfw help app-printenv/printenv/p shows help" {
  for word in 'app-printenv' 'printenv' 'p'; do
    run ./bin/tfw help "${word}"
    [[ "${output}" =~ Usage: ]]
    [[ "${status}" -eq 0 ]]
  done
}

@test "tfw app-printenv/printenv/p without args exits 2" {
  for word in 'app-printenv' 'printenv' 'p'; do
    run ./bin/tfw "${word}"
    [[ "${status}" -eq 2 ]]
  done
}

@test "tfw app-printenv/printenv/p tfwtest prints stuff and exits 0" {
  for word in 'app-printenv' 'printenv' 'p'; do
    run ./bin/tfw "${word}" tfwtest
    [[ ! "${output}" =~ export ]]
    eval "${output}"
    [[ "${status}" -eq 0 ]]
    [[ "${TFW_BOOPS}" == 9003 ]]
  done
}

@test "tfw app-printenv/printenv/p tfwtest --export prints stuff and exits 0" {
  for word in 'app-printenv' 'printenv' 'p'; do
    run ./bin/tfw "${word}" tfwtest '' --export
    [[ "${output}" =~ export ]]
    eval "${output}"
    [[ "${status}" -eq 0 ]]
    [[ "${TFW_BOOPS}" == 9003 ]]
  done
}

@test "tfw app-printenv/printenv/p notset prints stuff and exits 0" {
  for word in 'app-printenv' 'printenv' 'p'; do
    run ./bin/tfw "${word}" notset
    eval "${output}"
    [[ "${status}" -eq 0 ]]
    [[ "${TFW_BOOPS}" == 8999 ]]
  done
}

@test "tfw help app-writeenv/writeenv/w shows help" {
  for word in 'app-writeenv' 'writeenv' 'w'; do
    run ./bin/tfw help "${word}"
    [[ "${output}" =~ Usage: ]]
    [[ "${status}" -eq 0 ]]
  done
}

@test "tfw app-writeenv/writeenv/w without args exits 2" {
  for word in 'app-writeenv' 'writeenv' 'w'; do
    run ./bin/tfw "${word}"
    [[ "${status}" -eq 2 ]]
  done
}

@test "tfw app-writeenv/writeenv/w tfwtest writes stuff and exits 0" {
  for word in 'app-writeenv' 'writeenv' 'w'; do
    run ./bin/tfw "${word}" tfwtest
    source "${RUNDIR}/tfwtest.env"
    [[ "${status}" -eq 0 ]]
    [[ "${TFW_BOOPS}" == 9003 ]]
  done
}

@test "tfw app-writeenv/writeenv/w tfwtest tfwtest-1 writes stuff and exits 0" {
  for word in 'app-writeenv' 'writeenv' 'w'; do
    run ./bin/tfw "${word}" tfwtest tfwtest-1
    source "${RUNDIR}/tfwtest-1.env"
    [[ "${status}" -eq 0 ]]
    [[ "${TFW_BOOPS}" == 9003 ]]
  done
}

@test "tfw help app-extract/extract/e shows help" {
  for word in 'app-extract' 'extract' 'e'; do
    run ./bin/tfw help "${word}"
    [[ "${output}" =~ Usage: ]]
    [[ "${status}" -eq 0 ]]
  done
}

@test "tfw app-extract/extract/e without args exits 2" {
  for word in 'app-extract' 'extract' 'e'; do
    run ./bin/tfw "${word}"
    [[ "${status}" -eq 2 ]]
  done
}

@test "tfw app-extract/extract/e tfwtest exits 2" {
  for word in 'app-extract' 'extract' 'e'; do
    run ./bin/tfw "${word}" tfwtest
    [[ "${status}" -eq 2 ]]
  done
}

@test "tfw app-extract/extract/e tfwtest <image> extracts stuff and exits 0" {
  for word in 'app-extract' 'extract' 'e'; do
    run ./bin/tfw "${word}" tfwtest "${TFWTEST_IMAGE}"
    [[ "${status}" -eq 0 ]]
    [[ -r "${ETCDIR}/systemd/system/tfwtest.service" ]]
    [[ -x "${USRSBINDIR}/tfwtest-wrapper" ]]
    [[ "${output}" =~ extracted.+tfwtest.service ]]
    [[ "${output}" =~ extracted.*tfwtest-wrapper ]]

    local service_content
    service_content="$(cat "${ETCDIR}/systemd/system/tfwtest.service")"
    [[ "${service_content}" =~ ExecStart=${USRSBINDIR}/tfwtest-wrapper ]]

    local wrapper_content
    wrapper_content="$(cat "${USRSBINDIR}/tfwtest-wrapper")"
    [[ "${wrapper_content}" =~ INSTANCE_ID=i-1337801 ]]
    [[ "${wrapper_content}" =~ INSTANCE_NAME=local-test-1337801 ]]
    [[ "${wrapper_content}" =~ INSTANCE_IPV4=128.0.0.1 ]]
    [[ "${wrapper_content}" =~ ZONE=nz-grayhavens-2 ]]
  done
}
