import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AgregarGastos.dart';
import 'EditarGasto.dart';
import 'Menu_hamburguesa.dart';

class GastosLista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu_hamburguesa(),
      appBar: AppBar(
        title: Text('Lista de Gastos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView( // Envolvemos todo el contenido en un scroll.
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('gastos').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Center(child: Text('No hay gastos registrados.'));
                  }

                  return GridView.builder(
                    shrinkWrap: true, // Ajusta el GridView a su contenido.
                    physics: NeverScrollableScrollPhysics(), // Desactiva el scroll interno del GridView.
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2, // Responsive: cambia la cantidad de columnas según el tamaño de la pantalla.
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.75, // Relación de aspecto para evitar el desbordamiento.
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var gasto = docs[index];

                      return FutureBuilder(
                        future: _getCategoriaYSubcategoriaNombres(gasto['idCategoria'], gasto['idSubcategoria']),
                        builder: (context, AsyncSnapshot<Map<String, String>> catSubcatSnapshot) {
                          if (!catSubcatSnapshot.hasData) {
                            return Card(
                              child: Center(child: Text('Cargando...')),
                            );
                          }

                          String categoriaNombre = catSubcatSnapshot.data!['categoria']!;
                          String subcategoriaNombre = catSubcatSnapshot.data!['subcategoria']!;

                          return _buildGastoCard(context, gasto, categoriaNombre, subcategoriaNombre);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0), // Ajuste para que no se desborde el botón.
        child: FloatingActionButton(
          tooltip: 'Agregar Gasto',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AgregarGasto()),
            );
          },
          backgroundColor: Colors.pink,
          foregroundColor: Colors.black,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildGastoCard(BuildContext context, DocumentSnapshot gasto, String categoria, String subcategoria) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditarGasto(gastoId: gasto.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.attach_money, size: 40, color: Colors.green.shade700),
              SizedBox(height: 10),
              Text(
                'Monto: ${gasto['monto']}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Categoría: $categoria\nSubcategoría: $subcategoria',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarGasto(gastoId: gasto.id),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, String>> _getCategoriaYSubcategoriaNombres(String idCategoria, String idSubcategoria) async {
    DocumentSnapshot categoriaSnapshot = await FirebaseFirestore.instance.collection('categorias').doc(idCategoria).get();
    DocumentSnapshot subcategoriaSnapshot = await FirebaseFirestore.instance.collection('subcategorias').doc(idSubcategoria).get();

    return {
      'categoria': categoriaSnapshot['nombre'] ?? 'Sin nombre',
      'subcategoria': subcategoriaSnapshot['nombre'] ?? 'Sin nombre',
    };
  }
}
