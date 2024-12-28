import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ycm_10ids2/Pages/Login.dart';

class EditSubcategorias extends StatefulWidget {
  final String idSubcategoria; // ID de la subcategoría
  final String nombre; // Nombre de la subcategoría

  const EditSubcategorias({super.key, required this.idSubcategoria, required this.nombre});

  @override
  _EditSubcategoriasState createState() => _EditSubcategoriasState();
}

class _EditSubcategoriasState extends State<EditSubcategorias> {
  late TextEditingController _nombreController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombre);
  }

  Future<void> _guardarCambios() async {
    try {
      await FirebaseFirestore.instance
          .collection('subcategorias')
          .doc(widget.idSubcategoria)
          .update({'nombre': _nombreController.text});

      // Alert de éxito
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Subcategoría actualizada exitosamente.',
        onConfirmBtnTap: () {
          Navigator.of(context).pop(); // Regresar a la pantalla anterior
        },
      );
    } catch (e) {
      // Alert de error
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Error al actualizar la subcategoría: $e',
      );
    }
  }

  Future<void> _eliminarSubcategoria() async {
    try {
      await FirebaseFirestore.instance.collection('subcategorias').doc(widget.idSubcategoria).delete();

      // Alert de éxito
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Subcategoría eliminada exitosamente.',
        onConfirmBtnTap: () {
          Navigator.of(context).pop(); // Regresar a la pantalla anterior
        },
      );
    } catch (e) {
      // Alert de error
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Error al eliminar la subcategoría: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Subcategoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre de la subcategoría'),
            ),
            SizedBox(height: 20),
          ElevatedButton(
            onPressed: _guardarCambios,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              elevation: 20,
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink.shade700,
              minimumSize: const Size.fromHeight(60),
            ),
            child: const Text("Guardar Cambios"),
          ),

            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red.shade900), // Ícono de basura en color rojo
              onPressed: () {
                _eliminarSubcategoria(); // Llama al método para eliminar la subcategoría
              },
              tooltip: 'Eliminar Subcategoría', // Tooltip opcional para mejorar la accesibilidad
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose(); // Limpiar el controlador cuando se destruye el widget
    super.dispose();
  }
}
