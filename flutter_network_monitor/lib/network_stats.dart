import 'dart:io';
import 'package:process_run/process_run.dart';

class NetworkStats {
  final int rx;
  final int tx;
  NetworkStats(this.rx, this.tx);
}

Future<NetworkStats> readNetworkStats([String? interface]) async {
  if (Platform.isLinux) {
    final lines = await File('/proc/net/dev').readAsLines();
    final target = interface ?? _firstInterfaceLinux(lines);
    for (final line in lines) {
      if (line.trim().startsWith('$target:')) {
        final parts = line.split(':')[1].trim().split(RegExp(r'\s+'));
        final rx = int.parse(parts[0]);
        final tx = int.parse(parts[8]);
        return NetworkStats(rx, tx);
      }
    }
  } else if (Platform.isWindows) {
    final result = await run('powershell', [
      '-Command',
      'Get-NetAdapterStatistics -Name ${interface ?? '*'} | Format-Table -HideTableHeaders ReceivedBytes,SentBytes'
    ]);
    if (result.exitCode == 0 && result.stdout is String) {
      final lines = (result.stdout as String).trim().split('\n');
      if (lines.isNotEmpty) {
        final parts = lines[0].trim().split(RegExp(r'\s+'));
        if (parts.length >= 2) {
          final rx = int.parse(parts[0]);
          final tx = int.parse(parts[1]);
          return NetworkStats(rx, tx);
        }
      }
    }
  }
  return NetworkStats(0, 0);
}

String _firstInterfaceLinux(List<String> lines) {
  for (final line in lines.skip(2)) {
    final name = line.split(':')[0].trim();
    if (name != 'lo') return name;
  }
  return 'lo';
}
