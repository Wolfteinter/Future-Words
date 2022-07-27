import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'itemList.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'statsData.dart';

class Stats extends StatefulWidget {
  final List<ItemList> _items;
  const Stats(this._items, {Key? key}) : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  List<StatsData> dataGraph = [];

  void getData() {
    List<ItemList> items = widget._items;
    int maxSize = min(items.length, 5);
    List<ItemList> aux = List<ItemList>.from(items);
    aux.sort((a, b) => a.count.compareTo(b.count));
    for (var i = aux.length - 1; i >= aux.length - maxSize; i--) {
      dataGraph.add(StatsData(aux[i].word, aux[i].count));
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: new BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                  ),
                ),
                child: Align(
                    child: Text(
                  'STATS',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white),
                )),
              ),
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(), // Initialize category axis.
                  series: <LineSeries<StatsData, String>>[
                    // Initialize line series.
                    LineSeries<StatsData, String>(
                        dataSource: dataGraph,
                        xValueMapper: (StatsData v, _) => v.name,
                        yValueMapper: (StatsData v, _) => v.val)
                  ])
            ],
          ),
        ));
  }
}
