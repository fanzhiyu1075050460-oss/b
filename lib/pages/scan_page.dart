import 'package:flutter/material.dart';
import '../services/ocr_service.dart';
import '../services/parse_rule.dart';
import '../services/db_helper.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final TextEditingController _periodController = TextEditingController();
  String _status = '';
  List<HeadRecord> _results = [];

  Future<void> _startScan(ImageSource source) async {
    final period = _periodController.text.trim();
    if (period.isEmpty) {
      setState(() => _status = '请先输入期数');
      return;
    }

    setState(() => _status = '正在识别...');

    final text = await OcrService.pickAndRecognize(source);
    if (text == null) {
      setState(() => _status = '未选择图片');
      return;
    }

    final records = ParseRule.parse(text, targetPeriod: period);

    if (records.isEmpty) {
      setState(() => _status = '未识别到相关内容');
      return;
    }

    await DbHelper.insertRecords(records);

    setState(() {
      _results = records;
      _status = '识别完成，已保存 ${records.length} 条';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('识别头数')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _periodController,
              decoration: const InputDecoration(
                labelText: '输入期数（如254）',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startScan(ImageSource.camera),
                    icon: const Icon(Icons.camera),
                    label: const Text('拍照识别'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startScan(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text('相册选择'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(_status),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, i) {
                  final r = _results[i];
                  return Card(
                    child: ListTile(
                      title: Text(r.head),
                      subtitle: Text(r.content),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
