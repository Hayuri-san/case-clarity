class DateSuggestion {
  const DateSuggestion({required this.text, required this.date});

  final String text;
  final DateTime? date;
}

List<DateSuggestion> parseDateSuggestions(Iterable<String> values) =>
    values.map((value) => DateSuggestion(text: value, date: parseDateSuggestion(value))).toList();

DateTime? parseDateSuggestion(String value) {
  final text = value.trim();
  final numeric = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})$').firstMatch(text);
  if (numeric != null) {
    return _validDate(
      int.parse(numeric.group(3)!),
      int.parse(numeric.group(2)!),
      int.parse(numeric.group(1)!),
    );
  }

  final named = RegExp(r'^(\d{1,2})\s+([A-Za-z]+)\s+(\d{4})$').firstMatch(text);
  if (named == null) return null;
  const months = {
    'january': 1,
    'february': 2,
    'march': 3,
    'april': 4,
    'may': 5,
    'june': 6,
    'july': 7,
    'august': 8,
    'september': 9,
    'october': 10,
    'november': 11,
    'december': 12,
  };
  final month = months[named.group(2)!.toLowerCase()];
  if (month == null) return null;
  return _validDate(
    int.parse(named.group(3)!),
    month,
    int.parse(named.group(1)!),
  );
}

DateTime? _validDate(int year, int month, int day) {
  final date = DateTime.utc(year, month, day);
  if (date.year != year || date.month != month || date.day != day) return null;
  return date;
}
