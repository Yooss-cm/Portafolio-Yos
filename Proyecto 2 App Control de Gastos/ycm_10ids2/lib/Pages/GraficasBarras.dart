// Prueba de libreria


import 'package:flutter/material.dart';


import 'package:fl_chart/fl_chart.dart';
import 'package:ycm_10ids2/Pages/Category.dart'; // Asegúrate de importar el mismo archivo

class GraficasBarras extends StatelessWidget {
  final List<Category> categories;
  GraficasBarras({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficas de Gastos'),
      ),
      body: Column(
        children: [
          Expanded(child: BarChartWidget(data: categories)),
          Expanded(child: PieChartWidget(data: categories)),
        ],
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<Category> data;
  BarChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: data.asMap().entries.map((entry) {
          int index = entry.key;
          Category category = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: category.amount, // Asegúrate de que no haya valores negativos
                color: Colors.blue,
                width: 20,
              ),
            ],
            showingTooltipIndicators: [0], // Mostrar tooltip en la barra
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < data.length) {
                  return Text(data[index].name); // Se asegura de que el índice sea válido
                } else {
                  return Text(''); // Si el índice está fuera de los límites
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        gridData: FlGridData(show: true),
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final List<Category> data;
  PieChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: data.asMap().entries.map((entry) {
          int index = entry.key;
          Category category = entry.value;
          return PieChartSectionData(
            value: category.amount,
            title: category.name,
            color: Colors.blue,
            radius: 60, // Ajustar el tamaño del pie
          );
        }).toList(),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
