import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hiv3app/data/local_storage.dart';
import 'package:hiv3app/main.dart';
import 'package:hiv3app/models/task_model.dart';
import 'package:hiv3app/widgets/tasklistitem.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> AllTasks;

  CustomSearchDelegate({required this.AllTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = "";
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
      onTap: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> FilteredList = AllTasks.where(
      (task) {
        return task.Name.toLowerCase().contains(query.toLowerCase());
      },
    ).toList();
    return FilteredList.isNotEmpty
        ? ListView.builder(
            itemCount: FilteredList.length,
            itemBuilder: (context, index) {
              var _CurrentListElement = FilteredList[index];
              return Dismissible(
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Icon(Icons.delete),
                    Text("remove_task".tr())
                  ],
                ),
                key: Key(_CurrentListElement.Id),
                onDismissed: (direction) async{
                  FilteredList.removeAt(index);
                 await  locator<LocalStorage>().DeleteTask(task: _CurrentListElement);
                  
                  //_localStorage.DeleteTask(task: _CurrentListElement);
                },
                child: TaskItem(task: _CurrentListElement),
              );
            },
          )
        : Center(
            child: Text("Aradığınızı bulamadık"),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Task> FilteredList = AllTasks.where(
      (task) {
        return task.Name.toLowerCase().contains(query.toLowerCase());
      },
    ).toList();
    return FilteredList.isNotEmpty
        ? ListView.builder(
            itemCount: FilteredList.length,
            itemBuilder: (context, index) {
              var _CurrentListElement = FilteredList[index];
              return Dismissible(
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Icon(Icons.delete),
                    Text("remove_task".tr())
                  ],
                ),
                key: Key(_CurrentListElement.Id),
                onDismissed: (direction) async{
                  FilteredList.removeAt(index);
                 await  locator<LocalStorage>().DeleteTask(task: _CurrentListElement);
                  
                  //_localStorage.DeleteTask(task: _CurrentListElement);
                },
                child: TaskItem(task: _CurrentListElement),
              );
            },
          )
        : Center(
            child: Text("Aradığınızı bulamadık"),
          );
  }
}
