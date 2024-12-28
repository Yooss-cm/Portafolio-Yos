import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AgregarPresupuesto.dart'; // Asegúrate de importar la vista de agregar
import 'EditarPresupuesto.dart';
import 'Menu_hamburguesa.dart';

class PresupuestosLista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu_hamburguesa(),
      appBar: AppBar(
        title: Text('Lista de Presupuestos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView( // Envolvemos todo el contenido en un scroll.
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('presupuestos').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Center(child: Text('No hay presupuestos disponibles.'));
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
                      var presupuesto = docs[index];
                      String idCategoria = presupuesto['idCategoria'];

                      return FutureBuilder<String>(
                        future: obtenerNombreCategoria(idCategoria),
                        builder: (context, AsyncSnapshot<String> categoriaSnapshot) {
                          if (!categoriaSnapshot.hasData) {
                            return Card(
                              child: Center(child: Text('Cargando...')),
                            );
                          }

                          return _buildPresupuestoCard(context, presupuesto, categoriaSnapshot.data!);
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
          tooltip: 'Agregar Presupuesto',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AgregarPresupuesto()), // Redirige a la pantalla de agregar
            );
          },
          backgroundColor: Colors.black,
          foregroundColor: Colors.pink,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildPresupuestoCard(BuildContext context, DocumentSnapshot presupuesto, String categoria) {
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
              builder: (context) => EditarPresupuesto(presupuestoId: presupuesto.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet, size: 40, color: Colors.brown.shade700), // Ícono de presupuesto
              SizedBox(height: 10),
              Text(
                'Categoría: $categoria',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Monto: \$${presupuesto['monto'].toStringAsFixed(2)}\n'
                    'Fecha: ${presupuesto['fechaInicial'].toDate().toLocal()} - ${presupuesto['fechaFinal'].toDate().toLocal()}',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarPresupuesto(presupuestoId: presupuesto.id),
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

  // Función para obtener el nombre de la categoría basado en su ID
  Future<String> obtenerNombreCategoria(String idCategoria) async {
    DocumentSnapshot categoriaSnapshot = await FirebaseFirestore.instance
        .collection('categorias')
        .doc(idCategoria)
        .get();

    if (categoriaSnapshot.exists) {
      var data = categoriaSnapshot.data() as Map<String, dynamic>;
      return data['nombre'];
    } else {
      return 'Categoría no encontrada';
    }
  }
}
