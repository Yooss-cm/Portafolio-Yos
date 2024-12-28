import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Para formatear las fechas
import 'package:ycm_10ids2/Pages/Category.dart';
import 'package:ycm_10ids2/Pages/Menu_hamburguesa.dart';

class GraficaBarra extends StatefulWidget {
  final List<Category> categories;
  GraficaBarra({required this.categories});

  @override
  _GraficaBarraState createState() => _GraficaBarraState();
}

class _GraficaBarraState extends State<GraficaBarra> {
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

    Map<String, double> categoriasGastos = {};

    // Procesa los resultados y agrupa los montos por categoría
    for (var doc in querySnapshot.docs) {
      String idCategoria = doc['idCategoria'];
      double monto = doc['monto'];

      // Acumula los montos por categoría
      categoriasGastos.update(idCategoria, (existing) => existing + monto,
          ifAbsent: () => monto);
    }

    // Convierte los datos de categoría y montos a la lista de `Category`
    List<Category> filteredData = [];
    for (var entry in categoriasGastos.entries) {
      String nombreCategoria = await _getCategoriaName(entry.key); // Obtener el nombre
      filteredData.add(Category(name: nombreCategoria, amount: entry.value)); // Sumar el monto
    }

    setState(() {
      _filteredCategories = filteredData;
    });
  }

  // Función para obtener el nombre de la categoría desde Firestore
  Future<String> _getCategoriaName(String idCategoria) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('categorias')
          .doc(idCategoria)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data() as Map<String, dynamic>;
        return data['nombre'] ?? 'Nombre no encontrado';
      } else {
        return 'Categoría no encontrada';
      }
    } catch (e) {
      print('Error obteniendo nombre de categoría: $e');
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu_hamburguesa(),
      appBar: AppBar(
        title: Text('Gráfica de Barras'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Botón para seleccionar rango de fechas
          ElevatedButton(
            onPressed: () => _selectDateRange(context),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              elevation: 20,
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink.shade700,
              minimumSize: const Size.fromHeight(60),
            ),
            child: Text(_startDate == null || _endDate == null
                ? 'Selecciona rango de fechas'
                : 'Desde: ${DateFormat('dd/MM/yyyy').format(_startDate!)} Hasta: ${DateFormat('dd/MM/yyyy').format(_endDate!)}'),
          ),
          // Muestra la gráfica solo si hay datos
          _filteredCategories.isNotEmpty
              ? Expanded(child: BarChartWidget(data: _filteredCategories))
              : Text('Selecciona un rango de fechas para ver la gráfica'),
        ],
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<Category> data;

  BarChartWidget({required this.data});

  // Lista de colores para las barras
  final List<Color> barColors = [
    Colors.black,
    Colors.purple.shade900,
    Colors.green,
    Colors.pinkAccent,
    Colors.red,
    Colors.yellow,
    Colors.teal,
  ];

  BarChartGroupData generateGroupData(int x, double amount) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: amount,
          color: barColors[x % barColors.length], // Cambia el color según el índice
          width: 40,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: BarChart(
          BarChartData(
            barGroups: data.asMap().entries.map((entry) {
              int index = entry.key;
              Category category = entry.value;
              return generateGroupData(index, category.amount);
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < data.length) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(data[index].name),
                      );
                    } else {
                      return Text('');
                    }
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            maxY: data.isNotEmpty ? data.map((e) => e.amount).reduce((a, b) => a > b ? a : b) + 1 : 0,
          ),
        ),
      ),
    );
  }
}
