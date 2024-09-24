class SportsComplex {
  final String imageUrl;
  final String name;
  final double pricePerHour;
  final String location;

  SportsComplex({
    required this.imageUrl,
    required this.name,
    required this.pricePerHour,
    required this.location,
  });

  factory SportsComplex.fromJson(Map<String, dynamic> json) {
    return SportsComplex(
      imageUrl: json['images'][0], // Adjust this based on your API response
      name: json['name'],
      pricePerHour: json['pricePerHour'].toDouble(),
      location: json['city'],
    );
  }
}
