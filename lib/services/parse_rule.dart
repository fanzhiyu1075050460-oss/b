class HeadRecord {
  final String period;
  final String head;
  final String content;

  HeadRecord({required this.period, required this.head, required this.content});

  Map<String, dynamic> toMap() => {
    'period': period,
    'head': head,
    'content': content,
  };
}

class ParseRule {
  static const List<String> validHeads = ['0头', '1头', '2头', '3头', '4头'];

  static List<HeadRecord> parse(String text, {required String targetPeriod}) {
    final lines = text.split('\n');
    final results = <HeadRecord>[];

    for (final line in lines) {行){对于 (最终行在行中) {
      if (!line.contains(targetPeriod)) continue继续;如果(!行包含目标时段)继续;如果(!line.contains(targetPeriod)) continue继续;如果(!行包含目标时段)继续;

      for (final head in validHeads) {对于 (最终头在有效头中) {对于 (最终头在有效头中) {对于 (最终头在有效头中) {
        if (line.contains(head)) {如果(行包含头)如果(行包含头)) {如果(行包含头)如果(line.contains(head)) {如果(行包含头)如果(行包含头)) {如果(行包含头)
          results.add(HeadRecord(
            period: targetPeriod,
            head: head,
            content: line.trim(),
          ));
        }
      }
    }

    return results;返回结果；结果；返回结果；结果；返回结果；结果；返回结果；返回results;返回结果；结果；返回结果；结果；返回结果；结果；返回结果；
  }
      }
