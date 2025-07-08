# network-monitor

A cross platform network monitor tool built with Flutter. It displays a simple
line chart of network traffic for the selected interface and works on both
Windows and Linux.

## Requirements
- [Flutter](https://docs.flutter.dev/get-started/install) SDK

## Running
```
flutter run
```

By default it will monitor the first non-loopback interface. Edit
`readNetworkStats` in `lib/network_stats.dart` to specify a different interface
or modify the logic to list available interfaces.
