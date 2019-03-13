// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:sms/sms.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for material.AppBar.actions',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home>{
  int _currentIndex = 0;
  static List<Series<ChartPoint,int>> chartData = getChartsData();
  final List<Widget> _children = [
    CardsWidget(),
    DatesWidget(),
    ChartWidget(chartData),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards'),
      ),
      body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(onTap: onTabTapped,
            currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.credit_card),
              title: new Text('Cards'),
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.event_note),
                title: new Text('Notes')
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.show_chart),
              title: new Text('Charts'),
            )
          ],),
    );
  }

  static List<Series<ChartPoint, int>> getChartsData(){
    final data = [
      new ChartPoint(0, 5),
      new ChartPoint(1, 8),
      new ChartPoint(2, 2),
      new ChartPoint(3, 3),
      new ChartPoint(4, 7),
      new ChartPoint(5, 6),
    ];
    return [
      new Series(
          id: 'Profit',
          data: data,
          domainFn: (ChartPoint point, _) => point.x,
          measureFn: (ChartPoint point, _) => point.y,
      )
    ];
  }


  void onTabTapped(int index){
    setState((){
      _currentIndex = index;
    });
  }
}

class DatesWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Calendar(
                  isExpandable: true,
                  showTodayAction: false)
    );
  }
}

class ChartPoint{
  final int x;
  final int y;

  ChartPoint(this.x, this.y);
}

class ChartWidget extends StatelessWidget{
  final List<Series> seriesList;
  ChartWidget(this.seriesList);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LineChart(seriesList, animate: true)
    );
  }
}

class BankCard{
  final String number;
  final String value;

  BankCard(this.number, this.value);
}

class CardsWidget extends StatelessWidget{
  Future<List<BankCard>> bankCards = getData();

  static Future<List<BankCard>> getData() async {
    SmsQuery query = new SmsQuery();
    List<SmsMessage> messages = await query.querySms(kinds: [SmsQueryKind.Inbox]
    );
    return [new BankCard('3333 2222 1111 0000', '3')];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(8.0),
        itemCount: bankCards..length,
        itemExtent: 50,
        itemBuilder: (BuildContext context, int index){
          return Card(
            margin: EdgeInsets.all(3.0),
            child: InkWell(
              splashColor: Colors.purple.withAlpha(30),
              onTap: (){
                showDialog(context: context,
                    builder: (_) =>
                    new AlertDialog(
                      title: new Text(bankCards[index].number),
                      content: new Text(bankCards[index].value),
                    )
                );
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                Icon(Icons.credit_card),
                Text(bankCards[index].number),
                Text(bankCards[index].value)
              ],
              ),
            ),
          );
        },
      ),
    );
  }
}
