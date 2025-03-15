import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';
import 'package:flutterprojet/main.dart';
import 'package:flutterprojet/models/weather.dart';
import 'package:flutterprojet/models/ville.dart';
import 'package:flutterprojet/models/external_city.dart';
import 'package:flutterprojet/screens/detail_ville_screen.dart';
import 'package:flutterprojet/services/weather_service.dart';
import 'package:flutterprojet/widgets/bottom_app_bar_widget.dart';
import '../utils/constants.dart';

class ListVilleScreen extends StatefulWidget {
  const ListVilleScreen({super.key});

  @override
  State<ListVilleScreen> createState() => _ListVilleScreenState();
}

class _ListVilleScreenState extends State<ListVilleScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Liste complète des villes externes chargées depuis le fichier JSON
  List<ExternalCity> _allExternalCities = [];

  // Liste des villes affichées avec les données météo (objet Ville)
  List<Ville> _displayedCities = [];
  List<Ville> _filteredCities = [];

  // Pagination
  final int _pageSize = 10;
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoadingPage = false;

  late WeatherService _weatherService;

  @override
  void initState() {
    super.initState();
    _weatherService = WeatherService(Dio());
    _loadExternalCities().then((_) {
      _fetchNextPage();
    });

    // Ecoute les changements dans le champ de recherche
    _searchController.addListener(() {
      setState(() {
        _filterCities(_searchController.text);
      });
    });

    // Ecoute du défilement pour la pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingPage &&
          _hasMore &&
          _searchController.text.isEmpty) {
        _fetchNextPage();
      }
    });
  }

  /// Charge le fichier JSON externe (liste de villes) depuis les assets
  Future<void> _loadExternalCities() async {
    try {
      final String jsonString =
      await rootBundle.loadString('assets/city.list.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      setState(() {
        _allExternalCities =
            jsonData.map((e) => ExternalCity.fromJson(e)).toList();
      });
    } catch (e) {
      print("Erreur lors du chargement des villes externes: $e");
    }
  }

  /// Récupère la météo pour un lot de villes (page) et les ajoute à la liste
  Future<void> _fetchNextPage() async {
    if (_isLoadingPage || !_hasMore) return;
    setState(() {
      _isLoadingPage = true;
    });

    int startIndex = _currentPage * _pageSize;
    int endIndex = startIndex + _pageSize;

    if (startIndex >= _allExternalCities.length) {
      setState(() {
        _hasMore = false;
        _isLoadingPage = false;
      });
      return;
    }
    if (endIndex > _allExternalCities.length) {
      endIndex = _allExternalCities.length;
      _hasMore = false;
    }

    List<ExternalCity> nextBatch =
    _allExternalCities.sublist(startIndex, endIndex);

    for (ExternalCity extCity in nextBatch) {
      try {
        // On récupère la météo pour la ville via son nom
        Weather weather = await _weatherService.getWeather(
          extCity.name,
          "metric",
          Constants.openWeatherApiKey,
        );
        Ville ville = Ville.fromWeather(weather);
        _displayedCities.add(ville);
      } catch (e) {
        print("Erreur lors de la récupération de ${extCity.name}: $e");
      }
    }
    _currentPage++;
    setState(() {
      _filteredCities = List.from(_displayedCities);
      _isLoadingPage = false;
    });
  }

  /// Filtre la liste des villes chargées selon la recherche
  void _filterCities(String query) {
    if (query.isEmpty) {
      _filteredCities = List.from(_displayedCities);
    } else {
      _filteredCities = _displayedCities.where((ville) {
        final fullName = '${ville.cityName}, ${ville.country}'.toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Retourne le chemin de l'image correspondant au type de météo (ville.icon)
  String _mapWeatherImagePath(String iconKey) {
    switch (iconKey) {
      case 'sun':
        return 'assets/images/sun01.png';
      case 'cloud':
        return 'assets/images/nc03.png';
      case 'storm':
        return 'assets/images/nc03.png';
      case 'rain':
        return 'assets/images/nc03.png';
      default:
        return 'assets/images/nc03.png'; // Par défaut
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [Colors.grey[800]!, Colors.grey[900]!]
        : [Colors.blue[500]!, Colors.blue[200]!];

    return Scaffold(
      // Bouton flottant central
      floatingActionButton: const BottomPlus(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBarWidget(),

      appBar: AppBar(
        title: const Text(
          'Météo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.grey[800]!: Colors.blue[500]!,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          IconButton(
                icon: Icon(
                  MyApp.of(context).isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                  color: Colors.white,
                ),
                onPressed: () {
                  MyApp.of(context).toggleTheme();
                },
              ),
        ],

      ),

      body: Container(
        // Fond bleu
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Barre de recherche
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Rechercher une ville',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Liste dynamique des villes
              Expanded(
                child: _displayedCities.isEmpty && _searchController.text.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredCities.length + (_isLoadingPage ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _filteredCities.length) {
                      // Indicateur de chargement en bas
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut,
                            builder: (context, opacity, child) {
                              return Opacity(
                                opacity: opacity,
                                child: RotationTransition(
                                  turns: AlwaysStoppedAnimation(opacity),
                                  child: const CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                      );

                    }
                    final ville = _filteredCities[index];
                    return VilleCard(
                      ville: ville,
                      weatherImagePath: _mapWeatherImagePath(ville.icon),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget pour afficher une ligne (température, ville, pays, min/max) + **image** météo
class VilleCard extends StatelessWidget {
  final Ville ville;
  final String weatherImagePath;

  const VilleCard({
    Key? key,
    required this.ville,
    required this.weatherImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => DetailVilleScreen(ville: ville))
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ville.temperature.toStringAsFixed(0)}°',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                    '${ville.cityName}, ${ville.country}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                ),
              ],
            ),

            // Image météo + min/max
            Column(
              children: [
                Image.asset(
                  weatherImagePath,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 1),
                Text(
                  'H:${ville.tempMax.toStringAsFixed(0)}°  L:${ville.tempMin.toStringAsFixed(0)}°',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

          ],

        ),

      ),
    );

  }
}
