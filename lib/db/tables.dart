import 'package:drift/drift.dart';

class Transactions extends Table{
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()();
  IntColumn get qty => integer()();
  IntColumn get commission => integer()();
}