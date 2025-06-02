class Currency {
  final String code;
  final String name;

  Currency({required this.code, required this.name});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}

class CountryStats {
  final double gdp; // Changed from int to double
  final Currency currency;
  final String iso2;
  final String capital;
  final int population;
  final String name;
  final List<String> telephoneCountryCodes;
  final List<String> timezones; // Add this field

  CountryStats({
    required this.gdp,
    required this.currency,
    required this.iso2,
    required this.capital,
    required this.population,
    required this.name,
    required this.telephoneCountryCodes,
    required this.timezones,
  });

  factory CountryStats.fromJson(Map<String, dynamic> json) {
    try {
      print("Starting JSON parsing for country: ${json['name']}");

      // Handle currency parsing separately
      Currency parsedCurrency;
      try {
        parsedCurrency = Currency(
          name: json['currency']?['name']?.toString() ?? 'N/A',
          code: json['currency']?['code']?.toString() ?? 'N/A',
        );
      } catch (e) {
        print("Error parsing currency: $e");
        parsedCurrency = Currency(name: 'N/A', code: 'N/A');
      }

      // Handle telephone codes parsing
      List<String> phoneCodes;
      try {
        phoneCodes = (json['telephone_country_codes'] as List?)
                ?.map((e) => e.toString())
                .toList() ?? [];
      } catch (e) {
        print("Error parsing phone codes: $e");
        phoneCodes = [];
      }

      // Handle population parsing with type checking and conversion
      var populationValue = json['population'];
      int population;

      if (populationValue is int) {
        population = populationValue * 1000; // Convert millions to billions
      } else if (populationValue is String) {
        population = (int.tryParse(populationValue) ?? 0) * 1000;
      } else if (populationValue is double) {
        population = (populationValue * 1000).toInt();
      } else {
        population = 0;
      }

      // Handle GDP parsing with conversion
      var gdpValue = json['gdp'];
      double gdp;

      if (gdpValue is num) {
        gdp = (gdpValue * 1000000).toDouble(); // Convert millions to trillions
      } else {
        gdp = double.tryParse(gdpValue?.toString() ?? '0')?.toDouble() ?? 0.0;
        gdp *= 1000000; // Convert millions to trillions
      }

      // Parse timezone
      List<String> timezones = [];
      var timezoneData = json['timezone'];
      if (timezoneData != null) {
        timezones.add(timezoneData.toString());
      } else {
        timezones.add('UTC');
      }

      // Create CountryStats with careful type conversion
      return CountryStats(
        name: json['name']?.toString() ?? 'N/A',
        iso2: json['iso2']?.toString() ?? 'N/A',
        capital: json['capital']?.toString() ?? 'N/A',
        gdp: gdp,
        currency: parsedCurrency,
        telephoneCountryCodes: phoneCodes,
        population: population,
        timezones: timezones,
      );
    } catch (e) {
      print("Error parsing CountryStats: $e");
      print("Problematic JSON: $json");
      // Return a default object instead of rethrowing
      return CountryStats(
        name: 'Error',
        iso2: 'N/A',
        capital: 'N/A',
        gdp: 0.0,
        currency: Currency(name: 'N/A', code: 'N/A'),
        telephoneCountryCodes: [],
        population: 0,
        timezones: ['UTC'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'gdp': gdp,
      'currency': currency.toJson(),
      'iso2': iso2,
      'capital': capital,
      'population': population,
      'name': name,
      'telephone_country_codes': telephoneCountryCodes,
      'timezones': timezones,
    };
  }
}
