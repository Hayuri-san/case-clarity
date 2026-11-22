String relativeTime(DateTime dateTime, {DateTime? now}) {
  final difference = (now ?? DateTime.now()).difference(dateTime);
  if (difference.isNegative) return 'just now';
  if (difference.inSeconds < 60) return 'just now';
  if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
  }
  if (difference.inHours < 24) {
    final hours = difference.inHours;
    return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
  }
  if (difference.inDays < 7) {
    final days = difference.inDays;
    return '$days ${days == 1 ? 'day' : 'days'} ago';
  }
  final weeks = (difference.inDays / 7).floor();
  if (weeks < 5) return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
  final months = (difference.inDays / 30).floor();
  if (months < 12) return '$months ${months == 1 ? 'month' : 'months'} ago';
  final years = (difference.inDays / 365).floor();
  return '$years ${years == 1 ? 'year' : 'years'} ago';
}
