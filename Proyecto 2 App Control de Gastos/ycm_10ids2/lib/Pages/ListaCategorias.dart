import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ycm_10ids2/Pages/AgregarSubcategoria.dart';
import 'package:ycm_10ids2/Pages/EditarCategoria.dart';

import 'Categorias.dart';

class ListaCategorias extends StatefulWidget {
  const ListaCategorias({super.key});

  @override
  State<ListaCategorias> createState() => _ListacategoriasState();
}

class _ListacategoriasState extends State<ListaCategorias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('categorias').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Sin registros'));
            }

            List<DocumentSnapshot> docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return const Center(child: Text('No hay categorías disponibles.'));
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot doc = docs[index];

                return _buildCategoriaCard(doc);
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: 'Agregar Categoría',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Categorias(),
                ),
              );
            },
            backgroundColor: Colors.pink,
            foregroundColor: Colors.black,
            child: Icon(Icons.add_box),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            tooltip: 'Agregar Subcategoría',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarSubcategoria()),
              );
            },
            backgroundColor: Colors.black,
            foregroundColor: Colors.pink,
            child: Icon(Icons.category_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaCard(DocumentSnapshot categoria) {
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
              builder: (context) => EditarCategoria(
                docId: categoria.id,
                nombreInicial: categoria['nombre'],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category_rounded, size: 40, color: Colors.pink.shade900),
              SizedBox(height: 10),
              Text(
                categoria['nombre'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarCategoria(
                        docId: categoria.id,
                        nombreInicial: categoria['nombre'],
                      ),
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
}
