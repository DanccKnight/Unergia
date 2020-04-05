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
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('cereal')
        .getDocuments()
        .then((querySnapshot) {
      length = querySnapshot.documents.length;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rating of cereals with fl_chart"),
      ),
      extendBodyBehindAppBar: false,
      body: FutureBuilder(
        future: assignData(),
        builder: (context, snapshot) {
          if (length == null) return Center(child: CircularProgressIndicator());
          return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('cereal').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: Text('No data present, wtf?'));
                else {
                  cerealData = snapshot.data.documents
                      .map((e) => Cereal.fromJson(e.data))
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 100, bottom: 35),
                        child: SizedBox(
                          height: 200,
                          child: PieChart(PieChartData(
                              pieTouchData: PieTouchData(
                                  touchCallback: (pieTouchResponse) {
                                setState(() {
                                  if (pieTouchResponse.touchInput
                                          is FlLongPressEnd ||
                                      pieTouchResponse.touchInput is FlPanEnd) {
                                    touchedIndex = -1;
                                  } else {
                                    touchedIndex =
                                        pieTouchResponse.touchedSectionIndex;
                                  }
                                });
                              }),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 12,
                              centerSpaceRadius: 40,
                              sections: showSection(snapshot))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 135),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Indicator(
                                  color: Color(
                                      int.parse(cerealData[index].colorVal)),
                                  text: cerealData[index].name,
                                  isSquare: false,
                                  size: touchedIndex == index ? 18 : 16,
                                  textColor: touchedIndex == index
                                      ? Colors.black
                                      : Colors.black54,
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                }
              });
        },
      ),
    );
  }
}
