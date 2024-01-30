part of '../python.dart';

class PythonAnalizer extends AbstractAnalyzer {
  @override
  Future<AnalysisResult> analyze(Code code) async {
    return const AnalysisResult(issues: []);
  }
}
