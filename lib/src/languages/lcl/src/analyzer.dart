part of '../lcl.dart';

class LclAnalizer extends AbstractAnalyzer {
  @override
  Future<AnalysisResult> analyze(Code code) async {
    return const AnalysisResult(issues: []);
  }
}
