import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(BuildContext context, Map item) navigateToEditPage;
  final Function(String id) deleteById;
  const TodoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateToEditPage,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == "edit") {
              navigateToEditPage(context, item);
            } else if (value == "delete") {
              deleteById(value);
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ];
          },
        ),
      ),
    );
  }
}
