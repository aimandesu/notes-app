class DrawerBlueprint {
  final String labelKey;
  final String labelTitle;
  List<String> labelBelongsTo;

  DrawerBlueprint({
    required this.labelKey,
    required this.labelTitle,
    this.labelBelongsTo = const [],
  });
}
