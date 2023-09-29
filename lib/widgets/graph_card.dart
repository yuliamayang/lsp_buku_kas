import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/cash_flow.dart';
import '../services/db_helper.dart';

class GraphCard extends StatefulWidget {
  const GraphCard({Key? key}) : super(key: key);

  @override
  State<GraphCard> createState() => _GraphCardState();
}

class _GraphCardState extends State<GraphCard> {
  late DataHelper dataHelper;
  List<CashFlow>? listCashFlow;
  int maxAmount = 0;
  double maxDate = 0;

  void initData() async {
    listCashFlow = await dataHelper.selectCashFlowByMonth();
    for (CashFlow cashFlow in listCashFlow!) {
      double parsedDate = double.parse(
        cashFlow.date!.split('-')[2].substring(0, 2),
      );
      if (cashFlow.amount! > maxAmount) {
        maxAmount = cashFlow.amount!;
      }
      if (maxDate < parsedDate) {
        maxDate = parsedDate;
      }
    }
    dataHelper.close();
    setState(() {});
  }

  @override
  void initState() {
    dataHelper = DataHelper();
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => LineChart(
        LineChartData(
          gridData: FlGridData(show: false), // Menyembunyikan gridlines
          titlesData: FlTitlesData(show: false), // Menyembunyikan label sumbu
          borderData: FlBorderData(
            show: true, // Menampilkan garis tepi grafik
            border: Border.all(
                color: const Color(0xff37434d),
                width: 1), // Warna dan lebar garis tepi
          ),
          minX: 1,
          maxX: maxDate.toDouble(),
          minY: 0,
          maxY: maxAmount.toDouble(),
          lineBarsData: [
            LineChartBarData(
              color: const Color(0xff4af699), // Warna garis hijau
              spots: (listCashFlow != null)
                  ? [
                      for (CashFlow cashFlow in listCashFlow!)
                        if (cashFlow.type == 0)
                          FlSpot(
                            double.parse(
                              cashFlow.date!.split('-')[2].substring(0, 2),
                            ),
                            cashFlow.amount!.toDouble(),
                          )
                    ]
                  : [],
              barWidth: 2, // Lebar garis
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false, // Menyembunyikan titik-titik pada garis
              ),
            ),
            LineChartBarData(
              color: const Color(0xffaa4cfc), // Warna garis merah
              spots: (listCashFlow != null)
                  ? [
                      for (CashFlow cashFlow in listCashFlow!)
                        if (cashFlow.type == 1)
                          FlSpot(
                            double.parse(
                              cashFlow.date!.split('-')[2].substring(0, 2),
                            ),
                            cashFlow.amount!.toDouble(),
                          ),
                    ]
                  : [],
              barWidth: 2, // Lebar garis
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false, // Menyembunyikan titik-titik pada garis
              ),
            ),
          ],
        ),
      );
}
