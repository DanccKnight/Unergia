import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Cereal.dart';
import 'dart:async';

class FlChartPage extends StatefulWidget {
  @override
  _FlChartPageState createState() => _FlChartPageState();
}

class _FlChartPageState extends State<FlChartPage> {
  int touchedIndex;
  int length;
  List<Cereal> cerealData;

  Future<void> assignData() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection('cereal').getDocuments();
    length = querySnapshot.documents.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: assignData(),
        builder: (context, snapshot) {
          return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('cereal').snapshots(),
              builder: (context, snapshot) {
                cerealData = snapshot.data.documents
                    .map((e) => Cereal.fromJson(e.data))
                    .toList();
                if (!snapshot.hasData)
                  return CircularProgressIndicator();
                else {
                  return PieChart(PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showSection(snapshot)));
                }
              });
        },
      ),
    );
  }

  List<PieChartSectionData> showSection(AsyncSnapshot<QuerySnapshot> snapshot) {
    return List.generate(length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: Color(int.parse(cerealData[i].colorVal)),
        value: cerealData[i].rating,
        title: cerealData[i].rating.toString(),
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }
}
