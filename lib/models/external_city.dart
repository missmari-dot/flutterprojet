class ExternalCity {
  final int id;
  final String name;
  final String country;

  ExternalCity({
    required this.id,
    required this.name,
    required this.country,
  });

  factory ExternalCity.fromJson(Map<String, dynamic> json) {
    return ExternalCity(
      id: (json['id'] as num).toInt(), // Conversion du nombre en int
      name: json['name'] as String,
      country: json['country'] as String,
    );
  }
}
