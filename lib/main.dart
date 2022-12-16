import 'package:flutter/material.dart';
import 'model.dart';
import 'event_controller.dart';
//import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'db/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

void main() {
  runApp(Todo());
}

class Todo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jordi_pascual_sanchez_btc',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      routes: {
        '/': (context) => TodoList(),
      },
    );
  }
}

final ToDoController _controlador = ToDoController();

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // text field
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textFieldController = TextEditingController();
  late final Future<List<List>> _initialList;
  @override
  void initState() {
    super.initState();
    _initialList = _controlador.launchData();
  }

  @override
  void dispose() {
    super.dispose();
    _controlador.closeDb();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List>>(
      future: _initialList,
      builder: (BuildContext context, AsyncSnapshot<List<List>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
        } else if (snapshot.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            ),
          ];
        }
        _controlador.setList(_initialList);
        List transactions = _controlador.getList();
        return _createScaffold(context, transactions);
      },
    );
  }


  void _addTodoItem(List transactions) {
    setState(() {
      _controlador.addToModelList(transactions);
    });
  }

  Widget _buildTodoItem(String title) {
    return ListTile(title: Text(title));
  }

  Future<AlertDialog> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          DateTime? date;
          String? type;
          String? qty;
          String? commission;
          return AlertDialog(
            title: const Text('Add a new transaction'),
            content: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Enter the type of your transaction",
                        hintText: "Type",
                      ),
                      onSaved: (String? value){type = value;},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Valid input';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                      labelText: "Enter the quantity of your transaction",
                      hintText: "Qty",
                    ),
                      onSaved: (String? value){qty = value;},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Valid input';
                        }
                        return null;
                      },),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Enter the commission of your transaction",
                        hintText: "Commission",
                      ),
                      onSaved: (String? value){qty = value;},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Valid input';
                        }
                        return null;
                      },),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Enter the date of your transaction",
                        hintText: "Date",
                      ),
                      onSaved: (String? value){qty = value;},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Valid input';
                        }
                        return null;
                      },),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _addTodoItem([type,qty,commission,date]);
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                  )
                ],)
          )
        );
        }) as Future<AlertDialog>;
  }
  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (String title in _controlador.getList()) {
      _todoWidgets.add(_buildTodoItem(title));
    }
    return _todoWidgets;
  }
  String text1 = "";
  Scaffold _createScaffold(BuildContext context, List transactions) {
    return Scaffold(
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.deepOrange,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListTile(
                title: Text(transactions[index][1]),
                trailing: Container(
                  width: 70,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(transactions[index][1])),
                      Expanded(
                          child: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => SimpleDialog(
                                      children: [
                                        TextField(
                                          onChanged: (value){
                                            setState(() {
                                              text1 = value;
                                            });
                                          },
                                        ),
                                        ElevatedButton(
                                            onPressed: (){
                                              setState(() {
                                                transactions[index] = text1;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text("Update"))
                                      ],
                                    ));
                              },
                              icon: Icon(Icons.edit))),
                      Expanded(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _controlador.deleteEvent(transactions[index]);
                                  transactions.removeAt(index);
                                });
                              }, icon: Icon(Icons.delete)))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                onPressed: () => _displayDialog(context),
                tooltip: 'Add Item',
                child: Icon(Icons.add)),
            FloatingActionButton(
                onPressed: () {
                },
                tooltip: 'Graph',
                child: Icon(Icons.graphic_eq)),
          ]
      )
    );
  }

}
