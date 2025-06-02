import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ExchangeService {
  static Map<String, double>? _rates;

  static Future<double?> getExchangeRate(String targetCurrency) async {
    if (_rates == null) {
      try {
        final response = await http.get(
          Uri.parse('${ApiConfig.EXCHANGE_RATE_BASE_URL}/${ApiConfig.EXCHANGE_RATE_API_KEY}/latest/USD')
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final rates = data['conversion_rates'] as Map<String, dynamic>;
          _rates = rates.map((key, value) => 
            MapEntry(key, (value is int) ? value.toDouble() : value as double)
          );
        } else {
          print('Error fetching exchange rates: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        print('Error fetching exchange rates: $e');
        return null;
      }
    }
    return _rates?[targetCurrency.toUpperCase()];
  }
}