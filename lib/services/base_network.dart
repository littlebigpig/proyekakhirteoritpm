import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas2teori/models/country.dart';
import '../config/api_config.dart';

class BaseNetwork {
  static Future<CountryStats?> getCountryData(String countryName) async {
    try {
      print("Fetching data for country: $countryName");
      final response = await http.get(
        Uri.parse('${ApiConfig.NINJA_BASE_URL}/country?name=$countryName'),
        headers: ApiConfig.NINJA_HEADERS,
      );

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          print("Parsed JSON Data: ${jsonData[0]}");
          return CountryStats.fromJson(jsonData[0]);
        } else {
          print("Empty JSON response for country: $countryName");
        }
      } else {
        print("API Error: Status ${response.statusCode}");
      }
      return null;
    } catch (e) {
      print("Error fetching country data: $e");
      return null;
    }
  }
}
