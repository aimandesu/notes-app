import 'package:flutter/material.dart';
import 'package:notes_app/provider/drawer_blueprint.dart';
import 'package:notes_app/screen/label/label.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({
    Key? key,
    required this.labelKey,
    required this.labelTitle,
    required this.keysItem,
  }) : super(key: key);
  final String labelTitle;
  final List keysItem;
  final String labelKey;

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  bool openTextInput = false;
  bool changeIconEdit = false;
  final labelTitleController = TextEditingController();
  final _form = GlobalKey<FormState>();

  // var _label = DrawerBlueprint(
  //   labelTitle: '',
  //   labelKey: '',
  // );

  // void updateLabel() {}

  void updateLabel(DrawerBlueprint labelToUpdte) {
    _form.currentState!.save();
    setState(() {
      changeIconEdit = false;
      openTextInput = false;
      // Provider.of<DrawerData>(context);
      //after this kena update dlm database and then buat notifylisteners
    });
  }

  @override
  void initState() {
    super.initState();
    labelTitleController.text = widget.labelTitle;
    // labelTitleController.addListener(updateLabel);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          Label.routeName,
          arguments: widget.keysItem,
        );
      },
      leading: Icon(
        Icons.label,
        color: Theme.of(context).iconTheme.color,
      ),
      title: openTextInput
          ? Form(
              key: _form,
              child: TextFormField(
                controller: labelTitleController,
                onFieldSubmitted: (_) {
                  var _label = DrawerBlueprint(
                    labelKey: widget.labelKey,
                    labelTitle: labelTitleController.text,
                  );
                  updateLabel(_label);
                },
              ),
            )
          : Text(widget.labelTitle),
      trailing: changeIconEdit
          ? IconButton(
              onPressed: null,
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).iconTheme.color,
              ))
          : IconButton(
              onPressed: () {
                setState(() {
                  changeIconEdit = true;
                  openTextInput = true;
                });
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).iconTheme.color,
              )),
    );
  }
}
