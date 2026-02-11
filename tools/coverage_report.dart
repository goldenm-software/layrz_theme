// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) {
  final summaryOnly = args.contains('--summary');

  final file = File('coverage/lcov.info');
  if (!file.existsSync()) {
    print('No coverage/lcov.info found. Run "flutter test --coverage" first.');
    exit(1);
  }

  final lines = file.readAsLinesSync();
  final files = <String, ({int hit, int total})>{};
  String? currentFile;
  int hit = 0;
  int total = 0;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3);
      hit = 0;
      total = 0;
    } else if (line.startsWith('DA:')) {
      final count = int.parse(line.split(',').last);
      total++;
      if (count > 0) hit++;
    } else if (line == 'end_of_record' && currentFile != null) {
      files[currentFile] = (hit: hit, total: total);
      currentFile = null;
    }
  }

  if (files.isEmpty) {
    print('No coverage data found.');
    exit(1);
  }

  int totalHit = 0;
  int totalLines = 0;
  int coveredFiles = 0;

  for (final entry in files.entries) {
    totalHit += entry.value.hit;
    totalLines += entry.value.total;
    if (entry.value.hit > 0) coveredFiles++;
  }

  final totalPct = totalLines > 0 ? (totalHit / totalLines * 100) : 0.0;

  // Summary
  print('');
  print('Coverage: ${totalPct.toStringAsFixed(1)}% ($totalHit / $totalLines lines)');
  print('Files with coverage: $coveredFiles / ${files.length}');

  if (summaryOnly) {
    print('');
    return;
  }

  // Per-file table
  print('');
  print('${'File'.padRight(60)} ${'Lines'.padLeft(7)} ${'Covered'.padLeft(9)} ${'%'.padLeft(7)}');
  print('${'─' * 60} ${'─' * 7} ${'─' * 9} ${'─' * 7}');

  final sorted = files.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

  for (final entry in sorted) {
    final name = entry.key.replaceFirst('lib/', '').replaceAll('\\', '/');
    final display = name.length > 58 ? '...${name.substring(name.length - 55)}' : name;
    final pct = entry.value.total > 0 ? (entry.value.hit / entry.value.total * 100) : 0.0;

    print(
      '${display.padRight(60)} ${entry.value.total.toString().padLeft(7)} ${entry.value.hit.toString().padLeft(9)} ${pct.toStringAsFixed(1).padLeft(6)}%',
    );
  }

  print('${'─' * 60} ${'─' * 7} ${'─' * 9} ${'─' * 7}');
  print(
    '${'TOTAL'.padRight(60)} ${totalLines.toString().padLeft(7)} ${totalHit.toString().padLeft(9)} ${totalPct.toStringAsFixed(1).padLeft(6)}%',
  );
  print('');
}
