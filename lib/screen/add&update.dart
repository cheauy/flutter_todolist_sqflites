import 'package:flutter/material.dart';

import 'package:todolists/databaseService/todomodel.dart';

import '../databaseService/databaseservice.dart';

class Addandupdate extends StatefulWidget {
  final TodoListmodel? todo;
  const Addandupdate({super.key, this.todo});

  @override
  State<Addandupdate> createState() => _AddandupdateState();
}

class _AddandupdateState extends State<Addandupdate> {
  final _formkey = GlobalKey<FormState>();
  List<TodoListmodel> todo = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController cateController = TextEditingController();
  int? id;
  String valid = "";
  bool isEdit = false;
  void initState() {
    var todo = widget.todo;
    if (todo == null) {
    } else {
      titleController.text = todo.title;
      cateController.text = todo.categories;
      id = todo.id;
      isEdit = true;
    }

    super.initState();
  }

  void checkExistitem(String title) async {
    var isExist = await DatabaseService().isTitleExist(title);

    if (isExist.isNotEmpty) {}
    return null;
  }

  void snackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        closeIconColor: Colors.white,
        showCloseIcon: true,
        content: Container(
          padding: const EdgeInsets.all(10),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color:
            //     Color(0xff005f6b),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    isEdit
                        ? "Updated success (pull to refresh)"
                        : "Success Created (pull to refresh)",
                  ),
                ],
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xff005f6b),
        padding: const EdgeInsets.all(2),
      ),
    );
  }

  void sumbmitform(String newItem) async {
    final todo = TodoListmodel(
        title: titleController.text, categories: cateController.text);
    if (_formkey.currentState!.validate()) {
      await DatabaseService().createlist(todo).whenComplete(() {
        snackbar();
        cateController.clear;
        titleController.clear();
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    child: Text(
                  isEdit ? "Update your note" : "Add your new note",
                  style: const TextStyle(fontSize: 20),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: titleController,
                      onFieldSubmitted: (value) =>
                          isEdit ? null : sumbmitform(value),
                      decoration: const InputDecoration(
                        //  errorText: valid.isEmpty ? null : valid,
                        hintText: "Enter somthing to do.....",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please the fill can\'t be empty';
                        } else if (value.length < 4) {
                          return 'Please at least 4 charctor up';
                        } else
                          return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: cateController,
                    onFieldSubmitted: (value) =>
                        isEdit ? null : sumbmitform(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please the fill can\'t be empty';
                      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Please Enter number only (example: 123)';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Date",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (isEdit)
                  ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      onPressed: () async {
                        _formkey.currentState!.validate();
                        TodoListmodel todoListmodel = TodoListmodel(
                            title: titleController.text,
                            categories: cateController.text);

                        if (isEdit) {
                          if (_formkey.currentState!.validate()) {
                            await DatabaseService()
                                .updatelist(todoListmodel, id!)
                                .whenComplete(() {
                              snackbar();
                              Navigator.pop(context);
                            });
                          }
                        }
                      },
                      child:
                          // Text(updateStudent ? "Update Data" : "Save Data")
                          const Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
