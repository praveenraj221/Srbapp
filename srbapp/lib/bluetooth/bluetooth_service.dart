import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  final Function(double) onDataReceived;
  late BluetoothDevice? _device;

  BluetoothService({required this.onDataReceived});

  Future<void> connect() async {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.name == "ESP32") {
          await FlutterBluePlus.stopScan();
          _device = r.device;
          await _device?.connect();
          discoverServices();
          break;
        }
      }
    });
  }

  Future<void> discoverServices() async {
    var services = await _device?.discoverServices();
    for (var service in services!) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            final str = utf8.decode(value);
            final parsed = double.tryParse(str);
            if (parsed != null) {
              onDataReceived(parsed);
            }
          });
        }
      }
    }
  }

  Future<void> disconnect() async {
    await _device?.disconnect();
  }
}
