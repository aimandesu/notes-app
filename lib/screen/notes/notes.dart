import 'package:flutter/material.dart';
import 'package:notes_app/provider/color_controller.dart';
import 'package:notes_app/provider/image_data.dart';
import 'package:notes_app/provider/theme_controller.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utilities/random_key.dart' as utils;

import 'components/body.dart';

class Notes extends StatefulWidget {
  static const routeName = '/add-note';

  const Notes({
    Key? key,
    required this.sd,
    this.snapshot,
  }) : super(key: key);

  final SharedPreferences sd;
  final List<ThemeController>? snapshot;

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late ScrollController controller;
  bool _isInit = true;
  late bool showPicture;
  // late bool picExist = false;
  String? keyId;

  // var _availableNotes = NotesBluePrint(
  //   title: '',
  //   content: '',
  //   randomId: '',
  // );

  var initValues = {
    'title': '',
    'content': '',
    'randomId': utils.Utils.createCryptoStyleString(),
  };

  // void findImageCount(String noteKey) async {
  //   final imageExist =
  //       await Provider.of<ImageData>(context, listen: false).hasPic(noteKey);
  //   setState(() {
  //     picExist = imageExist;
  //   });
  // }

  void initializeShowPicNote() {
    final bool? showPic = widget.sd.getBool("showPic");
    showPic == null ? showPicture = true : showPicture = showPic;
  }

  @override
  void initState() {
    super.initState();
    initializeShowPicNote();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final particularNote =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;

      if (particularNote['title'] != 'freshNote') {
        //check if id exists or not
        // _availableNotes = Provider.of<NotesData>(context, listen: false)
        //     .findByTitle(noteTitle);
        // final _notesProv = Provider.of<NotesData>(context, listen: false)
        //     .notes()
        //     .then((value) =>
        //         value.firstWhere((element) => element.randomId == noteTitle));

        initValues = {
          'title': particularNote['title'] as String,
          'content': particularNote['content'] as String,
          'randomId': particularNote['randomKey'] as String,
        };

        // initValues = {
        //   'title': _availableNotes.title,
        //   'content': _availableNotes.content,
        //   'randomId': _availableNotes.randomId,
        // };
      }

      //here send the key
      // findImageCount(particularNote['randomKey'] == null
      //     ? ""
      //     : particularNote['randomKey'] as String);
      setState(() {
        keyId = particularNote['randomKey'];
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final colorPicker = Provider.of<ColorControl>(context);
    final mediaQuery = MediaQuery.of(context);
    final imageData = Provider.of<ImageData>(context).hasPic(keyId);

    var appBar3 = AppBar(
      title: const Text('Note'),
      actions: [
        FutureBuilder(
          future: imageData,
          // initialData: true,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    showPicture = !showPicture;
                    widget.sd.setBool("showPic", showPicture);
                  });
                },
                icon: showPicture
                    ? const Icon(Icons.open_in_new_off)
                    : const Icon(Icons.open_in_new),
              );
            } else {
              return Container();
            }
          },
        )
        // IconButton(
        //     onPressed: () {
        //       setState(() {
        //         showPicture = !showPicture;
        //         widget.sd.setBool("showPic", showPicture);
        //       });
        //     },
        //     icon: FutureBuilder(
        //       future: imageData,
        //       builder: (context, snapshot) {
        //         if (snapshot.hasData && snapshot.data != null) {
        //           return showPicture
        //               ? const Icon(Icons.open_in_new_off)
        //               : const Icon(Icons.open_in_new);
        //         } else {
        //           return Container();
        //         }
        //       },
        //     )
        //     //  picExist
        //     //     ? showPicture
        //     //         ? const Icon(Icons.open_in_new_off)
        //     //         : const Icon(Icons.open_in_new)
        //     //     : Container(),
        //     )
      ],
    );
    return Scaffold(
      appBar: appBar3,
      body: Body(
        showPicture: showPicture,
        controller: controller,
        excessivePadding: appBar3.preferredSize.height + mediaQuery.padding.top,
        // borderColor: colorPicker.,
        posColor: colorPicker.themes(widget.sd, widget.snapshot),
        initValues: initValues,
      ),
      // bottomNavigationBar:
      //     NoteNavBar(controller: controller, posColor: posColor),
    );
  }
}
