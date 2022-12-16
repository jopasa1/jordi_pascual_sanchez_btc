import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'tables.dart';

part 'database.g.dart';

LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path,'btc.sqlite'));

    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Transactions])
class AppDb extends _$AppDb{
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Transaction>> getEvents() async{
    return await select(transactions).get();
  }

  Future<int> insertEvent(TransactionsCompanion entity) async{
    return await into(transactions).insert(entity);
  }

  Future<int> deleteEvent(String name) async{
    return await (delete(transactions)..where((tbl) => tbl.type.equals(name))).go();
  }
}