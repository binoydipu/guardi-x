String timeAgo(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt);

  if (difference.inDays >= 365) {
    return '${(difference.inDays / 365).floor()} y ago';
  } else if (difference.inDays >= 30) {
    return '${(difference.inDays / 30).floor()} m ago';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays} d ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} h ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} m ago';
  } else {
    return 'Just now';
  }
}
