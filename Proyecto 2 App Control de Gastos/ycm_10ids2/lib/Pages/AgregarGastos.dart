import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Para formato de fechas
import 'package:quickalert/quickalert.dart';
import 'package:ycm_10ids2/Pages/GastoLista.dart';

class AgregarGasto extends StatefulWidget {
  @override
  _AgregarGastoState createState() => _AgregarGastoState();
}

class _AgregarGastoState extends State<AgregarGasto> {
  String? categoriaSeleccionada;
  String? subcategoriaSeleccionada;
  double monto = 0.0;
  String observaciones = '';
  DateTime fechaGasto = DateTime.now();
  double montoDisponible = 0.0;
  String mensajePresupuesto = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Gasto'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCategoriaDropdown(),
              _buildSubcategoriaDropdown(),
              TextFormField(
                decoration: InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  monto = double.tryParse(value) ?? 0.0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El monto es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Observaciones'),
                onChanged: (value) {
                  observaciones = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickDate,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 20,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(60),
                ),
                child: Text('Seleccionar Fecha'),
              ),
              SizedBox(height: 16.0),
              Text(DateFormat('yyyy-MM-dd').format(fechaGasto)),
              SizedBox(height: 16.0),
              Text(
                mensajePresupuesto,
                style: TextStyle(
                  color: montoDisponible > 0 ? Colors.green : Colors.red,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _registrarGasto,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  elevation: 20,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.pink.shade700,
                  minimumSize: const Size.fromHeight(60),
                ),
                child: Text('Guardar Gasto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriaDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categorias').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return DropdownButtonFormField<String>(
          hint: Text('Seleccionar Categoría'),
          value: categoriaSeleccionada,
          onChanged: (value) async {
            setState(() {
              categoriaSeleccionada = value;
              subcategoriaSeleccionada = null; // Resetear subcategoría al cambiar categoría
            });
            await _actualizarPresupuestoDisponible(); // Actualizar presupuesto
          },
          items: snapshot.data!.docs.map((doc) {
            return DropdownMenuItem(
              value: doc.id,
              child: Text(doc['nombre']),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSubcategoriaDropdown() {
    if (categoriaSeleccionada == null) {
      return DropdownButtonFormField(
        hint: Text('Seleccionar Subcategoría'),
        items: [],
        onChanged: null,
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('subcategorias')
          .where('idCategoria', isEqualTo: categoriaSeleccionada)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return DropdownButtonFormField<String>(
          hint: Text('Seleccionar Subcategoría'),
          value: subcategoriaSeleccionada,
          onChanged: (value) {
            setState(() {
              subcategoriaSeleccionada = value;
            });
          },
          items: snapshot.data!.docs.map((doc) {
            return DropdownMenuItem(
              value: doc.id,
              child: Text(doc['nombre']),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaGasto,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        fechaGasto = picked;
        _actualizarPresupuestoDisponible(); // Actualizar presupuesto si cambia la fecha
      });
    }
  }


  Future<void> _registrarGasto() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Guardamos los valores ingresados

      try {
        // Obtenemos el presupuesto para la categoría seleccionada
        QuerySnapshot presupuestoSnapshot = await FirebaseFirestore.instance
            .collection('presupuestos')
            .where('idCategoria', isEqualTo: categoriaSeleccionada)
            .get();

        if (presupuestoSnapshot.docs.isEmpty) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'No se ha encontrado un presupuesto para esta categoría.',
          );
          return;
        }

        var presupuestoData = presupuestoSnapshot.docs.first.data() as Map<String, dynamic>;
        double presupuesto = presupuestoData['monto'];
        DateTime fechaInicial = (presupuestoData['fechaInicial'] as Timestamp).toDate();
        DateTime fechaFinal = (presupuestoData['fechaFinal'] as Timestamp).toDate();

        // Sumamos los gastos existentes en esta categoría y subcategoría dentro del rango de fechas
        QuerySnapshot gastosSnapshot = await FirebaseFirestore.instance
            .collection('gastos')
            .where('idCategoria', isEqualTo: categoriaSeleccionada)
            .where('idSubcategoria', isEqualTo: subcategoriaSeleccionada)
            .get();

        double totalGastos = 0.0;
        for (var gastoDoc in gastosSnapshot.docs) {
          totalGastos += gastoDoc['monto'];
        }

        double disponible = presupuesto - totalGastos;

        // Guardamos el gasto en Firestore
        await FirebaseFirestore.instance.collection('gastos').add({
          'idCategoria': categoriaSeleccionada,
          'idSubcategoria': subcategoriaSeleccionada,
          'monto': monto,
          'fecha_gasto': fechaGasto,
          'observaciones': observaciones,
        });

        // Si el monto excede el presupuesto disponible
        if (monto > disponible) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            title: 'Presupuesto Excedido',
            text: 'El gasto excede el presupuesto disponible',
            onConfirmBtnTap: () {
              Navigator.pop(context); // Cierra la alerta
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => GastosLista(),
                ),
              ); // Redirige a GastoLista.dart
            },
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Gasto Registrado',
            text: 'El gasto ha sido registrado con éxito.',
            onConfirmBtnTap: () {
              Navigator.pop(context); // Cierra la alerta
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => GastosLista(),
                ),
              ); // Redirige a GastoLista.dart
            },
          );
        }
      } catch (e) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Hubo un error al registrar el gasto: $e',
        );
      }
    }
  }




  Future<void> _actualizarPresupuestoDisponible() async {
    if (categoriaSeleccionada == null) {
      setState(() {
        mensajePresupuesto = 'Aún no hay presupuestos disponibles para esta categoría en esta fecha';
        montoDisponible = 0.0; // Resetear a 0 si no hay presupuesto
      });
      return;
    }

    QuerySnapshot presupuestoSnapshot = await FirebaseFirestore.instance
        .collection('presupuestos')
        .where('idCategoria', isEqualTo: categoriaSeleccionada)
        .get();

    if (presupuestoSnapshot.docs.isNotEmpty) {
      var presupuestoData = presupuestoSnapshot.docs.first.data() as Map<String, dynamic>;
      double presupuesto = presupuestoData['monto'];
      DateTime fechaInicial = (presupuestoData['fechaInicial'] as Timestamp).toDate();
      DateTime fechaFinal = (presupuestoData['fechaFinal'] as Timestamp).toDate();

      // Verificamos si la fecha del gasto está dentro del rango del presupuesto
      if (fechaGasto.isAfter(fechaFinal) || fechaGasto.isBefore(fechaInicial)) {
        setState(() {
          mensajePresupuesto = 'Aún no hay presupuestos disponibles para esta categoría en esta fecha';
          montoDisponible = 0.0; // Resetear a 0 si la fecha no está dentro del rango
        });
        return;
      }

      // Sumamos los gastos existentes en esta categoría dentro del rango de fechas
      QuerySnapshot gastosSnapshot = await FirebaseFirestore.instance
          .collection('gastos')
          .where('idCategoria', isEqualTo: categoriaSeleccionada)
          .where('fecha_gasto', isGreaterThanOrEqualTo: fechaInicial)
          .where('fecha_gasto', isLessThanOrEqualTo: fechaFinal)
          .get();

      double totalGastos = 0.0;
      for (var gastoDoc in gastosSnapshot.docs) {
        totalGastos += gastoDoc['monto'];
      }

      setState(() {
        montoDisponible = presupuesto - totalGastos;

        if (montoDisponible < 0) {
          mensajePresupuesto = 'Tu presupuesto ha sido excedido.';
        } else {
          mensajePresupuesto = 'Tu presupuesto disponible para esta categoría es: \$${montoDisponible.toStringAsFixed(2)}';
        }
      });
    } else {
      setState(() {
        mensajePresupuesto = 'Aún no hay presupuestos disponibles para esta categoría.';
        montoDisponible = 0.0; // Resetear a 0 si no hay presupuesto
      });
    }
  }
}
