import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[800]!, Colors.blue[200]!
            ],
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