List sortPairsInIsolate(Map<String, dynamic> params) {
  final List pairs = List.from(params['pairs']);
  final bool isReversed = params['isReversed'];

  int compare(a, b) {
    final valueA = a[0];
    final valueB = b[0];

    // Try to parse as number
    final numA = num.tryParse(valueA);
    final numB = num.tryParse(valueB);
    if (numA != null && numB != null) {
      return isReversed ? numB.compareTo(numA) : numA.compareTo(numB);
    }

    // Try to parse as Duration (format HH:mm:ss)
    Duration? parseDuration(String s) {
      final parts = s.split(':');
      if (parts.length == 3) {
        final h = int.tryParse(parts[0]) ?? 0;
        final m = int.tryParse(parts[1]) ?? 0;
        final sec = int.tryParse(parts[2]) ?? 0;
        return Duration(hours: h, minutes: m, seconds: sec);
      }
      return null;
    }

    final durA = parseDuration(valueA);
    final durB = parseDuration(valueB);
    if (durA != null && durB != null) {
      return isReversed ? durB.compareTo(durA) : durA.compareTo(durB);
    }

    // Try to parse as DateTime
    final dateA = DateTime.tryParse(valueA);
    final dateB = DateTime.tryParse(valueB);
    if (dateA != null && dateB != null) {
      return isReversed ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    }

    // Default: compare as string (case insensitive)
    return isReversed
        ? valueB.toLowerCase().compareTo(valueA.toLowerCase())
        : valueA.toLowerCase().compareTo(valueB.toLowerCase());
  }

  pairs.sort(compare);
  return pairs;
}
