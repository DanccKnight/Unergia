import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Cereal.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'flchart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/FlChartPage': (BuildContext context) => FlChartPage(),
        '/MyHomePage': (BuildContext context) => MyHomePage()
    }
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
          title: Text("Rating of cereals with charts_flutter"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(onTap: (){
                  Navigator.of(context).pushNamed('/FlChartPage');
              },child: Icon(Icons.swap_horiz)),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.compare_arrows),
            onPressed: () {
              setState(() {
                flag = !flag;
              });
            }),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('cereal').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else {
            mydata = snapshot.data.documents
                .map((e) => Cereal.fromJson(e.data))
                .toList();
            _generateData(mydata);
            if (flag)
              return _buildBarChart(context);
            else
              return _buildPieChart(context);
          }
        },
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: 20.0)),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 1),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding: new EdgeInsets.only(
                            right: 4.0, top: 10, left: 14.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.black, fontSize: 18),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        strokeWidthPx: 3.0,
                        arcWidth: 180,
                        arcRendererDecorators: [
                          charts.ArcLabelDecorator(
                            insideLabelStyleSpec: charts.TextStyleSpec(
                              fontSize: 15 ,color: charts.MaterialPalette.white
                            ),
                              labelPosition: charts.ArcLabelPosition.inside,

                          )
                        ])),
              ),
            Padding(padding: const EdgeInsets.only(bottom: 40.0))
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 80.0,left: 10.0 ),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: charts.BarChart(
                _seriesPieData,
                animate: true,
                animationDuration: Duration(seconds: 1),
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
          domainFn: (Cereal cereal, _) => cereal.name.toString(),
          measureFn: (Cereal cereal, _) => cereal.rating,
          colorFn: (Cereal cereal, _) =>
              charts.ColorUtil.fromDartColor(Color(int.parse(cereal.colorVal))),
          id: 'cereal',
          data: mydata,
          labelAccessorFn: (Cereal cereal, _) => "${cereal.rating}"),

    );
  }
}
