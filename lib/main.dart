import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Cereal.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool flag = true;
  List<Cereal> mydata;
  List<charts.Series<Cereal, String>> _seriesPieData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.compare_arrows),
            onPressed: (){
              setState((){
                flag = !flag;
              });
            } ),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('cereal').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator();
        else {
          mydata = snapshot.data.documents
              .map((e) => Cereal.fromJson(e.data))
              .toList();
          if(flag)
            return _buildBarChart(context);
          else
            return _buildPieChart(context);
        }
      },
    );
  }

  Widget _buildPieChart(BuildContext context) {
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: charts.PieChart(
                _seriesPieData,
                animate: true,
                behaviors: [
                  new charts.DatumLegend(
                    outsideJustification:
                    charts.OutsideJustification.endDrawArea,
                    horizontalFirst: true,
                    desiredMaxRows: 2,
                    cellPadding:
                    new EdgeInsets.only(right: 4.0, bottom: 4.0,top:4.0),
                    entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.black,
                        fontSize: 18),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: charts.BarChart(
                _seriesPieData,
                animate: true,
                behaviors: [
                  new charts.DatumLegend(
                    outsideJustification:
                        charts.OutsideJustification.endDrawArea,
                    horizontalFirst: true,
                    desiredMaxRows: 2,
                    cellPadding:
                        new EdgeInsets.only(right: 4.0, bottom: 4.0, top: 4.0),
                    entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.black, fontSize: 18),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _generateData(mydata) {
    _seriesPieData = List<charts.Series<Cereal, String>>();
    _seriesPieData.add(
      charts.Series(
          domainFn: (Cereal cereal, _) => cereal.rating.toString(),
          measureFn: (Cereal cereal, _) => cereal.rating,
          colorFn: (Cereal cereal, _) =>
              charts.ColorUtil.fromDartColor(Color(int.parse(cereal.colorVal))),
          id: 'cereal',
          data: mydata,
          labelAccessorFn: (Cereal row, _) => "${row.rating}"),
    );
  }
}
