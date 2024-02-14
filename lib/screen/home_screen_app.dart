import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolists/databaseService/databaseservice.dart';

import 'package:todolists/databaseService/todomodel.dart';
import 'package:todolists/screen/add&update.dart';

class Homesceen extends StatefulWidget {
  final TodoListmodel? list;
  const Homesceen({super.key, this.list});

  @override
  State<Homesceen> createState() => _HomesceenState();
}

int currentIndex = 0;

class _HomesceenState extends State<Homesceen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController cateController = TextEditingController();
  TextEditingController SearchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<TodoListmodel> todo = [];

  String valid = "Please it cant be empty";
  int? id;
  bool loading = true;

  Future<void> readData() async {
    await DatabaseService().readlist().then((value) {
      setState(() {
        todo = value;
        loading = false;
      });
    });
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  void close() {
    setState(() {
      readData();
      SearchController.clear();
    });
  }

  void search(String query) {
    if (query.isEmpty) {
      _refreshList();
    } else if (todo.isEmpty) {
      const Center(child: Text("No result"));
    } else {
      final suggestions = todo.where((todo) {
        final title = todo.title.toLowerCase();
        final input = query.toLowerCase();
        return title.contains(input);
      }).toList();
      setState(() {
        todo = suggestions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdae9f4),
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: SearchController,
                onChanged: search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(10),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: 'Search by title',
                  suffixIcon: IconButton(
                      onPressed: () {
                        close();
                      },
                      icon: const Icon(Icons.close)),
                ),
              ),
            )),
        backgroundColor: const Color(0xff005f6b),
        title: const Text('Your Notes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: todo.isNotEmpty
          ? Container(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        //  await Future.delayed(const Duration(seconds: 1));
                        _refreshList();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(7),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: todo.length,
                                  itemBuilder: (context, index) {
                                    var list = todo[index];
                                    return Card(
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(5),
                                        leading: IconButton(
                                            onPressed: () {
                                              showCupertinoAlertDialog2(
                                                  context, list);
                                              // setState(() {

                                              // });
                                            },
                                            icon: Icon(
                                              Icons.circle,
                                              color: list.iscomplete
                                                  ? Colors.green
                                                  : Colors.amber,
                                            )),
                                        subtitle: Text(list.categories),
                                        title: Text(list.title,
                                            textAlign: TextAlign.start,
                                            style: list.iscomplete
                                                ? const TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 16,
                                                  )
                                                : null),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  titleController.text =
                                                      list.title;
                                                  cateController.text =
                                                      list.categories;
                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return Addandupdate(
                                                          todo: list,
                                                        );
                                                      });
                                                },
                                                icon: const Icon(
                                                  Icons.edit_square,
                                                  color: Colors.blueAccent,
                                                )),
                                            IconButton(
                                                onPressed: () async {
                                                  await DatabaseService()
                                                      .deletelist(list.id!)
                                                      .whenComplete(() {
                                                    snackbar(context);
                                                    readData();
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      )),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshList(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 250),
                        child: const Text(
                          "No result\n(Pull up to refesh)",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const Addtask()));
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return const Addandupdate();
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _refreshList() async {
    // Prevent multiple refreshes at the same time
    if (!loading) {
      setState(() {
        loading = true;
      });
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      readData();
      loading = false;
      todo.clear();
    });
  }

  void showCupertinoAlertDialog2(
      BuildContext context, TodoListmodel todoListmodel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title:
              Text(todoListmodel.iscomplete ? 'Unmark ?' : ' Mark as read ?'),
          content: Text(todoListmodel.iscomplete
              ? 'Are you sure you want to unmark?'
              : 'Are you sure  already finish the task if you want to un remark please click agian !'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(todoListmodel.iscomplete ? 'OK' : 'Mark'),
              onPressed: () async {
                setState(() {
                  todoListmodel.iscomplete = !todoListmodel.iscomplete;
                });
                // Handle OK button  press

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

void snackbar(BuildContext context) {
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Success Deleted ",
                ),
              ],
            ),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color(0xff005f6b),
      padding: EdgeInsets.all(2),
    ),
  );
}
