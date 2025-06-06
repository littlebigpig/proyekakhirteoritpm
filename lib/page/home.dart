import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tugas2teori/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:tugas2teori/models/country.dart';
import 'package:tugas2teori/services/base_network.dart';
import 'package:tugas2teori/services/exchange_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _address = "Loading...";
  bool _isLoading = true;
  CountryStats? _countryData;
  double _longitude = 0.0;
  final TextEditingController _amountController = TextEditingController();
  double? _exchangeRate;
  double? _convertedAmount;
  String _username = "";

  StreamSubscription? _accelerometerSubscription;
  List<double> _accelerometerValues = [0, 0, 0];
  DateTime _lastShakeTime = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadUsername();
    _accelerometerSubscription = accelerometerEvents.listen(_onAccelerometerEvent);
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
    });
  }

  Future<void> _loadExchangeRate(String currencyCode) async {
    try {
      final rate = await ExchangeService.getExchangeRate(currencyCode);
      if (mounted) {  
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

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      _longitude = position.longitude;
      await _getPlace(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _address = "Location Error";
        _isLoading = false;
      });
    }
  }

  Future<void> _getPlace(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        print("No placemarks found");
        setState(() {
          _address = "Location Unknown";
          _isLoading = false;
        });
        return;
      }

      Placemark placeMark = placemarks[0];
      String country = placeMark.country ?? 'Unknown';
      
      // Add debug prints
      print("Getting data for country: $country");
      final countryData = await BaseNetwork.getCountryData(country);
      print("API Response: $countryData"); // Add this line to see the API response

      setState(() {
        _address = country;
        _countryData = countryData;
        _isLoading = false;
      });

      print("Address: $country");
      // Add debug print for the final state
      print("CountryStats after setState: ${_countryData?.toJson()}");
    } catch (e) {
      print("Error getting address: $e");
      setState(() {
        _address = "Address Error";
        _isLoading = false;
      });
    }
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    const double shakeThreshold = 15.0;
    final now = DateTime.now();

    double deltaX = (event.x - _accelerometerValues[0]).abs();
    double deltaY = (event.y - _accelerometerValues[1]).abs();
    double deltaZ = (event.z - _accelerometerValues[2]).abs();

    if ((deltaX > shakeThreshold || deltaY > shakeThreshold || deltaZ > shakeThreshold) &&
        now.difference(_lastShakeTime) > Duration(seconds: 2)) {
      _lastShakeTime = now;
      // Trigger refresh
      setState(() {
        _isLoading = true;
        _exchangeRate = null;
        _convertedAmount = null;
        _amountController.clear();
      });
      _getCurrentLocation();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refreshed by shake!')),
      );
    }

    _accelerometerValues = [event.x, event.y, event.z];
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
      population: 0, timezones: []
    );

    if (country.currency.code != "N/A" && _exchangeRate == null) {
      _loadExchangeRate(country.currency.code);
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: _isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('Loading...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)
                  ),
                ],
              )
            : Text('Hello, $_username',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
              ),
        centerTitle: false,
        elevation: 2,
        actions: [
          if (!_isLoading)
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _exchangeRate = null;
                  _convertedAmount = null;
                  _amountController.clear();
                });
                _getCurrentLocation();
              },
            ),
        ],
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
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Getting your location...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(CountryStats country) {
    return Column(
      children: [
        // Country Info Card
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
              // Large Flag
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
                  child: country.iso2 != "N/A"
                      ? Image.network(
                    'https://flagcdn.com/h240/${country.iso2.toLowerCase()}.png',
                    height: 240,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.flag, color: Colors.grey[600], size: 80),
                      );
                    },
                  )
                      : Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(Icons.flag, color: Colors.grey[600], size: 80),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Country Name
              Column(
                children: [
                  Text(
                    country.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your Current Location',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Country Details
              if (country.name != "N/A") ...[
                _buildInfoRow(Icons.location_city, "Capital", country.capital),
                _buildInfoRow(Icons.people, "Population", _formatNumber(country.population)),
                _buildInfoRow(Icons.access_time, "Local Time", _getLocalTime(country.timezones[0])),
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
                      labelText: 'USD to ${country.currency.code}',
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

        // Action Buttons
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _buildActionButton(
                onPressed: () => context.push(Routes.NestedMapSample),
                icon: Icons.map_outlined,
                label: 'Track Location',
                subtitle: 'View on interactive map',
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[600]!],
                ),
              ),
              SizedBox(height: 20),
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

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required String subtitle,
    required Gradient gradient,
  }) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
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

  String _getLocalTime(String timezone) {
    try {
      final double utcOffset = _longitude / 15.0;
      
      final now = DateTime.now().toUtc();
      final localTime = now.add(Duration(hours: utcOffset.round()));
      
      return "${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "N/A";
    }
  }
}