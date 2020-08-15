import 'package:flutter/material.dart';
import 'package:planktraining/Common/text.dart';
import 'package:planktraining/Database.dart';
import 'package:planktraining/Training/Training/training.dart';
import 'package:planktraining/Training/Setup/setupProvider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'content.dart';

enum TimeType {
  training,
  interval,
  repeat,
}

class SetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SetupProvider(),
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Consumer<SetupProvider>(
              builder: (context, setupProvider, child) {
                return FutureBuilder(
                  future: setupProvider.selectedTrainingSet(),
                  builder: (context, AsyncSnapshot<TrainingSetModel> snapshot) {
                    if (snapshot.data == null) {
                      return _Body(TrainingSetModel(
                        setupProvider.title,
                        setupProvider.trainingTime,
                        setupProvider.intervalTime,
                        setupProvider.repeatTime,
                        1, "", "", "",
                      ));
                    } else {
                      return _Body(snapshot.data);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  _Body(this.model);

  TrainingSetModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        BoldText("さあ、トレーニングを始めましょう", 32),
        SizedBox(height: 20),
        _InputTitle(model.title),
        SizedBox(height: 20),
        InputTime(
            Content(TimeType.training, Icons.whatshot, Colors.red, "筋トレタイム"),
            model),
        SizedBox(height: 40),
        InputTime(
            Content(TimeType.interval, Icons.free_breakfast,
                Colors.orangeAccent, "休憩時間"),
            model),
        SizedBox(height: 40),
        InputTime(Content(TimeType.repeat, Icons.repeat, Colors.grey, "繰り返し回数"),
            model),
        SizedBox(height: 20),
        _saveButton(),
        SizedBox(height: 40),
        SizedBox(
          height: 80,
          width: double.infinity,
          child: RaisedButton(
            color: Colors.redAccent,
            child: Text(
              "開始",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              final setupProvider = context.read<SetupProvider>();
              final result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return TrainingScreen(
                    setupProvider.title,
                    setupProvider.trainingTime,
                    setupProvider.intervalTime,
                    setupProvider.repeatTime);
              }));
              if (result && result != null) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("カレンダーへ登録しました！"),
                ));
              }
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class _InputTitle extends StatelessWidget {
  _InputTitle(String title);

  String title;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      maxLengthEnforced: false,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black54,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      decoration: InputDecoration(
        icon: Icon(Icons.mode_edit),
        hintText: 'タイトルを入力してください',
        labelText: 'トレーニング名',
      ),
      onChanged: (text) {
//        context.read<SetupProvider>().title = text;
      },
    );
  }
}

class _saveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        OutlineButton(
            child: Text(
              "保存",
              style: TextStyle(color: Colors.blueAccent),
            ),
            onPressed: () async {
              final setupProvider = context.read<SetupProvider>();
              final database = await DbProvider.db.database;
              await database.insert(
                  DbProvider.db.trainingSetTableName,
                  TrainingSetModel(
                    setupProvider.title,
                    setupProvider.trainingTime,
                    setupProvider.intervalTime,
                    setupProvider.repeatTime,
                    1,
                    "",
                    "",
                    "",
                  ).toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("セットを保存しました"),
              ));
            }),
      ],
    );
  }
}
