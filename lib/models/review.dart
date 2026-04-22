class Review {
  final String reviewerName;
  final double rating;
  final String date;
  final String comment;
  final int helpfulCount;

  const Review({
    required this.reviewerName,
    required this.rating,
    required this.date,
    required this.comment,
    this.helpfulCount = 0,
  });
}
