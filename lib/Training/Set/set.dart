import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:planktraining/Training/Setup/content.dart';
import 'package:planktraining/Training/Setup/setup.dart';
import 'package:provider/provider.dart';

import '../../Database.dart';
import '../../main.dart';

class SetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DbProvider.db.getTrainingSetModels(),
        builder: (context, AsyncSnapshot<List<TrainingSetModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
              return _Card(
                title: snapshot.data[index].title,
                trainingTime: snapshot.data[index].trainingTime,
                intervalTime: snapshot.data[index].intervalTime,
                repeatTime: snapshot.data[index].repeatTime,
                isEnable: snapshot.data[index].isEnable,
              );
            });
          }
          return Container();
        },
    );
  }
}

class _Content extends StatelessWidget {
  _Content(this.content);
  Content content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(content.icon, color: content.color),
        SizedBox(width: 40),
        Text(content.title,
          style: TextStyle(
            fontSize: 24,
            color: Colors.black54,
          ),)
      ],
    );
  }
}

class _Card extends StatelessWidget {
  _Card({Key key, this.title, this.trainingTime, this.intervalTime, this.repeatTime, this.isEnable}) : super(key: key);

  final String title;
  final int trainingTime;
  final int intervalTime;
  final int repeatTime;
  final int isEnable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: InkWell(
          onTap: () async {
            DbProvider.db.updateSetModels(title);
            context.read<PageIndex>().changeIndex(0);
            pageController.animateToPage(0,
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          },
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.redAccent,
                height: 80,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _Content(
                            Content(TimeType.training, Icons.whatshot, Colors.red, trainingTime.toString())
                        ),
                        SizedBox(height: 8),
                        _Content(Content(TimeType.interval, Icons.free_breakfast, Colors.orangeAccent, intervalTime.toString())),
                        SizedBox(height: 8),
                        _Content(Content(TimeType.repeat, Icons.repeat, Colors.grey, repeatTime.toString())),
                      ],
                    ),
                    if(isEnable == 1) Icon(Icons.check, size: 50, color: Colors.blueAccent,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


