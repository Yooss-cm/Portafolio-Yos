import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class AgregarSubcategoria extends StatefulWidget {
  const AgregarSubcategoria({super.key});

  @override
  _AgregarSubcategoriaState createState() => _AgregarSubcategoriaState();
}

class _AgregarSubcategoriaState extends State<AgregarSubcategoria> {
  final _nombreController = TextEditingController();
  String? _categoriaSeleccionada; // Variable para guardar la categoría seleccionada

  // Función para agregar subcategoría
  Future<void> agregarSubcategoria(String nombre, String idCategoria, String usuario) async {
    CollectionReference subcategorias = FirebaseFirestore.instance.collection('subcategorias');

    return subcategorias
        .add({
      'nombre': nombre,
      'idCategoria': idCategoria, // Guardar el ID de la categoría seleccionada
      'usuario': usuario
    })
        .then((value) => print("Subcategoría agregada"))
        .catchError((error) => print("Error al agregar subcategoría: $error"));
  }

  // Función para cargar las categorías desde Firebase
  Future<List<QueryDocumentSnapshot>> obtenerCategorias() async {
    QuerySnapshot categorias = await FirebaseFirestore.instance.collection('categorias').get();
    return categorias.docs;
  }

  void _mostrarAlertaExito() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Subcategoría agregada con éxito',
      autoCloseDuration: Duration(seconds: 2),
    );
  }

  void _mostrarAlertaError() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Error",
      text: "Por favor complete todos los campos",
      confirmBtnText: "OK",
      autoCloseDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Subcategoría'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: obtenerCategorias(),
        builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar categorías'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay categorías disponibles'));
          } else {
            // Lista de categorías disponibles
            List<QueryDocumentSnapshot> categorias = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonFormField<String>(
                    hint: Text('Selecciona una categoría'),
                    value: _categoriaSeleccionada,
                    items: categorias.map((categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria.id, // ID de la categoría
                        child: Text(categoria['nombre']),
                      );
                    }).toList(),
                    onChanged: (String? valor) {
                      setState(() {
                        _categoriaSeleccionada = valor;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de la subcategoría',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_nombreController.text.isNotEmpty && _categoriaSeleccionada != null) {
                        agregarSubcategoria(
                          _nombreController.text,
                          _categoriaSeleccionada!,
                          'usuarioActual', // Puedes cambiar esto con el ID del usuario autenticado
                        );
                        _nombreController.clear();
                        _mostrarAlertaExito();
                      } else {
                        _mostrarAlertaError();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      elevation: 20,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pink.shade700,
                      minimumSize: const Size.fromHeight(60),
                    ),
                    child: Text('Agregar Subcategoría'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
