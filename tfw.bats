#!/usr/bin/env bats

@test "help system" {
  for word in '-h' '--help' 'help' 'h'; do
    ./tfw "${word}"
    [[ "${status}" -eq 0 ]]
  done
}

@test "urldecode" {
  result="$(./tfw urldecode 'what%2Fthe+what%3F')"
  [[ "${result}" == "what/the what?" ]]

  result="$(./tfw d 'how+does+one%3F%3A')"
  [[ "${result}" == "how does one?:" ]]
}
