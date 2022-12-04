import 'dart:html';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Статистика',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Steppe',
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class StatisticsWeek {
  StatisticsWeek(this.day, this.step);
  final String day;
  final int step;
}

class ActivityWeek {
  ActivityWeek(this.day, this.activity);
  final String day;
  final int activity;
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
  //final Color color;
}

class _MyHomePageState extends State<MyHomePage> {
  int _sumStep = 0;
  double _distance = 0;
  double _distanceDay = 0;
  int _activityWeek = 0;
  String _activityCoefficient = '';
  String _comparisonString = '';
  int _efficiency = Random().nextInt(200) - 100;
  int _productivity = Random().nextInt(200) - 100;
  int _comparison = Random().nextInt(200) - 100;

  var activity = [1000, 1500, 1700, 2500, 1800, 1600, 1700];
  var steps = [8000, 9000, 15000, 25000, 17000, 10000, 12000];
  int stepsDay = 0;
  int activityDay = 0;

  final List<ChartData> chartData = [
    ChartData('Зона восстановления', 25),
    ChartData('Зона сжигания жиров', 38),
    ChartData('Зона тренировки', 34),
    ChartData('Зона предельных нагрузок', 52)
  ];

  void comparison() {
    setState(() {
      if (_comparison > 0) {
        _comparisonString = 'Лучше';
      } else {
        _comparisonString = 'Хуже';
      }
    });
  }

  void stepsWeek() {
    setState(() {
      _sumStep = steps.sum;
      stepsDay = steps[6];
    });
  }

  void distance() {
    setState(() {
      _distance = _sumStep * 0.0007;
      _distanceDay = steps[6] * 0.0007;
    });
  }

  void activityWeek() {
    setState(() {
      _activityWeek = activity.sum;
      activityDay = activity[6];
    });
  }

  void activityCoefficient() {
    double coefficient = Random().nextDouble() * 2;
    setState(() {
      if (coefficient < 1.55) {
        _activityCoefficient = 'Низкая активность';
      } else {
        if (coefficient < 1.71) {
          _activityCoefficient = 'Умеренная активность';
        } else {
          if (coefficient < 1.95) {
            _activityCoefficient = 'Высокая активность';
          } else {
            if (coefficient > 1.95)
              _activityCoefficient = 'Очень высокая активность';
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    stepsWeek();
    distance();
    activityWeek();
    activityCoefficient();
    comparison();
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
        Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(97, 144, 140, 246),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: 800,
                //height: 370,
                child: Column(
                  children: [
                    const Text(
                      'Статистика недели',
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Шаги: $_sumStep',
                            ),
                            Text('$_distance км'),
                            SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                tooltipBehavior: TooltipBehavior(enable: false),
                                series: <ChartSeries<StatisticsWeek, String>>[
                                  LineSeries<StatisticsWeek, String>(
                                      dataSource: <StatisticsWeek>[
                                        StatisticsWeek('ПН', steps[0]),
                                        StatisticsWeek('ВТ', steps[1]),
                                        StatisticsWeek('СР', steps[2]),
                                        StatisticsWeek('ЧТ', steps[3]),
                                        StatisticsWeek('ПТ', steps[4]),
                                        StatisticsWeek('СБ', steps[5]),
                                        StatisticsWeek('ВС', steps[6])
                                      ],
                                      xValueMapper: (StatisticsWeek step, _) =>
                                          step.day,
                                      yValueMapper: (StatisticsWeek step, _) =>
                                          step.step,
                                      // Enable data label
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true))
                                ]),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Активность: $_activityWeek кКал'),
                            Text('$_activityCoefficient'),
                            SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                tooltipBehavior: TooltipBehavior(enable: false),
                                series: <ChartSeries<ActivityWeek, String>>[
                                  LineSeries<ActivityWeek, String>(
                                      dataSource: <ActivityWeek>[
                                        ActivityWeek('ПН', activity[0]),
                                        ActivityWeek('ВТ', activity[1]),
                                        ActivityWeek('СР', activity[2]),
                                        ActivityWeek('ЧТ', activity[3]),
                                        ActivityWeek('ПТ', activity[4]),
                                        ActivityWeek('СБ', activity[5]),
                                        ActivityWeek('ВС', activity[6])
                                      ],
                                      xValueMapper:
                                          (ActivityWeek activity, _) =>
                                              activity.day,
                                      yValueMapper:
                                          (ActivityWeek activity, _) =>
                                              activity.activity,
                                      // Enable data label
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true))
                                ]),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
            Column(
              children: [
                //const Text('Зоны тренировок'),
                Container(
                  width: 800,
                  height: 250,
                  color: Color.fromARGB(97, 144, 140, 246),
                  child: SfCircularChart(
                      title: ChartTitle(text: 'Зоны тренировок'),
                      legend: Legend(isVisible: true),
                      series: <CircularSeries>[
                        // Render pie chart
                        PieSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true))
                      ]),
                ),
                Container(
                  width: 800,
                  decoration: BoxDecoration(
                  color: Color.fromARGB(97, 144, 140, 246),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                  child: Column(
                    children: [
                      const Text('Статистика дня', style: TextStyle(fontSize: 20),),
                      Text('Шаги: $stepsDay'),
                      Text('$_distanceDay км'),
                      Text('Активность: $activityDay кКал'),
                      const Text(''),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Эффективность тренировок $_efficiency %'),
                          Text('Продуктивность недели $_productivity %'),
                          Text(
                              '$_comparisonString, чем другие пользователи на $_comparison %'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ])),
    );
  }
}
