import 'package:flutter/material.dart';
import 'package:notes_app/screen/notes/notes.dart';

class NotesEachGrid extends StatefulWidget {
  const NotesEachGrid({
    Key? key,
    required this.title,
    required this.content,
    required this.color,
    required this.height,
    required this.randomKey,
    required this.deleteOptionBar,
    required this.changeDelOption,
  }) : super(key: key);

  final String title;
  final String content;
  final ThemeData color;
  final double height;
  final String randomKey;
  final Function deleteOptionBar;
  final bool changeDelOption;

  @override
  State<NotesEachGrid> createState() => _NotesEachGridState();
}

class _NotesEachGridState extends State<NotesEachGrid> {
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
          // height: mediaQuery.size.height * widget.height,
          // width: mediaQuery.size.width * 0.5,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: onTap ? widget.color.canvasColor : widget.color.canvasColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            border: Border.all(width: 1, color: widget.color.canvasColor),
          ),
          child: Column(
            children: [
              Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: onTap
                      ? widget.color.canvasColor
                      : Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  widget.content,
                  // overflow: TextOverflow.ellipsis,
                  maxLines: widget.height == 0.1
                      ? 2
                      : widget.height == 0.2
                          ? 5
                          : 8,
                  style: TextStyle(
                    color: onTap
                        ? widget.color.canvasColor
                        : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
