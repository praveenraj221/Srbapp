import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../bluetooth/bluetooth_service.dart';

class ReadingScreen extends StatefulWidget {
  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  List<ChartData> data = [];
  late BluetoothService bluetoothService;

  @override
  void initState() {
    super.initState();
    bluetoothService = BluetoothService(onDataReceived: _onNewData);
    bluetoothService.connect(); // Starts scanning + connection
  }

  void _onNewData(double value) {
    setState(() {
      data.add(ChartData(DateTime.now(), value));
      if (data.length > 50) data.removeAt(0);
    });
  }

  @override
  void dispose() {
    bluetoothService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vitalograph")),
      body: SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        series: <LineSeries<ChartData, DateTime>>[
          LineSeries<ChartData, DateTime>(
            dataSource: data,
            xValueMapper: (ChartData d, _) => d.time,
            yValueMapper: (ChartData d, _) => d.value,
          )
        ],
      ),
    );
  }
}

class ChartData {
  final DateTime time;
  final double value;

  ChartData(this.time, this.value);
}
