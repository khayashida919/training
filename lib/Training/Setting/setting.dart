import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:planktraining/admob/ad_manager.dart';

import '../../Database.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            AdmobBanner(
              adUnitId: AdMobService().getBannerAdUnitId(),
              adSize: AdmobBannerSize(
                width: MediaQuery.of(context).size.width.toInt(),
                height: AdMobService().getHeight(context).toInt(),
              ),
            ),
            SizedBox(height: 5),
            FutureBuilder(
                future: DbProvider.db.getTrainingModels(),
                builder:
                    (context, AsyncSnapshot<List<TrainingModel>> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data
                        .map((e) => e.toMap().toString())
                        .join("\n\n"));
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Container();
                }),
            SizedBox(height: 100),
            FutureBuilder(
                future: DbProvider.db.getTrainingSetModels(),
                builder:
                    (context, AsyncSnapshot<List<TrainingSetModel>> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data
                        .map((e) => e.toMap().toString())
                        .join("\n\n"));
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Container();
                })
          ],
        ),
      ],
    );
  }
}
