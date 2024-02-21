part of '../analyzer.dart';

class DefaultLocalAnalyzer extends AbstractAnalyzer {
  const DefaultLocalAnalyzer();

  @override
  Future<AnalysisResult> analyze(Code code) async {
    final issues = code.invalidBlocks.map((e) => e.issue).toList(
          growable: false,
        );
    return AnalysisResult(issues: issues);
  }
}
