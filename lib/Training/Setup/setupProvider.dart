
import 'package:flutter/material.dart';
import 'package:planktraining/Database.dart';

class SetupProvider with ChangeNotifier {

  String title = "腹筋";
  int trainingTime = 30;
  int intervalTime = 5;
  int repeatTime = 3;

  void changeTraining(int value) {
    trainingTime = value;
    notifyListeners();
  }

  void changeIntervalTime(int value) {
    intervalTime = value;
    notifyListeners();
  }

  void changeRepeatTime(int value) {
    repeatTime = value;
    notifyListeners();
  }

  void selectedTrainingSet() async {
    List<TrainingSetModel> trainingSets = await DbProvider.db.getTrainingSetModels();
    if (trainingSets.isEmpty) return;
    TrainingSetModel trainingSet = trainingSets.firstWhere((element) => element.isEnable == 1);
    trainingTime = trainingSet.trainingTime;
    repeatTime = trainingSet.repeatTime;
    intervalTime = trainingSet.intervalTime;
    notifyListeners();
  }

  /*
  *   トレーニング設定画面でSaveButtonをタップされた時に呼び出される
  * */
  void saveTrainingSet() {
    DbProvider.db.updateSetModels(TrainingSetModel(
      title, trainingTime, intervalTime, repeatTime, 1, "", "", "",
    ));
  }

}