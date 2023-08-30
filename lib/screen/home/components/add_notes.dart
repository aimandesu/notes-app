import 'package:flutter/material.dart';
import 'package:notes_app/screen/notes/notes.dart';

class AddNotes extends StatelessWidget {
  const AddNotes({
    Key? key,
    required this.excessivePadding,
  }) : super(key: key);

  final double excessivePadding;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: (mediaQuery.size.height - excessivePadding) * 0.1,
      color: Colors.black12,
      // Theme.of(context).colorScheme.surface, for cardcolor in themedata
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                Notes.routeName,
                arguments: {
                  'title': 'freshNote',
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
