.PHONY: analyze
analyze:
	flutter analyze

.PHONY: test
test:
	flutter test

.PHONY: coverage
coverage:
	flutter test --coverage
	@dart run tools/coverage_report.dart

.PHONY: coverage-summary
coverage-summary:
	flutter test --coverage
	@dart run tools/coverage_report.dart --summary
