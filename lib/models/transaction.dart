class Transaction {
  final String id;
  final String title;
  final int isIncome;
  final double amount;
  final DateTime date;
  final String category;

  Transaction({
    required this.id,
    required this.isIncome,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}
