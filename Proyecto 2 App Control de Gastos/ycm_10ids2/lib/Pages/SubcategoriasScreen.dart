import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ycm_10ids2/Pages/EditSubcategorias.dart';

class SubcategoriasScreen extends StatefulWidget {
  final String? idCategoria; // Hacemos opcional idCategoria
  final String? nombre; // Nombre de la categoría para mostrar en el AppBar

  const SubcategoriasScreen({super.key, this.idCategoria, this.nombre});

  @override
  _SubcategoriasScreenState createState() => _SubcategoriasScreenState();
}

class _SubcategoriasScreenState extends State<SubcategoriasScreen> {
  // Método para obtener el nombre de la categoría a partir de idCategoria
  Future<String> obtenerNombreCategoria(String idCategoria) async {
    var categoriaSnapshot = await FirebaseFirestore.instance
        .collection('categorias')
        .doc(idCategoria)
        .get();

    if (categoriaSnapshot.exists) {
      var categoriaData = categoriaSnapshot.data() as Map<String, dynamic>;
      return categoriaData['nombre'] ?? 'Sin nombre';
    } else {
      return 'Sin categoría';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcategorías de ${widget.nombre ?? 'Desconocida'}'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('subcategorias')
              .where('idCategoria', isEqualTo: widget.idCategoria) // Filtrar por idCategoria
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var subcategorias = snapshot.data!.docs;

            if (subcategorias.isEmpty) {
              return Center(child: Text('No hay subcategorías disponibles.'));
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: subcategorias.length,
              itemBuilder: (context, index) {
                var subcategoria = subcategorias[index];
                return FutureBuilder<String>(
                  future: obtenerNombreCategoria(subcategoria['idCategoria']), // Obtener el nombre de la categoría padre
                  builder: (context, categoriaSnapshot) {
                    if (categoriaSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (categoriaSnapshot.hasError || !categoriaSnapshot.hasData) {
                      return Text('Error al cargar categoría');
                    }

                    String nombreCategoria = categoriaSnapshot.data!; // Nombre de la categoría

                    return _buildSubcategoriaCard(subcategoria, nombreCategoria);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Widget para mostrar una tarjeta con categoría y subcategoría
  Widget _buildSubcategoriaCard(DocumentSnapshot subcategoria, String nombreCategoria) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          // Lógica para cuando se toca una subcategoría (ej. navegar a otra pantalla)
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView( // Agregar ScrollView aquí
            child: Column(
              mainAxisSize: MainAxisSize.min, // Cambiar para que el Column use solo el espacio necesario
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category, size: 40, color: Colors.pink.shade900), // Ícono de subcategoría
                SizedBox(height: 10),
                Text(
                  'Categoría: $nombreCategoria', // Mostrar nombre de la categoría
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Subcategoría: ${subcategoria['nombre']}', // Mostrar nombre de la subcategoría
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                // Agregamos el IconButton para editar
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSubcategorias(
                          idSubcategoria: subcategoria.id,
                          nombre: subcategoria['nombre'],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
