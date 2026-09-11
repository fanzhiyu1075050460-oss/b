import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {类_HistoryPageState扩展State<HistoryPage> {
  List<Map<String, dynamic>> _records = [];列表<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DbHelper.getAll();最终数据 =等待DbHelper.getAll();
    setState(() => _records = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(返回Scaffold(
      appBar: AppBar(title: const Text('历史记录')),
      body: ListView.builder(主体：ListView.builder(
        itemCount: _records.length,
        itemBuilder: (context, i) {
          final r = _records[i];
          return ListTile(返回ListTile(
            title: Text('${r['period''时期']}期 - ${r['head']}'),
            subtitle: Text(r['content'] ?? ''),
            trailing: IconButton(尾部：IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async { onPressed: ()异步 {
                await DbHelper.delete(r['id']);等待DbHelper.delete(r['id']);
                _load();
              },
            ),
          );
        },
      ),
    );
  }
}
