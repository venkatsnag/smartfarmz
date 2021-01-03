import 'package:flutter/material.dart';

class Utilities extends StatefulWidget {
   final String collectionDbName;
  final String languageCode;

  /// highlight last icon (story image preview)
  final bool lastIconHighlight;
  final Color lastIconHighlightColor;
  final Radius lastIconHighlightRadius;

  /// preview images settings
  final double iconWidth;
  final double iconHeight;
  final bool showTitleOnIcon;
  final TextStyle iconTextStyle;
  final BoxDecoration iconBoxDecoration;
  final BorderRadius iconImageBorderRadius;
  final EdgeInsets textInIconPadding;

  Utilities(
      {@required this.collectionDbName,
      this.lastIconHighlight = false,
      this.lastIconHighlightColor = Colors.deepOrange,
      this.lastIconHighlightRadius = const Radius.circular(15.0),
      this.iconWidth,
      this.iconHeight,
      this.showTitleOnIcon = true,
      this.iconTextStyle,
      this.iconBoxDecoration,
      this.iconImageBorderRadius,
      this.textInIconPadding =
          const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      
      this.languageCode = 'en'});
  @override
  _UtilitiesState createState() => _UtilitiesState();
}

class _UtilitiesState extends State<Utilities> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}