import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planktraining/CircularTimer/circularTimer.dart';
import 'package:planktraining/Training/Training/trainingProvider.dart';
import 'package:planktraining/admob/ad_manager.dart';
import 'package:provider/provider.dart';
import 'package:soundpool/soundpool.dart';

import '../../Database.dart';

class TrainingScreen extends StatelessWidget {
  TrainingScreen(
      this._title, this._trainingTime, this._intervalTime, this._repeatTime);
  String _title;
  int _trainingTime;
  int _intervalTime;
  int _repeatTime;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) =>
            TrainingProvider(_title, _trainingTime, _intervalTime, _repeatTime),
        child: TrainingScreenBody());
  }
}

class TrainingScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: ListView(
          children: <Widget>[
            AdmobBanner(
              adUnitId: AdMobService().getBannerAdUnitId(),
              adSize: AdmobBannerSize(
                width: MediaQuery.of(context).size.width.toInt(),
                height: AdMobService().getHeight(context).toInt(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 32),
                  Text(context.watch<TrainingProvider>().phase.explanation,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 24)),
                  SizedBox(height: 48),
                  Timer(context.watch<TrainingProvider>().phase),
                  SizedBox(height: 48),
                  if (context.watch<TrainingProvider>().phase !=
                      TrainingPhase.finish)
                    Text("あと ${context.watch<TrainingProvider>().repeatTime}回",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  if (context.watch<TrainingProvider>().phase ==
                      TrainingPhase.finish)
                    SizedBox(
                      height: 80,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.redAccent,
                        child: Text(
                          "終了",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          final trainingModel =
                              context.read<TrainingProvider>();
                          final database = await DbProvider.db.database;
                          database.insert(
                              DbProvider.db.tableName,
                              TrainingModel(
                                trainingModel.title,
                                DateTime.now().toString(),
                                trainingModel.trainingTime,
                                trainingModel.intervalTime,
                                trainingModel.repeatTime,
                                "",
                                "",
                                "",
                              ).toMap());
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                ],
              ),
            ),
            AdmobBanner(
              adUnitId: AdMobService().getBannerAdUnitId(),
              adSize: AdmobBannerSize(
                width: MediaQuery.of(context).size.width.toInt(),
                height: AdMobService().getHeight(context).toInt(),
              ),
            ),
          ],
        ));
  }
}

Soundpool _pool = Soundpool(streamType: StreamType.notification);

class Timer extends StatelessWidget {
  Timer(this.phase);

  TrainingPhase phase = TrainingPhase.countDown;

  Color color(TrainingPhase phase) {
    switch (phase) {
      case TrainingPhase.countDown:
        return Colors.grey;
        break;
      case TrainingPhase.training:
        return Colors.red;
        break;
      case TrainingPhase.interval:
        return Colors.orangeAccent;
        break;
      case TrainingPhase.finish:
        return Colors.red;
        break;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    TrainingProvider trainingProvider = context.watch<TrainingProvider>();
    return CircularCountDownTimer(
        duration: trainingProvider.time(),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.4,
        color: Colors.white,
        fillColor: color(phase),
        strokeWidth: 50.0,
        textStyle: TextStyle(
            fontSize: 20.0, color: Colors.black54, fontWeight: FontWeight.bold),
        isReverse: phase == TrainingPhase.countDown,
        /* 遅延実行させないとBuild中に変更がかかり状態が更新されない */
        on3secondsAgo: () async {
          int soundId = await rootBundle
              .load("sound/countdown.mp3")
              .then((ByteData soundData) {
            return _pool.load(soundData);
          });
          await _pool.play(soundId);
        },
        onComplete: () => Future.delayed(Duration(milliseconds: 10))
            .then((_) => context.read<TrainingProvider>().changeNextPhase()));
  }
}
