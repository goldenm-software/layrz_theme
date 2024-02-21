part of '../analyzer.dart';

/// Service for analyzing the code inside [CodeField].
///
/// Inherit and implement [analyze] method to use in [CodeController].
abstract class AbstractAnalyzer {
  const AbstractAnalyzer();

  /// Analyzes the code and generates new list of issues.
  Future<AnalysisResult> analyze(Code code);

  void dispose() {}
}
