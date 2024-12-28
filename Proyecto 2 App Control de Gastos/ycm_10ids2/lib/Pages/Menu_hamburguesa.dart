import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ycm_10ids2/Pages/Category.dart';
import 'package:ycm_10ids2/Pages/GastoLista.dart';
import 'package:ycm_10ids2/Pages/GraficaBarra.dart';
import 'package:ycm_10ids2/Pages/GraficaPastel.dart';
import 'package:ycm_10ids2/Pages/Home.dart';
import 'package:ycm_10ids2/Pages/ListaCategorias.dart';
import 'package:ycm_10ids2/Pages/Login.dart';
import 'package:ycm_10ids2/Pages/PresupuestosLista.dart';
import 'package:ycm_10ids2/Pages/TarjetasSubcategoriasList.dart';

class Menu_hamburguesa extends StatefulWidget {
  @override
  State<Menu_hamburguesa> createState() => _Menu_hamburguesaState();
}

// Función para cerrar sesión
Future<void> _cerrarSesion() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('Sesión cerrada con éxito.');
  } catch (e) {
    print('Error al cerrar sesión: $e');
  }
}

class _Menu_hamburguesaState extends State<Menu_hamburguesa> {
  // Agrega este método en tu clase _Menu_hamburguesaState
  Future<List<Category>> obtenerDatosGrafica(DateTime fechaInicio, DateTime fechaFin) async {
    final gastosCollection = FirebaseFirestore.instance.collection('gastos');
    final querySnapshot = await gastosCollection
        .where('fecha_gasto', isGreaterThanOrEqualTo: fechaInicio)
        .where('fecha_gasto', isLessThanOrEqualTo: fechaFin)
        .get();

    Map<String, double> categoriasGastos = {};
    Map<String, double> subcategoriasGastos = {};

    for (var doc in querySnapshot.docs) {
      final idCategoria = doc['idCategoria'];
      final idSubcategoria = doc['idSubcategoria'];
      final monto = doc['monto'].toDouble();  // Convertir monto a double

      // Obtener el nombre de la categoría
      final categoriaDoc = await FirebaseFirestore.instance.collection('categorias').doc(idCategoria).get();
      final nombreCategoria = categoriaDoc['nombre'];

      // Obtener el nombre de la subcategoría
      final subcategoriaDoc = await FirebaseFirestore.instance.collection('subcategorias').doc(idSubcategoria).get();
      final nombreSubcategoria = subcategoriaDoc['nombre'];

      categoriasGastos.update(nombreCategoria, (value) => value + monto, ifAbsent: () => monto);
      subcategoriasGastos.update(nombreSubcategoria, (value) => value + monto, ifAbsent: () => monto);
    }

    List<Category> categorias = categoriasGastos.entries
        .map((e) => Category(name: e.key, amount: e.value))
        .toList();
    List<Category> subcategorias = subcategoriasGastos.entries
        .map((e) => Category(name: e.key, amount: e.value))
        .toList();

    return [...categorias, ...subcategorias];
  }



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.pink[900]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Image.network('https://cdn-icons-png.flaticon.com/512/5087/5087579.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Usuario',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.pink[900]),
            title: Text('Inicio'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            }, // Cierra el drawer
          ),
          ListTile(
            leading: Icon(Icons.category_rounded, color: Colors.black),
            title: Text('Categoría'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ListaCategorias()));
            },
          ),
          ListTile(
            leading: Icon(Icons.category_outlined, color: Colors.pink[900]),
            title: Text('Subcategorías'),
            onTap: () {
              _mostrarCategoriasDialogo(); // Mostrar el diálogo para seleccionar la categoría
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet_sharp, color: Colors.black),
            title: Text('Tipos de gastos'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GastosLista()));
            },
          ),
          ListTile(
            leading: Icon(Icons.add_card, color: Colors.pink[900]),
            title: Text('Presupuesto'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PresupuestosLista()));
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart, color: Colors.black),
            title: Text('Gráfica de barras'),
            onTap: () => _navegarAGraficaBarras(context),
          ),
          ListTile(
            leading: Icon(Icons.pie_chart, color: Colors.pink[900]),
            title: Text('Gráfica de pastel'),
            onTap: () => _navegarAGraficaPastel(context),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.black),
            title: Text('Cerrar Sesión'),
            onTap: () async {
              await _cerrarSesion();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarCategoriasDialogo() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona una categoría'),
          content: Container(
            width: double.maxFinite,
            height: 300, // Ajusta este valor según tu diseño
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('categorias').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var categorias = snapshot.data!.docs;

                if (categorias.isEmpty) {
                  return Center(child: Text('No hay categorías disponibles.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    var categoria = categorias[index];
                    return Card(
                      color: Colors.pink[50],
                      child: ListTile(
                        leading: Icon(Icons.category, color: Colors.pink[900]),
                        title: Text(categoria['nombre']),
                        onTap: () {
                          // Navegar a la pantalla de subcategorías con la categoría seleccionada
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TarjetasSubcategoriasList(
                                idCategoria: categoria.id,
                                nombre: categoria['nombre'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _navegarAGraficaBarras(BuildContext context) async {
    DateTime fechaInicio = DateTime.now().subtract(Duration(days: 30));
    DateTime fechaFin = DateTime.now().add(Duration(days: 30));

    try {
      List<Category> listaDeCategorias = await obtenerDatosGrafica(fechaInicio, fechaFin);
      if (listaDeCategorias.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GraficaBarra(categories: listaDeCategorias),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay datos disponibles para mostrar las gráficas.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error al obtener los datos.')),
      );
    }
  }

  Future<void> _navegarAGraficaPastel(BuildContext context) async {
    DateTime fechaInicio = DateTime.now().subtract(Duration(days: 30));
    DateTime fechaFin = DateTime.now();
    try {
      List<Category> listaDeCategorias = await obtenerDatosGrafica(fechaInicio, fechaFin);
      if (listaDeCategorias.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GraficaPastel(categories: listaDeCategorias),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay datos disponibles para mostrar las gráficas.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error al obtener los datos.')),
      );
    }
  }
}
