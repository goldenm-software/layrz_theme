part of '../lml.dart';

class LmlAnalizer extends AbstractAnalyzer {
  @override
  Future<AnalysisResult> analyze(Code code) async {
    return const AnalysisResult(issues: []);
  }
}
