import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutterprojet/main.dart';
import 'package:flutterprojet/widgets/custom_button.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [Colors.grey[800]!, Colors.grey[900]!]
        : [Colors.blue[500]!, Colors.blue[200]!];
    
    return Scaffold(

      appBar: AppBar(
        
        centerTitle: true,
        backgroundColor: isDark ? Colors.grey[800]!: Colors.blue[500]!,
        elevation: 0,

        

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(

          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Image(image: AssetImage("assets/images/meteo.png")),

                const Text(
                  'Bienvenue sur Météo en Temps Réel !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Découvrez la météo actuelle et visualisez les résultats sur une carte interactive.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),
                
                CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/main');
                  },
                  text: 'Commencer l\'expérience',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}