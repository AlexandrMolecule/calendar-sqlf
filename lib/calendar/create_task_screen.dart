import 'package:calendaer_test_app/calendar/calendar.dart';
import 'package:calendaer_test_app/local_db/local_db.dart';
import 'package:calendaer_test_app/model/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateTask extends StatefulWidget {
  final DateTime date;
  const CreateTask({Key? key, required this.date}) : super(key: key);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final DatabaseSql db = DatabaseSql();
  late List<DateTime> items;
  DateTime selectedTime = DateTime(0, 0, 0, 0, 30);
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    items = [
      DateTime(widget.date.year, 0, 0, 0, 30),
      DateTime(0, 0, 0, 1, 0),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 1, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 2, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 2, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 3, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 3, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 4, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 4, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 5, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 5, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 6, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 6, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 7, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 7, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 8, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 8, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 9, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 9, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 10, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 10, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 11, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 11, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 12, 0),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 12, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 13, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 13, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 14, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 14, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 15, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 15, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 16, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 16, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 17, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 17, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 18, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 18, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 19, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 19, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 20, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 20, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 21, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 21, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 22, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 22, 30),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 23, 00),
      DateTime(widget.date.year, widget.date.month, widget.date.day, 23, 30),
      DateTime(0, 0, 0, 24, 00),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 500,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: descriptionController,
                        decoration:
                            InputDecoration(hintText: 'Task description'),
                      ),
                      Container(
                        width: 300,
                        height: 200,
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          itemExtent: 30,
                          scrollController:
                              FixedExtentScrollController(initialItem: 1),
                          children: items
                              .map((e) => Text('${e.hour}h:${e.minute}m'))
                              .toList(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedTime = items.elementAt(index);
                              print(selectedTime);
                            });
                          },
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Create Task'),
                        onPressed: () {
                          if (selectedTime == null ||
                              descriptionController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('choose time, and description')));
                            return null;
                          }
                          final item = Task(
                              description: descriptionController.text,
                              time: widget.date.toString(),
                              whenMustComplete: selectedTime.toString());
                          final task = item.toMap();
                          print(item);
                          print(task);
                          db.database.whenComplete(() => db.insert(task));
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => CreateTask(
                                        date: widget.date,
                                      )));
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CalendarPage()));
          },
        ),
        title: Text(
            '${widget.date.day} ${widget.date.month < 10 ? '0${widget.date.month}' : widget.date.month} ${widget.date.year}'),
      ),
      body: Column(
        children: [
          Flexible(
            child: FutureBuilder<List<Map<String, dynamic>>?>(
                future: db.getTasks(widget.date.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      tasks = snapshot.data!;
                      tasks = List.from(tasks);
                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          final task = Task.fromMap(tasks[index]);

                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) async {
                              print('id : $task');
                              db.delete(task.id!);
                              setState(() {
                                print(tasks);
                                tasks.removeAt(index);
                                print(tasks);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(task.description),
                                      Text(
                                          'Time to complete:${DateTime.parse(task.whenMustComplete).hour}h:${DateTime.parse(task.whenMustComplete).minute}m')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else
                      Container();
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }
}
