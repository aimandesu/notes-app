import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.particularLabelNotes,
  }) : super(key: key);
  final List particularLabelNotes;

  @override
  Widget build(BuildContext context) {
    //make a list yang has all this items
    return Text(particularLabelNotes[0]);
  }
}
