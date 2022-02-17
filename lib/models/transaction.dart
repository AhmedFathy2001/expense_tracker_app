class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime createdAt;

  Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.createdAt});

  List<dynamic> toJson() {
    return [
      id,
      title,
      amount,
      createdAt.toIso8601String(),
    ];
  }
}
