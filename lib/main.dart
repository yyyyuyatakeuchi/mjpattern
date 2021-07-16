import 'package:flutter/material.dart';
import 'calcFunctions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'MJPattern';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Item> items = [Item(
      id: 0, 
      contentNum: 999999,
      controller: TextEditingController(),
      isInput: false
    )
  ];
  int _counter = 1;
  int count = 0;

  void addItemAuto(){
    int itemNum = items.length; 
    if(inputTotalCount(items,count) == itemNum){
      add();
    }
  }

  void add(){
    setState((){
      items.add(Item.create(_counter));
      _counter++;
    });
  }

  @override
  void dispose(){
    items.forEach((element){
      element.dispose();
    });
    super.dispose();
  }

  void remove(int? id) {
    final removedItem = items.firstWhere((element) => element.id == id);
    setState(() {
      items.removeWhere((element) => element.id == id);
    });

    // itemのcontrollerをすぐdisposeすると怒られるので
    // 少し時間をおいてからdipose()
    Future.delayed(Duration(seconds: 1)).then((value) {
      removedItem.dispose();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('半荘回数：' + inputTotalCount(items,count).toString() + ' 回'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.miscellaneous_services),
            onPressed:(){},
          )],
        elevation: 0,
        backgroundColor: Colors.green.withOpacity(0.7),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.all(32),
        child: ListView(
          children: [
            Row(children: [
              Expanded(
                flex: 2,
                child: 
                  Text(''),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: 
                    Text(
                      '×1.0',
                      style: TextStyle()
                    ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: 
                    Text(
                      '×0.2',
                      style: TextStyle(fontSize: 18),
                    ),
                ),
              ),
          ],),
            ...items.map((item)=>testfield(item)),
            Row(children: [
              Expanded(
                flex: 3,
                child: 
                  Container(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        add();
                      },
                      icon: Icon(Icons.queue_rounded),
                      color: Colors.blueGrey.shade400,
                      iconSize: 30,
                    ),
                  ),
              ),
              Expanded(
                flex: 1,
                child: 
                  Text(''),
              ),
              Expanded(
                flex: 4,
                child: 
                  Container(
                    alignment: Alignment.center,
                    child: 
                      Text(
                        'result',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
              ),
            ],),
            Row(children: [
              Expanded(
                flex: 2,
                child: 
                  Text(''),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: 
                    Text(totalResult(1.0,items,inputTotalCount(items,count)),
                    style: TextStyle(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: 
                    Text(totalResult(0.2,items,inputTotalCount(items,count)),
                    style: TextStyle(
                      fontSize: 21,
                      color: (resultPoint(1.0,items,count) < 0) ? HexColor('#C83131') : Colors.black, 
                    ),
                  ),
                ),
              ),
            ],)
          ],
        ),
      ),
    );
  }

  Widget testfield(Item item){
    return Row(
      children:[
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.only(top:2.0,bottom:2.0),
            child: TextFormField(
              controller: item.controller,
              maxLines: 1,
              //keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                hintText: '入力',
                contentPadding: EdgeInsets.only(left: 15.0),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(18.18),
                  ),
                  borderSide: BorderSide(
                    width: 0.0,
                  ),
                ),
              ),
              validator: (value) {
              // validateの実装を書く
              },
              onChanged: (value) {
                if(value.length > 0 && double.tryParse(value) != null){
                  setState(() {
                    items = items
                      .map((e) => 
                        e.id == item.id ? item.change(int.parse(value),true) : e).toList();
                      addItemAuto();
                });
                }else{
                  setState(() {
                    items = items
                      .map((e) => e.id == item.id ? item.change(999999,false) : e).toList();
                });
              } 
              // saveした時実装したい関数を書く
              }
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            alignment: Alignment.topLeft,
            icon: Icon(Icons.delete),
            iconSize: 30,
            color: Colors.blueGrey.shade400,
            onPressed: () {
             remove(item.id);
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            child: Text(toResultString(calcResult(item.contentNum,1))),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              toResultString(calcResult(item.contentNum,0.2)),
              style: TextStyle(
                fontSize: 20,
                ///here
                color: (calcResult(item.contentNum,0.2) < 0) ? HexColor('#C83131') : Colors.black, 
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class Item {
  final int? id;
  final int? contentNum;
  final TextEditingController? controller;
  final bool? isInput;

  Item({
    @required this.id,
    @required this.contentNum,
    @required this.controller,
    @required this.isInput,
  });

  factory Item.create(int counter){
    return Item(
      id: counter,
      contentNum: 999999,
      controller: TextEditingController(),
      isInput: false,
    );
  }

  Item change(int contentNum, bool isInput){
    return Item(id: this.id, contentNum: contentNum, controller: this.controller, isInput:isInput);
  }

  void dispose(){
    controller?.dispose();
  }
}

class HexColor extends Color {
 static int _getColorFromHex(String hexColor) {
   hexColor = hexColor.toUpperCase().replaceAll('#', '');
   if (hexColor.length == 6) {
     hexColor = 'FF' + hexColor;
   }
   return int.parse(hexColor, radix: 16);
 }

 HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}