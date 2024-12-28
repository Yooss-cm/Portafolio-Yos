import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:ycm_10ids2/Pages/Menu_hamburguesa.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu_hamburguesa(),  // Aquí llamas al widget del menú lateral
      body: Column(
        children: [
          // Sección superior con AppBar personalizado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra superior con ícono de menú hamburguesa y notificaciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      },
                    ),
                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.notifications,
                    //     color: Colors.white,
                    //     size: 28,
                    //   ),
                    //   onPressed: () {
                    //     // Lógica para el botón de notificaciones
                    //   },
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Bienvenido,\nMe agrada verte de nuevo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Imagen en la parte superior
          Container(
            width: double.infinity,
            height: 500, // Ajusta la altura que quieras para la imagen
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://static.wixstatic.com/media/94d222_c4f1aa638aa4403f8f17e9be2abef074~mv2.gif',
                ),
                fit: BoxFit.contain, // La imagen se ajusta sin recortarse
              ),
            ),
          ),

          // Espacio para el texto o elementos decorativos
          Expanded(
            child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  FadeAnimatedText(
                    'Bienvenido a nuestra aplicación',
                    textStyle: TextStyle(
                      color: Colors.pink.shade900,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FadeAnimatedText(
                    'Aquí podrás encontrar lo que necesitas',
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
