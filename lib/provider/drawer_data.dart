import 'package:flutter/cupertino.dart';
import 'package:notes_app/provider/drawer_blueprint.dart';

class DrawerData with ChangeNotifier {
  final List<DrawerBlueprint> _drawerData = [
    DrawerBlueprint(
      labelKey: 'f',
      labelTitle: 'favorite',
      labelBelongsTo: ['a0sPh_vsGSCSaK6K_PzEu0Ph-yisEtURkeAF5oAhlRI='],
    ),
    DrawerBlueprint(
      labelKey: 'e',
      labelTitle: 'quotes',
      labelBelongsTo: [],
    ),
    DrawerBlueprint(
      labelKey: 'l',
      labelTitle: 'notes',
      labelBelongsTo: [],
    ),
  ];

  List<DrawerBlueprint> get labelDatas {
    return [..._drawerData];
  }
}
