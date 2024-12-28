import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Categorias extends StatefulWidget {
  const Categorias({super.key});

  @override
  State<Categorias> createState() => _CategoriasState();
}


class _CategoriasState extends State<Categorias> {
  final _nombreController = TextEditingController();


  ///Función para agregar una nueva Categoría desde la App
  Future<void> agregarCategoria(String nombre) async {
    CollectionReference categorias = FirebaseFirestore.instance.collection('categorias');

    return categorias
        .add({'nombre': nombre})
        .then((value) => print("Categoría agregada"))
        .catchError((error) => print("Error al agregar categoría: $error"));
  }
  void _Alerta_exito() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Registro éxitoso!',
      autoCloseDuration: Duration(seconds: 2), // Duración de la alerta
    );
    // Esperar 2 segundos y luego redirigir al usuario a Home
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  void _Alerta_error() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Error",
      text: "El nombre de la categoría no puede estar vacío",
      confirmBtnText: "OK",
      autoCloseDuration: Duration(seconds: 2), // Duración de la alerta
    );
    // Esperar 2 segundos y luego redirigir al usuario a Home
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar nueva categoría'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Image.network('https://cdn-icons-png.flaticon.com/512/1174/1174008.png',
                width: 220, height: 220,),
              const SizedBox(height: 5,),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                    labelText: 'Nombre'),
              ),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {

                  // Validar que el campo no esté vacío
                  if (_nombreController.text.isNotEmpty) {
                    agregarCategoria(_nombreController.text); // Llamar a la función para agregar la categoría
                    _nombreController.clear(); // Limpiar el campo de texto después de guardar
                    _Alerta_exito();
                  } else {
                    // Mostrar alerta si el campo está vacío
                    _Alerta_error();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 20,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.pink.shade700,
                  minimumSize: const Size.fromHeight(60),
                ),
                child: Text('Agregar Categoría'),
              ),
            ],
          ),
        )
    );
  }
}
