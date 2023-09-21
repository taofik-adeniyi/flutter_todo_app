import 'package:flutter/material.dart';
import 'package:todo_app_rest_api/screens/add_todo.dart';
import 'package:todo_app_rest_api/services/todo_service.dart';
import 'package:todo_app_rest_api/utils/snackbar_helper.dart';
import 'package:todo_app_rest_api/widgets/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddPage(context);
        },
        label: const Text('Add Todo'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text('No Todo Item'),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                return TodoCard(
                  index: index,
                  item: item,
                  navigateToEditPage: navigateToEditPage,
                  deleteById: deleteById,
                );
              },
              itemCount: items.length,
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> navigateToAddPage(BuildContext context) async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodo(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(BuildContext context, Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodo(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    // delete the item
    setState(() {
      isLoading = true;
    });
    final isSuccess = await TodoService.deleteById(id);
    setState(() {
      isLoading = false;
    });
    if (isSuccess) {
      final filteredItems = items.where((item) => item['_id'] != id).toList();
      setState(() {
        items = filteredItems;
      });
    } else {
      showErrorMessage(
        context,
        'Deletion Failed',
      );
    }
    // remove itme from lists
  }

  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });
    final response = await TodoService.fetchTodos();
    setState(() {
      isLoading = false;
    });
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(
        context,
        'Unable to fetch todos',
      );
    }
  }
}
