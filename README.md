# network-monitor

A cross platform network monitor tool built with Flutter. It displays a simple
line chart of network traffic for the selected interface and works on both
Windows and Linux.

## Requirements
- [Flutter](https://docs.flutter.dev/get-started/install) SDK

## Running
You can run the application directly with Flutter or via the provided Makefile.

```
make run
```

Before running for the first time, install dependencies:

```
make install-deps
```

### Docker

If you don't have Flutter installed locally you can run it inside a Docker
container:

```
make run-docker
```

### Building

To build a release binary for Linux:

```
make build
```

And for Windows:

```
make build-windows
```

By default it will monitor the first non-loopback interface. Edit
`readNetworkStats` in `lib/network_stats.dart` to specify a different interface
or modify the logic to list available interfaces.
