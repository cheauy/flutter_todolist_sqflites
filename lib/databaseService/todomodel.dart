class TodoListmodel {
  int? id;
  final String title;
  final String categories;
  bool iscomplete;

  TodoListmodel(
      {this.id,
      required this.title,
      required this.categories,
      this.iscomplete = false});

  factory TodoListmodel.frommap(Map<String, dynamic> map) {
    return TodoListmodel(
        id: map['id'], title: map['title'], categories: map['categories']);
  }
  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'title': title,
      'categories': categories,
    };
  }
}

List<TodoListmodel> titlefromMap(List<Map<String, dynamic>> fromMap) {
  return List<TodoListmodel>.from(
      fromMap.map((e) => TodoListmodel.frommap(e)).toList());
}
