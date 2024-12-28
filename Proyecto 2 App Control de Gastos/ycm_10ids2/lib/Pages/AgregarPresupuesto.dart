import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgregarPresupuesto extends StatefulWidget {
  @override
  _AgregarPresupuestoState createState() => _AgregarPresupuestoState();
}

class _AgregarPresupuestoState extends State<AgregarPresupuesto> {
  final TextEditingController montoController = TextEditingController();
  String? selectedCategoria;
  DateTime? fechaInicial;
  DateTime? fechaFinal;

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

  // Función para guardar presupuesto
  Future<void> _guardarPresupuesto() async {
    if (selectedCategoria != null && montoController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('presupuestos').add({
        'idCategoria': selectedCategoria,
        'monto': double.parse(montoController.text),
        'fechaInicial': fechaInicial,
        'fechaFinal': fechaFinal,
      }).then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Presupuesto'),
        centerTitle: true,
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
              onPressed: _guardarPresupuesto,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                elevation: 20,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(60),
              ),
              child: Text('Agregar Presupuesto'),
            ),
          ],
        ),
      ),
    );
  }
}
