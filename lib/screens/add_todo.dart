import 'package:flutter/material.dart';
import 'package:todo_app_rest_api/services/todo_service.dart';
import 'package:todo_app_rest_api/utils/snackbar_helper.dart';

class AddTodo extends StatefulWidget {
  final Map? todo;
  const AddTodo({super.key, this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          )
        ],
      ),
    );
  }

  void updateData() async {
    // get the data from form
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final todoId = todo['_id'];
    //submit data to the server
    final isSuccess = await TodoService.updateTodo(
      todoId,
      body,
    );
    // show success or fail message based on status
    if (isSuccess) {
      showSuccessMessage(
        context,
        'Update Sucess',
      );
    } else {
      showErrorMessage(
        context,
        'Update Failed',
      );
    }
  }

  void submitData() async {
    //submit data to the server
    final isSuccess = await TodoService.createTodo(body);
    // show success or fail message based on status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(
        context,
        'Creation Sucess',
      );
    } else {
      showErrorMessage(
        context,
        'Creation Failed',
      );
    }
  }

  Map get body {
    // get data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }
}
