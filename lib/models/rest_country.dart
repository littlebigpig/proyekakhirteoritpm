class RestCountry {
  final String name;
  final String code;
  final List<double> latlng;

  RestCountry({
    required this.name,
    required this.code,
    required this.latlng,
  });

  factory RestCountry.fromJson(Map<String, dynamic> json) {
    final latlngData = json['latlng'] as List?;
    final List<double> coordinates = [];
    
    if (latlngData != null) {
      for (var coord in latlngData) {
        if (coord is int) {
          coordinates.add(coord.toDouble());
        } else if (coord is double) {
          coordinates.add(coord);
        } else if (coord is String) {
          coordinates.add(double.tryParse(coord) ?? 0.0);
        }
      }
    }

    // Ensure we always have 2 coordinates, even if data is missing
    while (coordinates.length < 2) {
      coordinates.add(0.0);
    }

    return RestCountry(
      name: json['name']['common'] ?? 'N/A',
      code: json['cca2'] ?? 'N/A',
      latlng: coordinates,
    );
  }

  String getLocalTime() {
    try {
      // Calculate UTC offset based on longitude
      final double longitude = latlng[1];
      final double utcOffset = longitude / 15.0; // 15 degrees = 1 hour
      
      final now = DateTime.now().toUtc();
      final localTime = now.add(Duration(hours: utcOffset.round()));
      
      return "${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "N/A";
    }
  }
}