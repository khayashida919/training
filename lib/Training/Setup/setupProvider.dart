
import 'package:flutter/material.dart';
import 'package:planktraining/Database.dart';

class SetupProvider with ChangeNotifier {

  String title = "";
  int trainingTime = 1;
  int intervalTime = 1;
  int repeatTime = 1;

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

  Future<TrainingSetModel> selectedTrainingSet() async {
    List<TrainingSetModel> trainingSets = await DbProvider.db.getTrainingSetModels();
    if (trainingSets.isEmpty) {
      return null;
    }
    TrainingSetModel trainingSet = trainingSets.firstWhere((element) => element.isEnable == 1);
    return trainingSet;
  }

}