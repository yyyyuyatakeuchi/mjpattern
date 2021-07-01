import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Test TextboxY';
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
  List<Item> items = [];
  int _counter = 0;

  String calcResult(int? contentNum, double rate){
    double resultNum = 0;
    String result = "";
    if(contentNum != null && contentNum < 999999){
      resultNum = (contentNum - 250) * 100 * rate;
      result = resultNum.round().toString();
      if(resultNum > 0){
        result = "+" + result;
      }
      return result;
    }else{
      return "";
    }
  }

  int inputTotalCount(){
    int count = 0;
    items.forEach((e) => e.isInput == true ? count++ : count);
    return count;
  }

  int totalPoints(){
    int total = 0;
    items.forEach((e) => e.isInput == true ? total += e.contentNum as int : total);
    return total;
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
        title: Text('MJPattern'),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: ListView(
          children: [
            Text('半荘回数：' + inputTotalCount().toString() + ' 回'),
            ...items.map((item)=>testfield(item)),
            ElevatedButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(Size(60, 60)),
                shape: MaterialStateProperty.all<CircleBorder>(CircleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                )),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                elevation: MaterialStateProperty.all<double>(4.0),
              ),
              onPressed: () {
                add();
              },
            ),
            Text(totalPoints().toString()),
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
          child: TextFormField(
              controller: item.controller,
              maxLines: 1,
              //keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                hintText: '入力',
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
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            remove(item.id);
          },
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            child: Text(calcResult(item.contentNum,1)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            child: Text(calcResult(item.contentNum,0.2)),
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

