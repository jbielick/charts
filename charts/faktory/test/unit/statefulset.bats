#!/usr/bin/env bats

load _helpers

@test "StatefulSet: replicas is one"  {
  template statefulset

  [ "$status" -eq 0 ]
  local actual=$(echo "$output" | yq -r '.spec.replicas' | tee /dev/stderr)
  [ "$actual" = 1 ]
}

@test "StatefulSet: serviceName is fullName"  {
  template statefulset

  [ "$status" -eq 0 ]
  [ "$(echo "$output" | yq -r '.spec.serviceName')" = "release-name-faktory" ]
}

@test "StatefulSet: imagePullSecrets are placed"  {
  template statefulset -f $(valuesPath pullsecrets)

  [ "$status" -eq 0 ]
  [ "$(
    echo "$output" \
    | yq -r '.spec.template.spec.imagePullSecrets[0].name' \
    | tee /dev/stderr
    )" = "MySecret" ]
}

@test "StatefulSet: ui is not bound in command"  {
  template statefulset

  [ "$status" -eq 0 ]
  [ "$(
    echo "$output" \
    | yq -r '.spec.template.spec.containers[1].command[1,2,3,4,5,6]' \
    | tee /dev/stderr
    )" = "-b
:7419
null
null
null
null" ]
}

@test "StatefulSet: when ui enabled, ui is bound in command"  {
  template statefulset -f $(valuesPath ui)

  [ "$status" -eq 0 ]
  [ "$(
    echo "$output" \
    | yq -r '.spec.template.spec.containers[1].command[1,2,3,4,5,6]' \
    | tee /dev/stderr
    )" = "-b
:7419
-w
:7420
null
null" ]
}

@test "StatefulSet: when license is provided, production flag is in command"  {
  template statefulset -f $(valuesPath ui) --set "license=a1234"

  [ "$status" -eq 0 ]
  [ "$(
    echo "$output" \
    | yq -r '.spec.template.spec.containers[1].command[1,2,3,4,5,6]' \
    | tee /dev/stderr
    )" = "-b
:7419
-w
:7420
-e
production" ]
}

@test "StatefulSet: when ui enabled, ui port is exposed"  {
  template statefulset -f $(valuesPath ui)

  [ "$status" -eq 0 ]
  [ "$(
    echo "$output" \
    | yq -r '.spec.template.spec.containers[1].ports[1].containerPort' \
    | tee /dev/stderr
    )" = "7420" ]
  [ "$(
    echo "$output" \
    | yq -r '.spec.template.spec.containers[1].ports[1].name' \
    | tee /dev/stderr
    )" = "ui" ]
}

@test "StatefulSet: when resources provided, resources are placed"  {
  template statefulset -f $(valuesPath resources)

  [ "$status" -eq 0 ]
  [ "$(
    echo "$output" \
    | yq -r '.spec.template.spec.containers[1].resources' \
    | tee /dev/stderr
    )" = "$(cat <<EOF
{
  "limits": {
    "cpu": "500m",
    "memory": "4Gi"
  },
  "requests": {
    "cpu": "300m",
    "memory": "2Gi"
  }
}
EOF
)" ]
}

@test "StatefulSet: when extraEnv provided, env is templated and placed"  {
  template statefulset -f $(valuesPath extraenv)

  [ "$status" -eq 0 ]
  [ "$(
    echo "$output" \
    | yq -r '.spec.template.spec.containers[1].env[1]' \
    | tee /dev/stderr
    )" = "$(cat <<EOF
{
  "name": "DD_AGENT_HOST",
  "valueFrom": {
    "fieldRef": {
      "fieldPath": "status.hostIP"
    }
  }
}
EOF
)" ]
}
