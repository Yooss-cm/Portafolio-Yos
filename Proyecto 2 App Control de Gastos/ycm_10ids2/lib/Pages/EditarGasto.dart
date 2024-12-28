import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ycm_10ids2/Pages/GastoLista.dart';

class EditarGasto extends StatefulWidget {
  final String gastoId;
  DateTime fechaGasto = DateTime.now();
  EditarGasto({required this.gastoId});

  @override
  _EditarGastoState createState() => _EditarGastoState();
}

class _EditarGastoState extends State<EditarGasto> {
  final _formKey = GlobalKey<FormState>();
  String categoriaSeleccionada = '';
  String subcategoriaSeleccionada = '';
  double monto = 0.0;
  DateTime fechaGasto = DateTime.now();
  String observaciones = '';
  double montoDisponible = 0.0;
  String mensajePresupuesto = '';

  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> subcategorias = [];

  TextEditingController _montoController = TextEditingController();
  TextEditingController _observacionesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarGasto();
    _cargarCategorias();
  }

  //Formato de fecha
  Future<void> _pickDate() async {
    DateTime? nuevaFecha = await showDatePicker(
      context: context,
      initialDate: fechaGasto,  // Fecha inicial del gasto
      firstDate: DateTime(1900), // Permitir fechas desde 1900
      lastDate: DateTime(2100),  // Permitir fechas hasta 2100
    );

    if (nuevaFecha != null) {
      setState(() {
        fechaGasto = nuevaFecha;  // Actualiza la fecha seleccionada
      });
    }
  }


  Future<void> _cargarGasto() async {
    DocumentSnapshot gastoSnapshot =
    await FirebaseFirestore.instance.collection('gastos').doc(widget.gastoId).get();

    if (gastoSnapshot.exists) {
      var gastoData = gastoSnapshot.data() as Map<String, dynamic>;

      setState(() {
        categoriaSeleccionada = gastoData['idCategoria'];
        subcategoriaSeleccionada = gastoData['idSubcategoria'];
        monto = gastoData['monto'];
        fechaGasto = (gastoData['fecha_gasto'] as Timestamp).toDate();
        observaciones = gastoData['observaciones'];

        _montoController.text = monto.toString();
        _observacionesController.text = observaciones;
      });

      await _cargarSubcategorias(categoriaSeleccionada);
      await _actualizarPresupuestoDisponible(); // Calcular el presupuesto disponible
    }
  }

  Future<void> _cargarCategorias() async {
    QuerySnapshot categoriaSnapshot =
    await FirebaseFirestore.instance.collection('categorias').get();

    setState(() {
      categorias = categoriaSnapshot.docs
          .map((doc) => {
        'id': doc.id,
        'nombre': doc['nombre'],
      })
          .toList();
    });
  }

  Future<void> _cargarSubcategorias(String categoriaId) async {
    QuerySnapshot subcategoriaSnapshot = await FirebaseFirestore.instance
        .collection('subcategorias')
        .where('idCategoria', isEqualTo: categoriaId)
        .get();

    setState(() {
      subcategorias = subcategoriaSnapshot.docs
          .map((doc) => {
        'id': doc.id,
        'nombre': doc['nombre'],
      })
          .toList();
    });
  }

  //Función que calcula el presupuesto disponible
  Future<void> _actualizarPresupuestoDisponible() async {
    // Cargamos el presupuesto para la categoría seleccionada
    QuerySnapshot presupuestoSnapshot = await FirebaseFirestore.instance
        .collection('presupuestos')
        .where('idCategoria', isEqualTo: categoriaSeleccionada)
        .get();

    if (presupuestoSnapshot.docs.isEmpty) {
      setState(() {
        mensajePresupuesto = 'Aún no hay presupuestos disponibles para esta categoría en esta fecha';
        montoDisponible = 0.0; // Resetear a 0 si no hay presupuesto
      });
      return;
    }

    var presupuestoData = presupuestoSnapshot.docs.first.data() as Map<String, dynamic>;
    double presupuesto = presupuestoData['monto'];
    DateTime fechaInicial = (presupuestoData['fechaInicial'] as Timestamp).toDate();
    DateTime fechaFinal = (presupuestoData['fechaFinal'] as Timestamp).toDate();

    // Verificamos si la fecha del gasto está dentro del rango del presupuesto
    if (fechaGasto.isAfter(fechaFinal) || fechaGasto.isBefore(fechaInicial)) {
      setState(() {
        mensajePresupuesto = 'Aún no hay presupuestos disponibles para esta categoría en esta fecha';
        montoDisponible = 0.0; // Resetear a 0 si está fuera de rango
      });
      return;
    }

    // Filtramos los gastos dentro del periodo del presupuesto
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

    // Calculamos el presupuesto disponible: presupuesto - gastos
    montoDisponible = presupuesto - totalGastos;

    // Evitamos que el monto disponible sea negativo
    if (montoDisponible < 0) {
      montoDisponible = 0.0;
    }
    setState(() {
      if (montoDisponible > 0) {
        mensajePresupuesto = 'Tu presupuesto disponible para esta categoría es: \$${montoDisponible.toStringAsFixed(2)}';
      } else {
        mensajePresupuesto = 'Has excedido el presupuesto para esta categoría.';
      }
    });
  }

  Future<void> _actualizarGasto() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Verificamos si el gasto excede el presupuesto disponible
        bool presupuestoExcedido = monto > montoDisponible;

        // Actualizamos el gasto en Firestore
        await FirebaseFirestore.instance.collection('gastos').doc(widget.gastoId).update({
          'idCategoria': categoriaSeleccionada,
          'idSubcategoria': subcategoriaSeleccionada,
          'monto': monto,
          'fecha_gasto': fechaGasto,
          'observaciones': observaciones,
        });

        // Mostrar alerta de éxito
        QuickAlert.show(
          context: context,
          type: presupuestoExcedido ? QuickAlertType.warning : QuickAlertType.success,
          title: presupuestoExcedido ? 'Presupuesto Excedido' : 'Gasto Actualizado',
          text: presupuestoExcedido
              // ? 'El gasto excede el presupuesto disponible. Monto disponible: \$${montoDisponible.toStringAsFixed(2)}. El gasto ha sido actualizado con éxito.'
              ? 'El gasto excede el presupuesto disponible. El gasto ha sido actualizado con éxito.'
              : 'El gasto ha sido actualizado con éxito.',
        );


      } catch (e) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Hubo un error al actualizar el gasto: $e',
        );
      }
    }
  }

  // Función para eliminar el gasto
  Future<void> _eliminarGasto() async {
    // Muestra un diálogo de confirmación
    bool? confirmDelete = await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Eliminar Gasto',
      text: '¿Estás seguro de que deseas eliminar este gasto?',
      confirmBtnText: 'Eliminar',
      cancelBtnText: 'Cancelar',
      onConfirmBtnTap: () {
        Navigator.of(context).pop(true);
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop(false);
      },
    );


    // Si el usuario confirmó la eliminación
    if (confirmDelete == true) {
      try {
        await FirebaseFirestore.instance.collection('gastos').doc(widget.gastoId).delete();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Gasto Eliminado',
          text: 'El gasto ha sido eliminado con éxito.',
          onConfirmBtnTap: () {
            Navigator.of(context).pop(); // Cerrar la alerta
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => GastosLista(),
                ),
              );
            });
          },
        );
      } catch (e) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Hubo un error al eliminar el gasto: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Gasto'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _eliminarGasto,
            icon: Icon(Icons.delete, color: Colors.red),
            tooltip: 'Eliminar Gasto',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Categoría'),
                  value: categoriaSeleccionada.isNotEmpty ? categoriaSeleccionada : null,
                  items: categorias.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['id'],
                      child: Text(item['nombre']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      categoriaSeleccionada = value!;
                      _cargarSubcategorias(categoriaSeleccionada);
                      _actualizarPresupuestoDisponible(); // Actualizar presupuesto disponible al cambiar categoría
                    });
                  },
                  validator: (value) => value == null ? 'Selecciona una categoría' : null,
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Subcategoría'),
                  value: subcategoriaSeleccionada.isNotEmpty ? subcategoriaSeleccionada : null,
                  items: subcategorias.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['id'],
                      child: Text(item['nombre']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      subcategoriaSeleccionada = value!;
                    });
                  },
                  validator: (value) => value == null ? 'Selecciona una subcategoría' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _montoController,
                  decoration: InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => monto = double.parse(value!),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un monto';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _observacionesController,
                  decoration: InputDecoration(labelText: 'Observaciones'),
                  onSaved: (value) => observaciones = value!,
                ),
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
                SizedBox(height: 8.0),// Muestra la fecha seleccionada en formato yyyy-MM-dd
                Text(
                  DateFormat('yyyy-MM-dd').format(fechaGasto),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _actualizarGasto,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    elevation: 20,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink.shade700,
                    minimumSize: const Size.fromHeight(60),
                  ),
                  child: Text('Actualizar Gasto'),
                ),
                SizedBox(height: 8.0),
                // IconButton(
                //   onPressed: _eliminarGasto,
                //   icon: Icon(Icons.delete, color: Colors.red),
                //   tooltip: 'Eliminar Gasto',
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
