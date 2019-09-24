#!/usr/bin/env bats

load _helpers

@test "Secret: when password is provided, placed in secret"  {
  template secret --set 'password=b1234'

  [ "$status" -eq 0 ]
  local actual=$(echo "$output" | yq -r '.data.password' | tee /dev/stderr)
  local actual=$(get '.data.password')
  local expected=$(echo -n 'b1234' | base64)
  [ "$actual" = "$expected" ]
}

@test "Secret: when license is provided, placed in secret"  {
  template secret --set 'license=a1234'

  [ "$status" -eq 0 ]
  local actual=$(get .data.license)
  local expected=$(echo -n 'a1234' | base64)
  [ "$actual" = "$expected" ]
}
