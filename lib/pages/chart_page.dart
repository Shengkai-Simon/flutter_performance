import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/chart_painter.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<double> _barData = [];
  List<double> _lineData = [];
  Timer? _chartTimer;
  bool _isAutoRefresh = false;
  int _refreshInterval = 3;

  @override
  void initState() {
    super.initState();
    _generateChartData();
  }

  @override
  void dispose() {
    _chartTimer?.cancel();
    _chartTimer = null;
    super.dispose();
  }

  void _generateChartData() {
    setState(() {
      _barData = List.generate(12, (i) => 20 + 60 * math.Random().nextDouble());
      _lineData = List.generate(12, (i) => 10 + 70 * math.Random().nextDouble());
    });
  }

  void _toggleAutoRefresh() {
    setState(() {
      _isAutoRefresh = !_isAutoRefresh;
      if (_isAutoRefresh) {
        _chartTimer = Timer.periodic(Duration(seconds: _refreshInterval), (timer) {
          _generateChartData();
        });
      } else {
        _chartTimer?.cancel();
        _chartTimer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _generateChartData,
              child: const Text('Refresh Data'),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _toggleAutoRefresh,
              child: Text(_isAutoRefresh ? 'Stop Auto Refresh' : 'Start Auto Refresh'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              Text("Refresh Interval: $_refreshInterval Seconds"),
              Expanded(
                child: Slider(
                  value: _refreshInterval.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: "$_refreshInterval",
                  onChanged: (value) {
                    setState(() {
                      _refreshInterval = value.toInt();
                      if (_isAutoRefresh) {
                        _chartTimer?.cancel();
                        _chartTimer = null;
                        _chartTimer = Timer.periodic(Duration(seconds: _refreshInterval), (timer) {
                          _generateChartData();
                        });
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomPaint(
            painter: ChartPainter(barData: _barData, lineData: _lineData),
            child: Container(),
          ),
        ),
      ],
    );
  }
}
