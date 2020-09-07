import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:planktraining/Common/text.dart';
import 'package:provider/provider.dart';
import '../../Database.dart';
import 'setup.dart';
import 'setupProvider.dart';

class Content {
  Content(this.type, this.icon, this.color, this.title);

  final TimeType type;
  final IconData icon;
  final Color color;
  final String title;
}

class InputTime extends StatelessWidget {
  InputTime(this.content, this.model);

  final Content content;
  final TrainingSetModel model;

  void setValue(SetupProvider setupProvider, int value) {
    switch (content.type) {
      case TimeType.training:
        return setupProvider.changeTraining(value);
        break;
      case TimeType.interval:
        setupProvider.changeIntervalTime(value);
        break;
      case TimeType.repeat:
        setupProvider.changeRepeatTime(value);
        break;
    }
  }

  int getValue() {
    switch (content.type) {
      case TimeType.training:
        return model.trainingTime;
        break;
      case TimeType.interval:
        return model.intervalTime;
        break;
      case TimeType.repeat:
        return model.repeatTime;
        break;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(content.icon, color: content.color, size: 40),
            BoldText(content.title, 24),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 64,
          width: double.infinity,
          child: OutlineButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                BoldText(getValue().toString(), 40),
                SizedBox(width: 4),
                BoldText(content.type == TimeType.repeat ? "回" : "秒", 24),
              ],
            ),
            color: Color.fromRGBO(244, 143, 177, 1),
            onPressed: () => showMaterialNumberPicker(
                context: context,
                title: "",
                maxNumber: 100,
                minNumber: 0,
                selectedNumber: getValue(),
                onChanged: (value) => setValue(context.read<SetupProvider>(), value)),
          ),
        )
      ],
    );
  }
}
