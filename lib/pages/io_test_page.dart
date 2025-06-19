import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;

class IOTestPage extends StatefulWidget {
  const IOTestPage({super.key});

  @override
  State<IOTestPage> createState() => _IOTestPageState();
}

class _IOTestPageState extends State<IOTestPage> {
  int _threadCount = 4;
  int _ioSizeKB = 10; // IO Read/Write Content Length (MB)
  bool _isTesting = false;
  String _log = '';

  // Multithreaded IO Test Launch Method
  Future<void> _startIOTest() async {
    if (kIsWeb) {
      // Prompt Message or Disable IO Test Button
      setState(() {
        _log =
            'Multithreaded IO performance testing is only supported on mobile or desktop platforms.';
        _isTesting = false;
      });
      return;
    }
    setState(() {
      _isTesting = true;
      _log = 'Test in Progress...\n';
    });

    final tempDir = await getTemporaryDirectory();
    final testData = List.generate(
      _ioSizeKB * 1024 * 1024,
      (_) => Random().nextInt(256),
    );

    final stopwatch = Stopwatch()..start();

    List<Future> futures = [];
    for (int i = 0; i < _threadCount; i++) {
      futures.add(_runIsolateIO(tempDir.path, i, testData));
    }

    await Future.wait(futures);

    stopwatch.stop();

    setState(() {
      _isTesting = false;
      _log += 'Completed! Time Taken: ${stopwatch.elapsedMilliseconds / 1000} s\n';
    });
  }

  // Execute IO Using Isolate
  Future<void> _runIsolateIO(String path, int threadId, List<int> data) async {
    final completer = Completer<void>();
    final receivePort = ReceivePort();

    await Isolate.spawn(_ioTask, [path, threadId, data, receivePort.sendPort]);
    setState(() {});
    receivePort.listen((message) {
      if (message == 'done') {
        receivePort.close();
        completer.complete();
      }
      if (message is String && message.startsWith('File Name:')) {
        setState(() {
          _log += message;
        });
      }
    });

    await completer.future;
  }

  // Actual IO Task Executed in Isolate
  static Future<void> _ioTask(List args) async {
    String path = args[0];
    int threadId = args[1];
    List<int> data = args[2];
    SendPort sendPort = args[3];

    final file = File(p.join(path, 'test_io_$threadId.txt'));

    // Write Data
    await file.writeAsBytes(data);

    // Read Data
    await file.readAsBytes();

    FileStat stats = await file.stat();
    String fileSize = (stats.size / (1024 * 1024)).toStringAsFixed(2);
    String fileName = p.basename(file.path);
    sendPort.send('File Name: $fileName, File Size: ${fileSize}MB\n');

    // Delete File
    await file.delete();

    sendPort.send('done');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Number of Threads:'),
                Expanded(
                  child: Slider(
                    value: _threadCount.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: '$_threadCount',
                    onChanged:
                        (val) => setState(() => _threadCount = val.toInt()),
                  ),
                ),
                Text('$_threadCount'),
              ],
            ),
            Row(
              children: [
                const Text('IO Size (MB):'),
                Expanded(
                  child: Slider(
                    value: _ioSizeKB.toDouble(),
                    min: 10,
                    max: 1024,
                    divisions: 100,
                    label: '${_ioSizeKB}MB',
                    onChanged: (val) => setState(() => _ioSizeKB = val.toInt()),
                  ),
                ),
                Text('${_ioSizeKB}MB'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isTesting ? null : _startIOTest,
              child: Text(
                _isTesting ? 'Testing...' : 'Start IO Performance Test',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: Text(_log))),
          ],
        ),
      ),
    );
  }
}
