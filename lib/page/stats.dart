

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum WeekDays { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

class Stats extends StatefulWidget {
  // LineChartBarData barData = LineChartBarData(spots: [
  //   FlSpot(0, 1),
  //   FlSpot(1, 2),
  //   FlSpot(2, 3),
  // ]);
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  var spotsValue;
  var spots = [
    FlSpot(0, 1),
    FlSpot(1, 2),
    FlSpot(2, 3),
    FlSpot(3, 3),
    FlSpot(4, 3),
    FlSpot(5, 0),
    FlSpot(6, 4),
  ];
  var defaultSpots = [
    FlSpot(0, 1),
    FlSpot(1, 1),
    FlSpot(2, 1),
    FlSpot(3, 1),
    FlSpot(4, 1),
    FlSpot(5, 1),
    FlSpot(6, 1),
  ];
  @override
  void initState() {
    spotsValue = defaultSpots;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        spotsValue = spots;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LineChartData data = LineChartData(
      backgroundColor: Colors.black12,
      maxY: 7,
      maxX: 6,
      titlesData: FlTitlesData(
        show: true,
        leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (val) {
              return TextStyle(color: Colors.white, fontSize: 14);
            },
            getTitles: (val) {
              return val.toInt() <= 5 && val.toInt() != 0
                  ? val.toInt().toString()
                  : '';
            }),
        bottomTitles: SideTitles(
          margin: 12,
          showTitles: true,
          rotateAngle: 30,
          getTextStyles: (val) {
            return TextStyle(
                color: Colors.white.withOpacity(0.85), fontSize: 13);
          },
          getTitles: (val) {
            if (val <= 6.0) {
              var a = WeekDays.values[val.toInt()].toString().split('.')[1];
              return '$a';
            }
            return '';
          },
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
            bottom: BorderSide(
          color: Colors.white60,
          width: 4,
        )),
      ),
      lineBarsData: [
        LineChartBarData(
          barWidth: 1.0,
          colors: [
            Colors.lightBlue[300]!,
          ],
          spots: spotsValue,
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Hallo, --- !'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(18.0),
            padding: EdgeInsets.all(14),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 12)],
              borderRadius: BorderRadius.circular(14.0),
              color: Theme.of(context).primaryColorDark,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Statistik penjualan mingguan',
                    style: TextStyle(color: Colors.white),
                    textScaleFactor: 2,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 200,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: LineChart(
                        data,
                        swapAnimationDuration: Duration(milliseconds: 400),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(18.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 12)],
                    borderRadius: BorderRadius.circular(14.0),
                    color: Theme.of(context).primaryColorDark,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Pendapatan Hari ini : ',
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Rp545.000,00,-',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.white),
                              textScaleFactor: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
