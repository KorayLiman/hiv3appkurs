import 'package:flutter/material.dart';
import 'package:hiv3app/data/local_storage.dart';
import 'package:hiv3app/main.dart';
import 'package:hiv3app/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _TaskNameController = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    _TaskNameController.text = widget.task.Name;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
          ]),
      child: ListTile(
        title: widget.task.IsCompleted
            ? Text(
                widget.task.Name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                textInputAction: TextInputAction.done,
                minLines: 1,
                maxLines: 4,
                onSubmitted: ((value) {
                  if (value.length > 1) {
                    widget.task.Name = value;
              _localStorage.UpdateTask(task: widget.task);

                  }
                }),
                decoration: const InputDecoration(border: InputBorder.none),
                controller: _TaskNameController,
              ),
        leading: GestureDetector(
          onTap: () {
            setState(() {
              _localStorage.UpdateTask(task: widget.task);
              widget.task.IsCompleted = !widget.task.IsCompleted;
            });
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: widget.task.IsCompleted == true
                    ? Colors.green
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 0.8)),
          ),
        ),
        trailing: Text(
          DateFormat('dd.MM.y' + " " "hh:mm a").format(widget.task.CreatedAt),
          style: TextStyle(),
        ),
      ),
    );
  }
}
