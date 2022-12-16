import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'event_controller.dart';
import 'db/database.dart';
import 'package:drift/drift.dart';
import 'dart:io';

class TodoList{

  static final TodoList _modelo = TodoList._internal();

  factory TodoList() {
    return _modelo;
  }

  TodoList._internal():
        _todoList = <List>[];

  List<List> _todoList;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test1.txt');
  }

  Future<List<List>> readFile() async {
    try {
      _db = AppDb();
      List<List> _lista = <List>[];
      List<Transaction> events = await _db.getEvents();
      for(var transaction in events){
        List r_transaction = <List>[];
        r_transaction.add(transaction.id);
        r_transaction.add(transaction.date);
        r_transaction.add(transaction.type);
        r_transaction.add(transaction.qty);
        r_transaction.add(transaction.commission);
        _lista.add(r_transaction);
      }

      return _lista;
    } catch (e) {
      return [];
    }
  }

  addToList (List values) {
    _todoList.add(values);
    insertDb(values);
  }

  setList(Future<List<List>> list) async{
    _todoList = await list;
  }

  deleteEvent(String name){
    deleteEntry(name);
  }

  close(){
    _db.close();
  }

  List<List> get todoList => _todoList;
}

////////////////////////////////////////////////////////////////////////////////


late AppDb _db;

insertDb(List list){
  DateTime dt = DateTime.parse(list[3]);
  int qty_int = int.parse(list[1]);
  int commission_int = int.parse(list[2]);
  final entity = TransactionsCompanion(
    type: Value(list[0]),
    qty: Value(qty_int),
    commission: Value(commission_int),
    date: Value(dt)
  );
  _db.insertEvent(entity);
}

deleteEntry(String name){
  _db.deleteEvent(name);
  print(name);
}