import 'package:flutter/material.dart';
import 'package:notes_app/provider/drawer_data.dart';
import 'package:notes_app/widget/drawer_content.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
    required this.excessivePadding,
  }) : super(key: key);

  final double excessivePadding;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool newLabel = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final drawerListLabel = Provider.of<DrawerData>(context, listen: false);

    return Container(
      // width: mediaQuery.size.width * 0.5,
      margin: EdgeInsets.only(
        top: widget.excessivePadding,
        left: 5,
        bottom: (mediaQuery.size.height - widget.excessivePadding) * 0.1,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Drawer(
          child: Column(
            children: [
              AppBar(
                title: const Text('Labels'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        newLabel = true;
                      });
                    },
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
              newLabel
                  ? ListTile(
                      leading: Icon(Icons.label,
                          color: Theme.of(context).iconTheme.color),
                      title: TextFormField(
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            newLabel = false;
                          });
                        },
                        icon: Icon(
                          Icons.check,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: drawerListLabel.labelDatas.length,
                  itemBuilder: (_, i) => DrawerContent(
                    labelKey: drawerListLabel.labelDatas[i].labelKey,
                    labelTitle: drawerListLabel.labelDatas[i].labelTitle,
                    keysItem: drawerListLabel.labelDatas[i].labelBelongsTo,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
