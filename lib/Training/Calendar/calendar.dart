import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:planktraining/Common/text.dart';
import 'package:planktraining/admob/ad_manager.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Database.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events = Map();
  List _selectedEvents;
  bool _isSelected = false;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected  day $day events $events');
    _isSelected = true;
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated events $_selectedEvents');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DbProvider.db.getTrainingModels(),
        builder: (context, AsyncSnapshot<List<TrainingModel>> snapshot) {
          if (snapshot.hasData) {
            _events.clear();
            snapshot.data.forEach((element) {
              final time = DateTime.parse(element.date.split(" ").first);
              //イベントのDatetimeが入ってた場合
              if (_events.containsKey(time)) {
                _events[time].add(element);
              } else {
                _events.putIfAbsent(time, () => [element]);
              }
            });
            //一度も日付が選択されていない場合
            if (!_isSelected) {
              final _selectedDay =
                  DateTime.parse(DateTime.now().toString().split(" ").first);
              _selectedEvents = _events[_selectedDay] ?? [];
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                AdmobBanner(
                  adUnitId: AdMobService().getBannerAdUnitId(),
                  adSize: AdmobBannerSize(
                    width: MediaQuery.of(context).size.width.toInt(),
                    height: AdMobService().getHeight(context).toInt(),
                  ),
                ),
                _buildTableCalendar(),
                Expanded(child: _buildEventList()),
              ],
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return CircularProgressIndicator();
        });
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.red,
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8, color: Colors.grey[700]),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  leading: BoldText((event as TrainingModel).title, 18),
                  title: Row(
                    children: [
                      SizedBox(width: 16),
                      Icon(Icons.whatshot, color: Colors.red, size: 20),
                      Text(
                        (event as TrainingModel).trainingTime.toString(),
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.free_breakfast,
                          color: Colors.orangeAccent, size: 20),
                      Text(
                        (event as TrainingModel).intervalTime.toString(),
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.repeat, color: Colors.grey, size: 20),
                      Text(
                        (event as TrainingModel).repeatTime.toString(),
                        style: TextStyle(color: Colors.black54, fontSize: 18),
                      ),
                    ],
                  ),
                  onTap: null,
                ),
              ))
          .toList(),
    );
  }
}
