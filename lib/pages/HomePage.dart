import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hiv3app/data/local_storage.dart';
import 'package:hiv3app/helper/translation_helper.dart';
import 'package:hiv3app/main.dart';
import 'package:hiv3app/models/task_model.dart';
import 'package:hiv3app/widgets/mysearchdelegate.dart';
import 'package:hiv3app/widgets/tasklistitem.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _AllTasks;
  late LocalStorage _localStorage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
    _AllTasks = <Task>[];
    _GetAllTasksfromDb();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  _ShowSearchPage();
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  _ShowAddTaskBottomSheet(context);
                },
                icon: Icon(Icons.add))
          ],
          title: GestureDetector(
            onTap: () {
              _ShowAddTaskBottomSheet(context);
            },
            child: Text(
              "title",
              style: TextStyle(color: Colors.black),
            ).tr(),
          ),
          centerTitle: false,
        ),
        body: _AllTasks.isNotEmpty
            ? ListView.builder(
                itemCount: _AllTasks.length,
                itemBuilder: (context, index) {
                  var _CurrentListElement = _AllTasks[index];
                  return Dismissible(
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.delete), Text("remove_task").tr()],
                    ),
                    key: Key(_CurrentListElement.Id),
                    onDismissed: (direction) {
                      setState(() {
                        _AllTasks.removeAt(index);
                        _localStorage.DeleteTask(task: _CurrentListElement);
                      });
                    },
                    child: TaskItem(task: _CurrentListElement),
                  );
                },
              )
            : Center(child: Text("add_task").tr()));
  }

  void _ShowAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              title: TextField(
                autofocus: true,
                onSubmitted: (value) {
                  Navigator.pop(context);
                  if (value.length > 1) {
                    DatePicker.showDateTimePicker(context,
                        locale: TranslationHelper.getDeviceLanguage(context), onConfirm: (time) async {
                      var NewTask = Task.create(Name: value, CreatedAt: time);
                      _AllTasks.insert(0, NewTask);
                      await _localStorage.AddTask(task: NewTask);

                      setState(() {});
                    });
                  }
                },
                decoration: InputDecoration(hintText: "add_task".tr()),
              ),
            ),
          );
        });
  }

  void _GetAllTasksfromDb() async {
    _AllTasks = await _localStorage.GetAllTasks();

    setState(() {});
  }

  void _ShowSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(AllTasks: _AllTasks));
    _GetAllTasksfromDb();
  }
}
