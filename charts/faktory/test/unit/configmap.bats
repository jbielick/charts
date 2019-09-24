#!/usr/bin/env bats

load _helpers

@test "ConfigMap: enabled by default"  {
  template configmap

  [ "$status" -eq 0 ]
  local actual=$(echo "$output" | yq 'length > 0')
  [ "$actual" = "true" ]
}

@test "ConfigMap: generic configuration is placed" {
  template configmap -f $(valuesPath config)

  [ "$status" -eq 0 ]
  local actual=$(echo "$output" | yq -r '.data["faktory.toml"]' | tee /dev/stderr)
  [ "$actual" = "$(cat <<EOF
[faktory]
EOF
)" ]
}

@test "ConfigMap: cron configuration is placed" {
  template configmap -f $(valuesPath cron)

  [ "$status" -eq 0 ]
  local actual=$(echo "$output" | yq -r '.data["cron.toml"]' | tee /dev/stderr)
  [ "$actual" = "$(cat <<EOF
[[cron]]
  schedule = "*/5 * * * *"
  [cron.job]
    type = "FiveJob"
    queue = "critical"
EOF
)" ]
}

@test "ConfigMap: statsd configuration is placed" {
  template configmap -f $(valuesPath statsd)

  [ "$status" -eq 0 ]
  local actual=$(echo "$output" | yq -r '.data["statsd.toml"]' | tee /dev/stderr)
  [ "$actual" = "$(cat <<EOF
[statsd]
  location = localhost
EOF
)" ]
}
