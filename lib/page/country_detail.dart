import 'package:flutter/material.dart';
import 'package:tugas2teori/models/country.dart';
import 'package:tugas2teori/services/base_network.dart';
import 'package:tugas2teori/services/exchange_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryDetailPage extends StatefulWidget {
  final String countryName;

  const CountryDetailPage({
    Key? key,
    required this.countryName,
  }) : super(key: key);

  @override
  _CountryDetailPageState createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends State<CountryDetailPage> {
  bool _isLoading = true;
  CountryStats? _countryData;
  List<double> _latlng = [0, 0]; // Default coordinates
  final TextEditingController _amountController = TextEditingController();
  double? _exchangeRate;
  double? _convertedAmount;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadCountryData();
  }

  Future<void> _loadCountryData() async {
    try {
      // Load main country data from api-ninjas
      final countryData = await BaseNetwork.getCountryData(widget.countryName);
      
      // Get lat/lng from REST Countries API
      try {
        final response = await http.get(
          Uri.parse('https://restcountries.com/v3.1/name/${Uri.encodeComponent(widget.countryName)}?fullText=true')
        );
        
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            final latlngData = data[0]['latlng'] as List<dynamic>?;
            if (latlngData != null) {
              _latlng = latlngData.map((coord) {
                if (coord is int) return coord.toDouble();
                if (coord is double) return coord;
                if (coord is String) return double.tryParse(coord) ?? 0.0;
                return 0.0;
              }).toList();
              
              // Ensure we have 2 coordinates
              while (_latlng.length < 2) {
                _latlng.add(0.0);
              }
            }
          }
        }
      } catch (e) {
        print('Error fetching coordinates: $e');
      }

      setState(() {
        _countryData = countryData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading country data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadExchangeRate(String currencyCode) async {
    try {
      final rate = await ExchangeService.getExchangeRate(currencyCode);
      if (mounted) {  // Check if widget is still mounted before setState
        setState(() {
          _exchangeRate = rate;
          _convertedAmount = null;
          _amountController.clear();
        });
      }
    } catch (e) {
      print('Error loading exchange rate: $e');
    }
  }

  void _convertCurrency(String amount) {
    if (amount.isEmpty || _exchangeRate == null) {
      setState(() => _convertedAmount = null);
      return;
    }

    try {
      final inputAmount = double.parse(amount);
      setState(() => _convertedAmount = inputAmount * _exchangeRate!);
    } catch (e) {
      print('Error converting currency: $e');
      setState(() => _convertedAmount = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final country = _countryData ?? CountryStats(
      name: "N/A",
      iso2: "N/A",
      capital: "N/A",
      gdp: 0,
      currency: Currency(name: "N/A", code: "N/A"),
      telephoneCountryCodes: [],
      population: 0,
      timezones: []
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.countryName,
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? _buildLoadingContent()
            : _buildMainContent(country),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
            ),
            SizedBox(height: 16),
            Text('Loading country data...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(CountryStats country) {
    // Load exchange rate when country data is available
    if (country.currency.code != "N/A" && _exchangeRate == null) {
      _loadExchangeRate(country.currency.code);
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flag
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: country.iso2 != "N/A"
                      ? Image.network(
                          'https://flagcdn.com/h240/${country.iso2.toLowerCase()}.png',
                          height: 240,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.flag, color: Colors.grey[600], size: 80),
                              ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.flag, color: Colors.grey[600], size: 80),
                        ),
                ),
              ),

              SizedBox(height: 24),

              // Country Details
              if (country.name != "N/A") ...[
                _buildInfoRow(Icons.location_city, "Capital", country.capital),
                _buildInfoRow(Icons.people, "Population", _formatNumber(country.population)),
                _buildInfoRow(Icons.attach_money, "GDP", "\$${_formatNumber(country.gdp)}"),
                _buildInfoRow(Icons.monetization_on, "Currency", "${country.currency.name} (${country.currency.code})"),
                _buildInfoRow(Icons.phone, "Phone Codes", country.telephoneCountryCodes.join(", ")),

                // Currency Converter
                if (_exchangeRate != null) ...[
                  Divider(height: 32),
                  Text(
                    'Currency Converter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount in USD',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: _convertCurrency,
                  ),
                  SizedBox(height: 16),
                  if (_convertedAmount != null)
                    Text(
                      '${_amountController.text} USD = ${_formatNumber(_convertedAmount!)} ${country.currency.code}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue[600], size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(num number) {
    if (number >= 1000000000000) { // Trillion
      return '${(number / 1000000000000).toStringAsFixed(1)}T';
    } else if (number >= 1000000000) { // Billion
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) { // Million
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) { // Thousand
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}