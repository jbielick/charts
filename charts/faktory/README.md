# Faktory Helm Chart

[Faktory](https://github.com/contribsys/faktory) is an open-source background jobs server written on Golang. It have got clients for different programming languages.

## Installing charts from this repo

In order to install charts from this repository, you'll first need to add this repository.

Add the repo named `adwerx` with the command below:

```bash
helm repo add adwerx https://adwerx.github.io/charts
```

## TL;DR;

```bash
$ helm install adwerx/faktory
```

## Installing the Chart

To install the chart with the release name `faktory`:

```bash
$ helm install --name faktory adwerx/faktory
```

The command above deploys Faktory on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `faktory` deployment:

```bash
$ helm delete faktory
```

The command above removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Faktory chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`image.registry` | image | `docker.io`
`image.repository` | Faktory image repository | `contribsys/faktory`
`image.tag` | Faktory image tag | `1.0.1`
`image.pullPolicy` | Faktory image pullPolicy | `IfNotPresent`
`image.pullSecrets` |
`license` | Faktory Pro license | `""`
`password` | Faktory password | `(random generated)`
`passwordExistingSecret.name` | (optional) name of an existing secret to use for the Faktory password | ``
`passwordExistingSecret.key` | (optional) name of a key within an existing secret to use for the Faktory password | ``
`service.type` | Faktory server and UI service type | `ClusterIP`
`service.port` | Faktory server service port | `7419`
`ui.enabled` | flag to expose the Faktory UI in the service | `true`
`ui.service.type` | Faktory server service type | `ClusterIP`
`ui.service.port` | service port for Faktory WebUI | `7420`
`cron` | Faktory Pro cron declarations | ``
`statsd` | Faktory Pro statsd configuration | ``
`updateStrategy.type` | type of updateStrategy for the stateful set | `RollingUpdate`
`ingress.enabled` | if true, an ingress will be created for Faktory | `false`
`ingress.annotations` | ingress annotations | `{}`
`ingress.path` | ingress path | `/`
`ingress.hosts` | ingress hostnames | `[]`
`ingress.tls` | ingress TLS configuration | `[]`
`extraEnv` | map of additional ENV variables to set on the Faktory container | `{}`
`resources` | resource requests and limits | `{}`
`nodeSelector` | node selector labels for pod assignment | `{}`
`tolerations` | toleration for pod assignment | `[]`
`affinity` | affinity for pod assignment | `{}`
`persistence` | Flag for enabling persistent storage | `true`
`persistence.existingClaim` | (optional) Name of an existing PVC to use for persistence | ``
`persistence.size` | Size of persistent volume to allocate | `8Gi`
`persistentVolume.enabled` | If true, create a Persistent Volume Claim | `true`
`persistentVolume.accessModes` | Persistent Volume access modes | `ReadWriteOnce`
`persistentVolume.annotations` | Annotations for Persistent Volume Claim | `{}`
`persistentVolume.existingClaim` | (optional) name of an existing Persistent Volume existing claim to use for persistence | ``
`persistentVolume.size` | Persistent Volume size | `1Gi`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install adwerx/faktory --name faktory \
    --set ui.enabled=false
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install adwerx/faktory --name faktory -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Using Faktory Pro

You can add cron or statsd configuration as YAML heredocs to your values. See the below example:

```yaml
## Faktory Pro cron configuration
## Change to configs are hot-reloaded.
##
cron: |
  # [[cron]]
  #   schedule = "*/5 * * * *"
  #   [cron.job]
  #     type = "FiveJob"
  #     queue = "critical"
  #     [cron.job.custom]
  #       foo = "bar"

## Faktory Pro statsd configuration
## Change to configs are hot-reloaded.
##
statsd: |
  #   [statsd]
  #     # location =
  #     # namespace = "faktory."
  #     # tags = []
  #     # bufferSize = 15
```

Config changes are hot-reloaded by Faktory with a `SIGHUP` signal.
