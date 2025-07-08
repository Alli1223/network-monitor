import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'network_stats.dart';

void main() {
  runApp(const NetworkMonitorApp());
}

class NetworkMonitorApp extends StatelessWidget {
  const NetworkMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NetworkMonitorHome(),
    );
  }
}

class NetworkMonitorHome extends StatefulWidget {
  const NetworkMonitorHome({super.key});

  @override
  State<NetworkMonitorHome> createState() => _NetworkMonitorHomeState();
}

class _NetworkMonitorHomeState extends State<NetworkMonitorHome> {
  final List<FlSpot> _rxData = [];
  final List<FlSpot> _txData = [];
  late Timer _timer;
  late DateTime _start;

  @override
  void initState() {
    super.initState();
    _start = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final stats = await readNetworkStats();
      final seconds = DateTime.now().difference(_start).inSeconds.toDouble();
      setState(() {
        _rxData.add(FlSpot(seconds, stats.rx.toDouble()));
        _txData.add(FlSpot(seconds, stats.tx.toDouble()));
        if (_rxData.length > 60) {
          _rxData.removeAt(0);
          _txData.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Monitor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              LineChartBarData(spots: _rxData, color: Colors.blue),
              LineChartBarData(spots: _txData, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
