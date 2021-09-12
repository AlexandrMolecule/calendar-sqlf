import 'package:calendaer_test_app/calendar/create_task_screen.dart';
import 'package:calendaer_test_app/local_db/local_db.dart';
import 'package:flutter/material.dart';

import 'calendar_logic.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  final DatabaseSql db = DatabaseSql();

  late DateTime _dateTime;
  int _daysBefore = 0;
  int _daysAfter = 0;
  @override
  void initState() {
    _dateTime = DateTime.now();
    setDaysBefore();
    setDaysAfter();
    super.initState();
  }

  void setDaysBefore() {
    _daysBefore = DateTime(_dateTime.year, _dateTime.month, 1).weekday;
    _daysBefore == 7 ? _daysBefore = 0 : _daysBefore = _daysBefore;
    print(_daysBefore.toString());
  }

  void setDaysAfter() {
    final lastDay = getNumberOfDaysInMonth(_dateTime.month);
    print(lastDay.toString());
    final _weekday = DateTime(_dateTime.year, _dateTime.month, lastDay).weekday;
    if (_weekday == 7) {
      _daysAfter = _weekday - 1;
    } else {
      _daysAfter = 6 - _weekday;
    }
    print(_daysAfter.toString());
    _daysAfter == 6 ? _daysAfter = 0 : _daysAfter = _daysAfter;
  }

  void _goToToday() {
    print("trying to go to the month of today");
    setState(() {
      _dateTime = DateTime.now();

      setDaysBefore();
      setDaysAfter();
    });
  }

  void _previousMonthSelected() {
    setState(() {
      if (_dateTime.month == DateTime.january)
        _dateTime = DateTime(_dateTime.year - 1, DateTime.december);
      else
        _dateTime = DateTime(_dateTime.year, _dateTime.month - 1);

      setDaysBefore();
      setDaysAfter();
    });
  }

  void _nextMonthSelected() {
    setState(() {
      if (_dateTime.month == DateTime.december)
        _dateTime = DateTime(_dateTime.year + 1, DateTime.january);
      else
        _dateTime = DateTime(_dateTime.year, _dateTime.month + 1);

      setDaysBefore();
      setDaysAfter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final int numWeekDays = 7;
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height -
            kToolbarHeight -
            kBottomNavigationBarHeight -
            24 -
            28 -
            55) /
        6;
    final double itemWidth = size.width / numWeekDays;
    final _styleH5 = Theme.of(context).textTheme.headline5;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.accessible_outlined),
            onPressed: _goToToday,
          ),
          title: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                getMonthName(_dateTime.month) + " " + _dateTime.year.toString(),
              )),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                onPressed: _previousMonthSelected),
            IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
                onPressed: _nextMonthSelected),
          ],
        ),
        body: Column(children: [
          Row(
            children: [
              Expanded(
                  child:
                      Text('Su', textAlign: TextAlign.center, style: _styleH5)),
              Expanded(
                  child:
                      Text('Mo', textAlign: TextAlign.center, style: _styleH5)),
              Expanded(
                  child:
                      Text('Tu', textAlign: TextAlign.center, style: _styleH5)),
              Expanded(
                  child:
                      Text('We', textAlign: TextAlign.center, style: _styleH5)),
              Expanded(
                  child:
                      Text('Th', textAlign: TextAlign.center, style: _styleH5)),
              Expanded(
                  child:
                      Text('Fr', textAlign: TextAlign.center, style: _styleH5)),
              Expanded(
                  child:
                      Text('Sa', textAlign: TextAlign.center, style: _styleH5)),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          GridView.count(
            crossAxisCount: numWeekDays,
            childAspectRatio: (itemWidth / itemHeight),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
                getNumberOfDaysInMonth(_dateTime.month) +
                    _daysBefore +
                    _daysAfter, (index) {
              int dayNumber = index + 1;
              return GestureDetector(
                  onTap: () {
                    if (dayNumber <= _daysBefore ||
                        dayNumber - _daysBefore >
                            getNumberOfDaysInMonth(_dateTime.month)) {
                      print('false');
                    } else {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => CreateTask(
                              date: DateTime(_dateTime.year, _dateTime.month,
                                  dayNumber - _daysBefore))));
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.all(2.0),
                      padding: const EdgeInsets.all(1.0),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Column(
                        children: [
                          buildDayNumberWidget(dayNumber, index, context),
                          FutureBuilder<int?>(
                              future: db.countOfRows(DateTime(_dateTime.year,
                                      _dateTime.month, dayNumber - _daysBefore)
                                  .toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data != null) {
                                    print(snapshot.data);
                                    return Container(
                                      width: 30,
                                      height: 30,
                                      color: Colors.green,
                                      child: Center(
                                          child: Text('${snapshot.data}')),
                                    );
                                  } else
                                    Container();
                                }
                                return Container();
                              })
                        ],
                      )));
            }),
          )
        ]));
  }

  Container buildDayNumberWidget(int dayNumber, index, BuildContext context) {
    if ((dayNumber - _daysBefore) == DateTime.now().day &&
        _dateTime.month == DateTime.now().month &&
        _dateTime.year == DateTime.now().year) {
      // текущая дата
      return Container(
        width: 35.0,
        height: 35.0,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange,
          border: Border.all(),
        ),
        child: Text(
          (dayNumber - _daysBefore).toString(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      );
    } else {
      // не текущая дата
      return Container(
        width: 35.0,
        height: 35.0,
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        //способ отображения дней дргуих месяцев, не лучший, но рабочий
        child: dayNumber <= _daysBefore
            ? _dateTime.month == 1
                ? Text(
                    '${getNumberOfDaysInMonth(12) - _daysBefore + dayNumber}',
                  )
                : Text(
                    '${getNumberOfDaysInMonth(_dateTime.month - 1) - _daysBefore + dayNumber}')
            : dayNumber - _daysBefore > getNumberOfDaysInMonth(_dateTime.month)
                ? Text(
                    '${-(getNumberOfDaysInMonth(_dateTime.month) - (dayNumber - _daysBefore))}')
                : Text(
                    (dayNumber - _daysBefore).toString(),
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
      );
    }
  }
}
