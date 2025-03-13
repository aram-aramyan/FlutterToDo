import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Список дел на Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Мой список дел'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  //Список дел
  final List<String> items = [];

  // Данные открытой в редакторе задачи
  String editTask = '';
  int editTaskIndex = -1;

 void _addItem() {
    editTaskIndex = -1;
    editTask = '';

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 100,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Spacer(flex: 1),
                
                // Тестовое поле для ввода названия задачи
                Flexible(
                  flex: 6,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Введите название задачи',
                      border: OutlineInputBorder(),
                    ),
                    // При изменении текста - сохраняем в переменную editTask
                    onChanged: (value) {
                      editTask = value;
                    },
                  ),
                ),

                // Кнопка "ОК" добавляет задачу с указанным названием
                Flexible(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        if (editTask.isEmpty) {
                          editTask = 'Задача без названия';
                        }

                        items.add(editTask);
                      });

                      Navigator.pop(context);
                    },
                    child: Text('ОК'),
                  ),
                ),

                // Кнопка "Отмена" просто закрывает окно
                Flexible(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Отмена'),
                  ),
                ),
                
                
              ],
            ),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex--;
                  setState(() {
                    final item = items.removeAt(oldIndex);
                    items.insert(newIndex, item);
                  });
                },
                children: [
                  for (final item in items)
                    ListTile(
                      key: ValueKey(item),
                      title: Text(item),
                    ),
                ],
              ),
            ),
            Text(
              'Количество: ${items.length}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Добавить',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
