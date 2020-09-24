import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqfilte_test/page/DBUtils.dart';

import 'Dog.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
  final String title;
}

class _MyHomePageState extends State<MyHomePage> {
  var dataList = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("数据操作"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              DBUtils.drop().then((value) {
                Dog dog = Dog(
                  id: 3,
                  name: 'Fido',
                  age: 22,
                  family: '沱牌达到哦',
                );
                DBUtils.insertDog(value, dog);
                DBUtils.dogs(value).then((value) {
                  print('value$value');
                });
//
                DBUtils.queryListByHelper(
                        value, 'dogs', ['id', 'name', 'family'], 'id=?', [0])
                    .then((value) {
                  print('$value');
                });
              });
            },
          )
        ],
      ),
      body: new Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SizedBox(width: 400),
                RaisedButton.icon(
                    icon: Icon(Icons.search),
                    label: Text('查询'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    // onPressed: null,
                    onPressed: () {
                      print("查询数据");
                    }),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
