import 'package:cryptoapp/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:math' as math;

class coinchart extends StatelessWidget {
  coinchart({
    super.key,
    required this.priceHistory,
  });
  final List<double> priceHistory;
  List<FlSpot> flSpot = [];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < priceHistory.length; i++) {
      flSpot.add(FlSpot(i + 1, priceHistory[i]));
    }
    final minPrice = priceHistory.reduce(math.min);
    final maxPrice = priceHistory.reduce(math.max);

    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment(-0.7, 0),
        colors: [
          kBackgroundColor,
          kBackgroundColor,
        ],
      ).createShader(bounds),
      blendMode: BlendMode.dstATop,
      child: SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            minX: 1,
            maxX: priceHistory.length.toDouble(),
            minY: minPrice - (minPrice/15),
            maxY: maxPrice + (minPrice/15),
            lineBarsData: [LineChartBarData(spots: flSpot, isCurved: true,)],
          ),
        ),
      ),
    );
  }
}
