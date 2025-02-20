import 'package:flutter/material.dart';

class Todocard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;

  const Todocard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'];
    return Card(
      child: ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
          ),
          title: Text(item['title']),
          subtitle: Text(item['description']),
          trailing: PopupMenuButton(
            onSelected: (value) {
              if (value == 'edit') {
                // open edit page
                navigateEdit(item);
              } else if (value == 'delete') {
                // delete and remove the item
                deleteById(id);
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('edit'),
                  value: 'edit',
                ),
                PopupMenuItem(
                  child: Text('delete'),
                  value: 'delete',
                )
              ];
            },
          )),
    );
  }
}
