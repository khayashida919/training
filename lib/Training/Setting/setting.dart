import 'package:flutter/cupertino.dart';

import '../../Database.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(height: 50),
            FutureBuilder(
                future: DbProvider.db.getTrainingModels(),
                builder: (context, AsyncSnapshot<List<TrainingModel>> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        snapshot.data.map((e) => e.toMap().toString()).join("\n\n"));
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Container();
                }),
            SizedBox(height: 100),
            FutureBuilder(
                future: DbProvider.db.getTrainingSetModels(),
                builder: (context, AsyncSnapshot<List<TrainingSetModel>> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        snapshot.data.map((e) => e.toMap().toString()).join("\n\n"));
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
