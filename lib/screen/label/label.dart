import 'package:flutter/material.dart';
import 'package:notes_app/screen/label/components/body.dart';

class Label extends StatelessWidget {
  static const routeName = '/label';

  const Label({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final particularLabelNotes =
        ModalRoute.of(context)!.settings.arguments as List;
    return Scaffold(
      body: Body(
        particularLabelNotes: particularLabelNotes,
      ),
    );
  }
}
