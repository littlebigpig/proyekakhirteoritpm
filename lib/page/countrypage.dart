import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tugas2teori/models/rest_country.dart';

class CountryListPage extends StatefulWidget {
  const CountryListPage({Key? key}) : super(key: key);

  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  List<RestCountry> countries = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries([String? query]) async {
    setState(() => isLoading = true);
    
    try {
      final response = await http.get(Uri.parse(
        query?.isNotEmpty == true
            ? 'https://restcountries.com/v3.1/name/$query'
            : 'https://restcountries.com/v3.1/all'
      ));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          countries = data.map((country) => RestCountry.fromJson(country)).toList();
          countries.sort((a, b) => a.name.compareTo(b.name));
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          countries = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching countries: $e');
      setState(() {
        countries = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'Countries List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: const Color.fromARGB(255, 93, 182, 255),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search countries...',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color.fromARGB(255, 128, 198, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70),
                  onPressed: () {
                    _searchController.clear();
                    fetchCountries();
                  },
                ),
              ),
              onChanged: (value) {
                if (value.length >= 2) {
                  fetchCountries(value);
                } else if (value.isEmpty) {
                  fetchCountries();
                }
              },
            ),
          ),
          // List View
          Expanded(
            child: isLoading 
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 93, 182, 255)),
                      ),
                      SizedBox(height: 16),
                      Text('Loading countries...'),
                    ],
                  ),
                )
              : countries.isEmpty
                ? const Center(
                    child: Text(
                      'No countries found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              'https://flagsapi.com/${country.code}/flat/64.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.flag, size: 30),
                            ),
                          ),
                          title: Text(
                            country.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Local Time: ${country.getLocalTime()}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () => context.push('/country/detail/${Uri.encodeComponent(country.name)}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
