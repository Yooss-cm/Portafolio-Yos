import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarPresupuesto extends StatefulWidget {
  final String presupuestoId;

  const EditarPresupuesto({required this.presupuestoId});

  @override
  _EditarPresupuestoState createState() => _EditarPresupuestoState();
}

class _EditarPresupuestoState extends State<EditarPresupuesto> {
  final TextEditingController montoController = TextEditingController();
  String? selectedCategoria;
  DateTime? fechaInicial;
  DateTime? fechaFinal;

  // Cargar los datos del presupuesto
  Future<void> _cargarDatos() async {
    var doc = await FirebaseFirestore.instance
        .collection('presupuestos')
        .doc(widget.presupuestoId)
        .get();

    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      setState(() {
        selectedCategoria = data['idCategoria'];
        montoController.text = data['monto'].toString();
        fechaInicial = data['fechaInicial'].toDate();
        fechaFinal = data['fechaFinal'].toDate();
      });
    }
  }

  // Actualizar el presupuesto
  Future<void> _actualizarPresupuesto() async {
    if (selectedCategoria != null && montoController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('presupuestos').doc(widget.presupuestoId).update({
        'idCategoria': selectedCategoria,
        'monto': double.parse(montoController.text),
        'fechaInicial': fechaInicial,
        'fechaFinal': fechaFinal,
      }).then((_) {
        Navigator.pop(context);
      });
    }
  }

  // Eliminar el presupuesto
  Future<void> _eliminarPresupuesto() async {
    FirebaseFirestore.instance.collection('presupuestos').doc(widget.presupuestoId).delete().then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  // Función para seleccionar fechas
  Future<void> _selectDate(BuildContext context, bool isInicial) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isInicial) {
          fechaInicial = picked;
        } else {
          fechaFinal = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Presupuesto'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Eliminar Presupuesto'),
                  content: Text('¿Estás seguro de que deseas eliminar este presupuesto?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _eliminarPresupuesto();
                        Navigator.pop(context); // Cerrar el diálogo
                      },
                      child: Text('Eliminar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('categorias').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<String>(
                  hint: Text('Seleccionar Categoría'),
                  value: selectedCategoria,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategoria = newValue;
                    });
                  },
                  items: snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text(doc['nombre']),
                    );
                  }).toList(),
                );
              },
            ),
            TextField(
              controller: montoController,
              decoration: InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context, true),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                elevation: 20,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(60),
              ),
              child: Text(fechaInicial == null ? 'Seleccionar Fecha Inicial' : 'Fecha Inicial: ${fechaInicial!.toLocal()}'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context, false),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                elevation: 20,
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink.shade700,
                minimumSize: const Size.fromHeight(60),
              ),
              child: Text(fechaFinal == null ? 'Seleccionar Fecha Final' : 'Fecha Final: ${fechaFinal!.toLocal()}'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _actualizarPresupuesto,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                elevation: 20,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(60),
              ),
              child: Text('Actualizar Presupuesto'),
            ),
          ],
        ),
      ),
    );
  }
}
