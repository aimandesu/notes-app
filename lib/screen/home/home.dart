import 'package:flutter/material.dart';
import 'package:notes_app/provider/notes_data.dart';
import 'package:notes_app/provider/theme_controller.dart';
import 'package:notes_app/widget/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/image_data.dart';
import 'components/body.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.sd,
    required this.snapshot,
  }) : super(key: key);

  final SharedPreferences sd;
  final List<ThemeController>? snapshot;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void firstDisplay() {
    final bool? firstDisplay = widget.sd.getBool("trayOrList");
    firstDisplay == null
        ? displayOrientationList = false
        : displayOrientationList = firstDisplay;
  }

  @override
  void initState() {
    super.initState();
    firstDisplay();
  }

  bool openColorOption = false;
  late bool displayOrientationList;
  bool changeDelOption = false;
  List<String> deleteList = [];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final noteProvider = Provider.of<NotesData>(context, listen: false);
    final imageProvider = Provider.of<ImageData>(context, listen: false);

    void _removeListof() {
      setState(() {
        changeDelOption = false;
        deleteList = [];
      });
    }

    void deleteOptionBar(String id) {
      setState(() {
        changeDelOption = true;
        bool ifHasAlready = deleteList.contains(id);
        if (ifHasAlready) {
          deleteList.removeWhere((element) => element.contains(id));
          if (deleteList.isEmpty) _removeListof();
        } else {
          deleteList.add(id);
        }
      });
    }

    var appBar2 = changeDelOption
        ? AppBar(
            leading: IconButton(
              onPressed: () {
                _removeListof();
              },
              icon: const Icon(Icons.undo),
            ),
            title: Text(deleteList.length.toString()),
            actions: [
              IconButton(
                onPressed: () async {
                  await noteProvider.deleteNoteDb(deleteList);
                  await imageProvider.deleteAllPicture(deleteList);
                  _removeListof();
                },
                icon: const Icon(Icons.delete),
              )
            ],
          )
        : AppBar(
            title: const Text('Notes'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    displayOrientationList = !displayOrientationList;
                    widget.sd.setBool("trayOrList", displayOrientationList);
                  });
                },
                icon: displayOrientationList
                    ? const Icon(Icons.blur_linear_sharp)
                    : const Icon(Icons.list),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    openColorOption = !openColorOption;
                  });
                },
                icon: const Icon(Icons.color_lens),
              ),
            ],
          );
    return Scaffold(
      appBar: appBar2,
      body: Body(
        openColorOption: openColorOption,
        excessivePadding: appBar2.preferredSize.height + mediaQuery.padding.top,
        displayOrientationList: displayOrientationList,
        deleteOptionBar: deleteOptionBar,
        changeDelOption: changeDelOption,
        sd: widget.sd,
        snapshot: widget.snapshot,
      ),
      drawer: CustomDrawer(
        excessivePadding: appBar2.preferredSize.height + mediaQuery.padding.top,
      ),
    );
  }
}
