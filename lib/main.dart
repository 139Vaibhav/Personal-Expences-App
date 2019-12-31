import 'package:expences/widgets/new_transaction.dart';
import 'package:expences/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';


void main () {

  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Personal Expences',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily: 'OpenSans', 
            fontWeight: FontWeight.bold, 
            fontSize: 18
            ),
            button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily: 'OpenSans', 
            fontSize: 20,
            fontWeight: FontWeight.bold
            ),
            ),
            )
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget{

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction =[];
  bool _showChart = false;
  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days :7),
      ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
    final newTx=Transaction(
      title:txTitle, 
      amount:txAmount, 
      date:chosenDate,
      id: DateTime.now().toString()
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx, builder: (_) {
        return GestureDetector (
          onTap: (){},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
          );
      } );
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransaction.removeWhere((tx){
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    
    final appBar = AppBar(
        title: Text('Personal Expences',),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed:  () =>_startAddNewTransaction(context),)
        ],
      );
      final txListWidget = Container(
              height:(mediaQuery.size.height - 
             appBar.preferredSize.height - mediaQuery.padding.top)*0.7,
              child: TransactionList(_userTransaction, _deleteTransaction)
              );
    // TODO: implement build
    return Scaffold( 
      appBar: appBar,
      body: SingleChildScrollView(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(isLandScape) Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Show Chart',textAlign: TextAlign.center,               
                ),
              Switch(value:_showChart, onChanged: (val){
                setState(() {
                  _showChart=val;
                });
              },),
            ],),
            if(!isLandScape)
              Container(
             height: (mediaQuery.size.height - 
             appBar.preferredSize.height - mediaQuery.padding.top)*0.3,
             child: Chart(_recentTransaction),
             ),
             if(!isLandScape)
             txListWidget,
           if(isLandScape) _showChart ? Container(
             height: (mediaQuery.size.height - 
             appBar.preferredSize.height - mediaQuery.padding.top)*0.7,
             child: Chart(_recentTransaction),
             ):
            txListWidget
        ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>_startAddNewTransaction(context),
        ),
    );
  }
}
