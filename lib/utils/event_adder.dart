import 'package:flutter/material.dart';
import 'package:flutter_app/calendar_model.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/utils/database_helper.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BreakAdder extends StatefulWidget {
  final String eventName;

  BreakAdder(this.eventName);

  @override
  _BreakAdderState createState() => _BreakAdderState();
}

class _BreakAdderState extends State<BreakAdder> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  DateTime _selectedDay = DateTime.now();

  Map<DateTime, List<CalendarItem>> _events = {};
  List<CalendarItem> _data = [];

  List<dynamic> _selectedEvents = [];

  TimeOfDay _startTime = TimeOfDay(hour: 08, minute: 00);
  TimeOfDay _endTime = TimeOfDay(hour: 09, minute: 00);
  String _errorMsg = "";
  String _name = "";

  static List times = [
    TimeOfDay(hour: 06, minute: 00),
    TimeOfDay(hour: 07, minute: 00),
    TimeOfDay(hour: 08, minute: 00),
    TimeOfDay(hour: 09, minute: 00),
    TimeOfDay(hour: 10, minute: 00),
    TimeOfDay(hour: 11, minute: 00),
    TimeOfDay(hour: 12, minute: 00),
    TimeOfDay(hour: 13, minute: 00),
    TimeOfDay(hour: 14, minute: 00),
    TimeOfDay(hour: 15, minute: 00),
    TimeOfDay(hour: 16, minute: 00),
    TimeOfDay(hour: 17, minute: 00),
    TimeOfDay(hour: 18, minute: 00),
    TimeOfDay(hour: 19, minute: 00),
    TimeOfDay(hour: 20, minute: 00),
    TimeOfDay(hour: 21, minute: 00),
    TimeOfDay(hour: 22, minute: 00),
    TimeOfDay(hour: 23, minute: 00),
    TimeOfDay(hour: 00, minute: 00),
    TimeOfDay(hour: 01, minute: 00),
    TimeOfDay(hour: 02, minute: 00),
    TimeOfDay(hour: 03, minute: 00),
    TimeOfDay(hour: 04, minute: 00),
    TimeOfDay(hour: 05, minute: 00),
  ];

  static List<DropdownMenuItem> _dropDownTime(BuildContext context) {
    List<DropdownMenuItem> result = [];
    for (int i = 0; i < times.length; i ++) {
      TimeOfDay t = times[i];
      for (int j = 0; j < 4; j++) {
        result.add(DropdownMenuItem(
          value: TimeOfDay(hour: t.hour, minute: (15 * j)),
          child: Text(TimeOfDay(hour: t.hour, minute: (15*j)).format(context))
        ));
      }
    }
    return result;
  }


  void _addEvent(DateTime date, String event, String startTime, String endTime) async{
    CalendarItem item = CalendarItem(
        date: _selectedDay.toString(),
        name: event,
        startTime: startTime,
        endTime: endTime
    );
    await databaseHelper.database;
    await databaseHelper.insert(CalendarItem.table, item);
    _selectedEvents.add(item);
    _fetchEvents();

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
  }

  void _fetchEvents() async{
    _events = {};
    await databaseHelper.database;
    List<Map<String, dynamic>> _results = await databaseHelper.query(CalendarItem.table);
    _data = _results.map((item) => CalendarItem.fromMap(item)).toList();
    _data.forEach((element) {
      DateTime formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(element.date.toString())));
      if(_events.containsKey(formattedDate)){
        _events[formattedDate].add(element);
      }
      else{
        _events[formattedDate] = [element];
      }
    }
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _name = widget.eventName;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                SizedBox(height: 16.0),
                Text("Add Break", style: GoogleFonts.montserrat(
                    color: Color.fromRGBO(59, 57, 60, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Text("Break: " + _name),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: DropdownButton(
                        hint: Text("Select Start Time: "),
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 36,
                        isExpanded: true,
                        value: _startTime,
                        onChanged: (val) {
                          setState(() {
                            _startTime = val;
                          });
                        },
                        items: _dropDownTime(context)
                    )
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: DropdownButton(
                        hint: Text("Select End Time: "),
                        icon: Icon(Icons.arrow_drop_down_circle),
                        iconSize: 36,
                        isExpanded: true,
                        value: _endTime,
                        onChanged: (val) {
                          setState(() {
                            _endTime = val;
                            _errorMsg = "";
                          });
                          if ((_endTime.hour == _startTime.hour && _endTime.minute < _startTime.minute) ||
                              (_endTime.hour < _startTime.hour)) {
                            setState(() {
                              _endTime = TimeOfDay(
                                  hour: _startTime.hour + 1, minute: 00);
                              _errorMsg =
                              "Invalid start time, please choose again";
                            });
                          }
                        },
                        items: _dropDownTime(context))
                ),
                Container(
                  // padding: EdgeInsets.all(5),
                    child: Text(
                      _errorMsg,
                      style: GoogleFonts.montserrat(
                        color: Colors.red,
                        fontSize: 10,
                      ),)
                ),
                Container(
                    child: TextButton(
                      child: Text('Select Date'),
                      onPressed: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(DateTime.now().year + 1),
                          theme: DatePickerTheme(
                              headerColor: Colors.orange,
                              backgroundColor: Colors.blue,
                              itemStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),
                          onChanged: (date) {
                            setState(() {
                              _selectedDay = date;
                            });
                          },
                        );
                      },
                    )
                ),
                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextButton(
                        child: Text('Save',
                            style: GoogleFonts.montserrat(
                                color: Color.fromRGBO(59, 57, 60, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        onPressed: () => {
                          _addEvent(_selectedDay, _name, _startTime.toString(), _endTime.toString())
                        },
                      ),
                      TextButton(
                          child: Text('Cancel',
                              style: GoogleFonts.montserrat(
                                  color: Color.fromRGBO(59, 57, 60, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () { return Navigator.of(context).pop(true); }
                      )
                    ]
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
