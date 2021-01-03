import 'package:flutter/material.dart';
import '../providers/crop.dart';
import './crop_item.dart';
import 'package:provider/provider.dart';
import '../l10n/gallery_localizations.dart';
import '../providers/crops.dart';
import 'package:flutter/scheduler.dart';

import 'dart:ui';
/* 
enum BannerAction {
  reset,
  showMultipleActions,
  showLeading,
} */

class CropsGrid extends StatelessWidget {
  final bool showFavs;

  CropsGrid(this.showFavs);

  final noCropText = Text('No Crops Registered! Register crop');

  @override
  Widget build(BuildContext context) {
    final cropsData = Provider.of<Crops>(context);
    final crops = showFavs ? cropsData.favortieItems : cropsData.items;
    if (cropsData.items.length > 0) {
      return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: crops.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: crops[i],
          child: CropItem(
            crops[i].id,
            crops[i].title,
            crops[i].imageUrl,
          ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
      );
    } else {
      return Banner();
    }
  }
}

class Banner extends StatefulWidget {
  const Banner();

  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  var _showMultipleActions = true;
  var _displayBanner = true;
  var _showLeading = true;

/*   void handleDemoAction(BannerAction action) {
    setState(() {
      switch (action) {
        case BannerAction.reset:
          _displayBanner = true;
          
          _showLeading = true;
          break;
       
        case BannerAction.showLeading:
          _showLeading = !_showLeading;
          break;
      }
    });
  } */

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      content: Text(GalleryLocalizations.of(context).noCropText),
      leading: _showLeading
          ? CircleAvatar(
              child: Icon(Icons.bookmark),
            )
          : null,
      actions: [
        FlatButton(
          child: Text("Go to Land Registration page"),
          onPressed: () {
            setState(() {
              _displayBanner = false;

              Navigator.pushNamed(context, '/fields-overview');
            });
          },
        ),
        FlatButton(
          child: Text(GalleryLocalizations.of(context).dismiss),
          onPressed: () {
            setState(() {
              _displayBanner = false;
            });
            Navigator.pushReplacementNamed(context, '/guest_home_screen');
          },
        ),
      ],
    );
  }
}
