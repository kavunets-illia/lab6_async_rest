class TravelDestination {
  final int id;
  final String title;
  final String description;
  final double price;

  TravelDestination({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory TravelDestination.fromJson(Map<String, dynamic> json) {
    return TravelDestination(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Без назви',
      description: json['body'] ?? 'Опис відсутній',
      price: (150.0 + ((json['id'] ?? 1) * 25)).toDouble(),
    );
  }
}
