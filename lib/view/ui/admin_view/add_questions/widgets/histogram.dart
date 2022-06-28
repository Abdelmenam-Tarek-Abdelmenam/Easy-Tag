import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Histogram extends StatelessWidget {
  final List<int> data;
  final String title;
  const Histogram(this.data, this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorManager.whiteColor,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: data.isEmpty
          ? const Center(child: Text("No Student Yet"))
          : SfCartesianChart(
              series: <ChartSeries>[
                HistogramSeries<int, int>(
                    color: ColorManager.mainBlue,
                    dataSource: data,
                    showNormalDistributionCurve: true,
                    curveColor: const Color.fromRGBO(192, 108, 132, 1),
                    binInterval: 1,
                    yValueMapper: (int data, _) => data)
              ],
              title: ChartTitle(text: title),
            ),
    );
  }
}
