import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Para formatear las fechas
import 'package:ycm_10ids2/Pages/Category.dart';
import 'package:ycm_10ids2/Pages/Menu_hamburguesa.dart';

class GraficaPastel extends StatefulWidget {
  final List<Category> categories;

  GraficaPastel({required this.categories});

  @override
  _GraficaPastelState createState() => _GraficaPastelState();
}

class _GraficaPastelState extends State<GraficaPastel> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<Category> _filteredCategories = [];

  // Función para seleccionar el rango de fechas
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked.start != null && picked.end != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _fetchGastos(); // Actualiza la gráfica con los datos filtrados
      });
    }
  }

  // Función para obtener y filtrar los gastos desde Firestore
  Future<void> _fetchGastos() async {
    if (_startDate == null || _endDate == null) return;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('gastos')
        .where('fecha_gasto', isGreaterThanOrEqualTo: _startDate)
        .where('fecha_gasto', isLessThanOrEqualTo: _endDate)
        .get();

    Map<String, double> subcategoriaMontos = {};

    // Procesa los resultados y agrupa los montos por subcategoría
    for (var doc in querySnapshot.docs) {
      String idSubcategoria = doc['idSubcategoria'];
      double monto = doc['monto'];

      // Acumula los montos por subcategoría
      if (subcategoriaMontos.containsKey(idSubcategoria)) {
        subcategoriaMontos[idSubcategoria] = subcategoriaMontos[idSubcategoria]! + monto;
      } else {
        subcategoriaMontos[idSubcategoria] = monto;
      }
    }

    // Convierte los datos de subcategoría y montos a la lista de `Category`
    List<Category> filteredData = [];
    for (var entry in subcategoriaMontos.entries) {
      String nombreSubcategoria = await _getSubcategoriaName(entry.key); // Obtener el nombre
      filteredData.add(Category(name: nombreSubcategoria, amount: entry.value)); // Sumar el monto
    }

    setState(() {
      _filteredCategories = filteredData;
    });
  }

  // Función para obtener el nombre de la subcategoría desde Firestore
  Future<String> _getSubcategoriaName(String idSubcategoria) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('subcategorias')
          .doc(idSubcategoria)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data() as Map<String, dynamic>;
        return data['nombre'] ?? 'Nombre no encontrado';
      } else {
        return 'Subcategoría no encontrada';
      }
    } catch (e) {
      print('Error obteniendo nombre de subcategoría: $e');
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu_hamburguesa(),
      appBar: AppBar(
        title: Text('Gráfica de Pastel'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Botón para seleccionar rango de fechas
          ElevatedButton(
            onPressed: () => _selectDateRange(context),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              elevation: 18,
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              minimumSize: const Size.fromHeight(60),
            ),
            child: Text(_startDate == null || _endDate == null
                ? 'Selecciona rango de fechas'
                : 'Desde: ${DateFormat('dd/MM/yyyy').format(_startDate!)} Hasta: ${DateFormat('dd/MM/yyyy').format(_endDate!)}'),
          ),

          // Muestra la gráfica solo si hay datos
          _filteredCategories.isNotEmpty
              ? Expanded(child: PieChartWidget(data: _filteredCategories))
              : Text('Selecciona un rango de fechas para ver la gráfica'),
        ],
      ),
    );
  }
}

class PieChartWidget extends StatefulWidget {
  final List<Category> data;
  PieChartWidget({required this.data});

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Column(
          children: <Widget>[
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 1,
                  centerSpaceRadius: 60, // Ajusta el ancho de la gráfica (sus campos)
                  sections: showingSections(),
                ),
              ),
            ),
            const SizedBox(width: 28),
            _buildIndicators(),
          ],
        ),
      ),
    );
  }


  List<PieChartSectionData> showingSections() {
    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      // Define un color para cada subcategoría (puedes ajustar esto según tu lógica)
      Color color = Colors.primaries[i % Colors.primaries.length];

      return PieChartSectionData(
        color: color,
        value: widget.data[i].amount,
        title: '${widget.data[i].name}: \$${widget.data[i].amount.toStringAsFixed(2)}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  Widget _buildIndicators() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.data.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: [
              Container(
                width: 25,
                height: 25,
                color: Colors.primaries[widget.data.indexOf(category) % Colors.primaries.length],
              ),
              const SizedBox(width: 4),
              Text(category.name),
            ],
          ),
        );
      }).toList(),
    );
  }
}
