import 'package:flutter/material.dart';

import 'package:notes_app/screen/notes/notes.dart';

class NotesEach extends StatefulWidget {
  const NotesEach({
    Key? key,
    required this.title,
    required this.content,
    required this.color,
    required this.randomKey,
    required this.deleteOptionBar,
    required this.changeDelOption,
  }) : super(key: key);

  final String title;
  final String content;
  final ThemeData color;
  final String randomKey;
  final Function deleteOptionBar;
  final bool changeDelOption;

  @override
  State<NotesEach> createState() => _NotesEachState();
}

class _NotesEachState extends State<NotesEach> {
  bool onTap = false;

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);

    if (!widget.changeDelOption) {
      setState(() {
        onTap = false;
      });
    }

    return InkWell(
      onLongPress: () {
        widget.deleteOptionBar(widget.randomKey);
        setState(() {
          onTap = !onTap;
        });
      },
      onTap: () {
        if (widget.changeDelOption) {
          widget.deleteOptionBar(widget.randomKey);
          setState(() {
            onTap = !onTap;
          });
        } else if (!widget.changeDelOption) {
          Navigator.of(context).pushNamed(
            Notes.routeName,
            arguments: {
              'randomKey': widget.randomKey,
              'title': widget.title,
              'content': widget.content
            },
          );
        }
      },
      child: Container(
        // height: mediaQuery.size.height * 0.1,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color:
              onTap ? widget.color.backgroundColor : widget.color.canvasColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
          border: Border.all(
            width: 1,
            color: widget.color.backgroundColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.randomKey,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: onTap
                              ? widget.color.canvasColor
                              : Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: onTap
                          ? widget.color.canvasColor
                          : Theme.of(context).textTheme.bodyText1!.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
