import 'package:hiv3app/models/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class LocalStorage {
  Future<void> AddTask({required Task task});
  Future<Task?> GetTask({required String id});
  Future<List<Task>> GetAllTasks();
  Future<bool> DeleteTask({required Task task});
  Future<Task> UpdateTask({required Task task});
}

class MockData extends LocalStorage {
  @override
  Future<void> AddTask({required Task task}) {
    // TODO: implement AddTask
    throw UnimplementedError();
  }

  @override
  Future<bool> DeleteTask({required Task task}) {
    // TODO: implement DeleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> GetAllTasks() {
    // TODO: implement GetAllTasks
    throw UnimplementedError();
  }

  @override
  Future<Task> GetTask({required String id}) {
    // TODO: implement GetTask
    throw UnimplementedError();
  }

  @override
  Future<Task> UpdateTask({required Task task}) {
    // TODO: implement UpdateTask
    throw UnimplementedError();
  }
}

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _TaskBox;
  HiveLocalStorage() {
    _TaskBox = Hive.box<Task>("Tasks");
  }

  @override
  Future<void> AddTask({required Task task}) async {
    await _TaskBox.put(task.Id, task);
  }

  @override
  Future<bool> DeleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> GetAllTasks() async {
    List<Task> _AllTasks = <Task>[];
    _AllTasks = _TaskBox.values.toList();
    if (_AllTasks.isNotEmpty) {
      _AllTasks.sort((Task a, Task b) => a.CreatedAt.compareTo(b.CreatedAt));
    }
    return _AllTasks;
  }

  @override
  Future<Task?> GetTask({required String id}) async {
    if (_TaskBox.containsKey(id)) {
      return _TaskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> UpdateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
