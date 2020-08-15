
import 'package:flutter/material.dart';

enum TrainingPhase {
  countDown,
  training,
  interval,
  finish,
}

extension TrainingPhaseExtension on TrainingPhase {
  String get explanation {
    switch (this) {
      case TrainingPhase.countDown: return "準備をしてください";
      case TrainingPhase.training: return "トレーニング中…";
      case TrainingPhase.interval: return "インターバル…";
      case TrainingPhase.finish: return "おつかれさまでした";
    }
    return "";
  }
}

class TrainingProvider with ChangeNotifier {
  TrainingProvider(this.title, this.trainingTime, this.intervalTime, this.repeatTime);
  TrainingPhase phase = TrainingPhase.countDown;
  static const int countDownTime = 3;
  String title = "";
  int trainingTime = 0;
  int intervalTime = 0;
  int repeatTime = 0;

  int time() {
    switch (phase) {
      case TrainingPhase.countDown: return countDownTime;
      case TrainingPhase.training: return trainingTime;
      case TrainingPhase.interval: return intervalTime;
      case TrainingPhase.finish: return 0;
    }
    return 0;
  }

  void changeNextPhase() {
    switch (phase) {
      case TrainingPhase.countDown:
        repeatTime--;
        this.phase = TrainingPhase.training; break;
      case TrainingPhase.training:
        if (repeatTime == 0) {
          this.phase = TrainingPhase.finish;
        } else {
          this.phase = TrainingPhase.interval;
        }
        break;
      case TrainingPhase.interval:
        repeatTime--;
        this.phase = TrainingPhase.training; break;
      case TrainingPhase.finish:
        return;
    }
    notifyListeners();
  }

}