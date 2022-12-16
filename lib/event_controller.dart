import 'package:flutter/material.dart';
import 'model.dart';

class ToDoController{

  void addToModelList(List values){
    TodoList().addToList(values);
  }
  getList(){
    return TodoList().todoList;
  }

  launchData(){
    return TodoList().readFile();
  }

  setList(Future<List<List>> list){
    TodoList().setList(list);
  }

  closeDb(){
    TodoList().close();
  }

  deleteEvent(String name){
    TodoList().deleteEvent(name);
  }
}