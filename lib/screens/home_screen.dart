import 'package:flutter/material.dart';
import '../widgets/custom_button.dart'; // Importez le bouton personnalisé (si vous le créez)

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[200]!, Colors.blue[800]!
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Bienvenue sur Météo en Temps Réel !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Découvrez la météo actuelle et visualisez les résultats sur une carte interactive.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
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
    );
  }
}