import 'package:flutter/material.dart';

final List<Map<String, dynamic>> listItems = [
  {'taskName': 'Item 1', 'isDone': false},
  {'taskName': 'Item 2', 'isDone': false},
  {'taskName': 'Item 3', 'isDone': false},
];

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Todo App', home: TodoListPage());
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('タスク一覧')),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        checkColor: Colors.white,
                        value: listItems[index]["isDone"],
                        onChanged: (bool? value) {
                          setState(() {
                            listItems[index]["isDone"] = value!;
                          });
                        },
                      ),
                      title: listItems[index]["isDone"]
                          ? Text(
                              listItems[index]["taskName"],
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                              ),
                            )
                          : Text(listItems[index]["taskName"],
                            ),
                      trailing: Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newText = await Navigator.of(context).push<String>(
              MaterialPageRoute(builder: (context) => const NextPage()),
            );

            // 戻り値がnullでない（何かしらの値が入力された）場合、リストに追加
            if (newText != "" && newText != null) {
              setState(() {
                listItems.add({"taskName": newText, "isDone": false});
              });
            }
            // 戻ってきた値をDebug Logに表示
            // debugPrint(newText);
          },

          tooltip: 'NextPage',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// 次のページ (NextPage)
class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  String taskContent = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('次のページ')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              width: 300,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    taskContent = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'タスクの内容',
                ),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(taskContent);
              },
              child: const Text('タスクを追加'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
          ),
        ],
      ),
    );
  }
}