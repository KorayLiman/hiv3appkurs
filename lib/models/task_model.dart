import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject{
  @HiveField(0)
  final String Id;
  @HiveField(1)

  String Name;
  @HiveField(2)

  final DateTime CreatedAt;
  @HiveField(3)

  bool IsCompleted;

  Task({required this.Id, required this.Name, required this.CreatedAt, required this.IsCompleted});

  factory Task.create({required String Name, required DateTime CreatedAt}){return Task(Id: const Uuid().v1(), Name: Name, CreatedAt: CreatedAt, IsCompleted: false);}
  
}


