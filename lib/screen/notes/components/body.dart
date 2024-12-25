import 'dart:io';

import 'package:flutter/material.dart';

import 'package:notes_app/provider/notes_blueprint.dart';
import 'package:notes_app/provider/notes_data.dart';
import 'package:provider/provider.dart';

import '../../../provider/image_data.dart';
import 'note_navbar.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
    required this.showPicture,
    required this.controller,
    required this.excessivePadding,
    // required this.borderColor,
    required this.posColor,
    required this.initValues,
  }) : super(key: key);

  final bool showPicture;
  final ScrollController controller;
  final double excessivePadding;
  // final Color borderColor;
  final ThemeData posColor;
  final Map<String, String> initValues;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _form = GlobalKey<FormState>();
  var _notes = NotesBluePrint(
    title: '',
    content: '',
    randomId: '',
  );
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final randomIdController = TextEditingController();
  bool hasData = false;

  // void saveForm() {
  //   _form.currentState!.save();
  //   Provider.of<NotesData>(context, listen: false).addNote(_notes);
  // }

  void updateFormEachRunTime() {
    _form.currentState!.save();
    Provider.of<NotesData>(context, listen: false)
        .updateNote(randomIdController.text, _notes, hasData);
  }

  @override
  void initState() {
    super.initState();

    randomIdController.text = widget.initValues['randomId'] as String;
    titleController.text = widget.initValues['title'] as String;
    contentController.text = widget.initValues['content'] as String;

    // if (widget.initValues.isNotEmpty) {
    //   // randomIdController.text = widget.initValues['randomId'] as String;

    // }
    // if (titleController.text == '' && contentController.text == '') {
    //   titleController.text = '';
    //   contentController.text = '';
    //   // titleController.removeListener(updateFormEachRunTime);
    //   // contentController.removeListener(updateFormEachRunTime);
    // }

    titleController.addListener(updateFormEachRunTime);
    contentController.addListener(updateFormEachRunTime);
    checkAvailableNote(randomIdController.text);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    randomIdController.dispose();
    super.dispose();
  }

  Future<void> checkAvailableNote(String id) async {
    bool result = await Provider.of<NotesData>(context, listen: false)
        .doesNotAvailableDb(id);
    if (result) {
      setState(() {
        hasData = true;
      });
    } else {
      setState(() {
        hasData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final imageProvider = Provider.of<ImageData>(context);
    // final file = File(imageProvider.getFile()!.path);

    return Scaffold(
      body: Form(
        key: _form,
        child: Column(
          // controller: widget.controller,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              // margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                border:
                    Border.all(width: 1, color: widget.posColor.canvasColor),
              ),
              // height: (mediaQuery.size.height - widget.excessivePadding) * 0.09,
              width: mediaQuery.size.width * 1,
              child: Hero(
                tag: randomIdController.text,
                child: Material(
                  type: MaterialType.transparency,
                  child: TextFormField(
                    controller: titleController,
                    // initialValue: widget.initValues['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    onSaved: (value) {
                      _notes = NotesBluePrint(
                        title: titleController.text,
                        content: contentController.text,
                        randomId: randomIdController.text,
                      );
                    },
                    // onFieldSubmitted: (_) {
                    //   saveForm();
                    // },
                  ),
                ),
              ),
            ),
            widget.showPicture
                ? FutureBuilder(
                    future: imageProvider.showImage2(randomIdController.text),
                    builder: (context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            // height: mediaQuery.size.height * 0.4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                // gridDelegate:
                                //     const SliverGridDelegateWithFixedCrossAxisCount(
                                //   crossAxisCount: 3,
                                // ),
                                itemBuilder: (context, i) {
                                  return SizedBox(
                                    height: mediaQuery.size.height * 0.4,
                                    width: snapshot.data!.length == 1
                                        ? mediaQuery.size.width * 1
                                        : mediaQuery.size.width * 0.5,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image(
                                        image: FileImage(
                                          File(snapshot.data!['picture[$i]']),
                                          // File(snapshot.data![i].picturePath as String),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                : Container(),
            Expanded(
              child: Container(
                // height:
                //     (mediaQuery.size.height - widget.excessivePadding) * 0.91,
                width: mediaQuery.size.width * 1,
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  // border: Border.all(width: 1, color: widget.borderColor),
                ),
                child: SingleChildScrollView(
                  controller: widget.controller,
                  scrollDirection: Axis.vertical,
                  child: TextFormField(
                    controller: contentController,
                    // initialValue: widget.initValues['content'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    maxLines: null,
                    // style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Content',
                      hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    onSaved: (value) {
                      _notes = NotesBluePrint(
                        // title: _notes.content,
                        title: titleController.text,
                        content: contentController.text,
                        randomId: randomIdController.text,
                      );
                    },
                    // onFieldSubmitted: (_) {
                    //   _saveForm();
                    // },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NoteNavBar(
        controller: widget.controller,
        posColor: widget.posColor,
        // deleteNote: saveForm,
        noteKey: randomIdController.text, titleController: titleController,
        contentController: contentController, updateNote: updateFormEachRunTime,
        hasData: hasData,
      ),
    );
  }
}
