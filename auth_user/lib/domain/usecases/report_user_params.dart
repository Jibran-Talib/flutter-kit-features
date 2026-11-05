class ReportUserParams {
  final String userId;
  final String reason;

  const ReportUserParams({required this.userId, required this.reason});

  Map<String, dynamic> toJson() => {'userId': userId, 'reason': reason};
}
