# SignalFx Cloud Foundry Agent Buildpack Decorator

This is a decorator built for use with the Cloud Foundry
[meta-buildpack](https://github.com/cf-platform-eng/meta-buildpack).  The
decorator installs the SignalFx collectd agent into the same droplet as the
application being running.  This is useful to monitor web servers running in
the CF Garden environment.

## Usage
First you have to [add the
meta-buildpack](https://github.com/cf-platform-eng/meta-buildpack#how-to-install-the-meta-buildpack)
and this decorator to your Cloud Foundry environment.  To add this decorator,
download a [release zip from
Github](https://github.com/signalfx/signalfx-buildpack-decorator/releases) and
push it to CF with the `create-buildpack` command.

### Configuration

Next, create a directory called `.signalfx` in your app that contains collectd
configuration files specific to what you want to monitor.  This buildpack is
configured out of the box to report only specific metadata about the container
and nothing else (e.g. no metrics for CPU, memory, network, etc.).  Our
[Firehose nozzle](https://github.com/signalfx/signalfx-bridge) sends basic
container metrics (CPU, memory, and disk usage), which might be enough
depending on your needs.  If you do add back these to the collectd config, note
that they will be double reported.

To configure the API token for SignalFx, add an envvar to your application
manifest called `SIGNALFX_ACCESS_TOKEN` with that value.

If you would like to enable system metrics inside the containers (i.e. to be
able to use the collectd dashboards to view your containers), set the envvar
`SIGNALFX_ENABLE_SYSTEM_METRICS` to either `true` or `yes`.  System metrics are
by default disabled, so only the metrics specified by configuration in the
`.signalfx` dir will be sent without this setting.


## Dev Notes
This buildpack depends on our [collectd
bundle](https://github.com/signalfx/collectd-build-bundle).  Grab the desired
bundle archive version (it's a `.tar.gz` file) and stick it in this dir.  Then
run `make signalfx_decorator.zip` to create the buildpack zip with that bundle.
