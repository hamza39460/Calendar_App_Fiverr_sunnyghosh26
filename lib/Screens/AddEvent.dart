import 'package:calendar_events_app/CalendarManager.dart';
import 'package:calendar_events_app/HelperMethods.dart';
import 'package:calendar_events_app/TextInputWidget.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:calendar_events_app/Extensions.dart';
import 'package:timezone/timezone.dart' as tz;

enum RecurrenceRuleEndType { Indefinite, MaxOccurrences, SpecifiedEndDate }

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  // MARK: Private Properties
  List<String> _availabilityStrings =
      Availability.values.toList().map((e) => e.enumToString).toList();
  List<String> _recurrenceTypeString =
      RecurrenceFrequency.values.toList().map((e) => e.enumToString).toList();
  String _currentAvailability = Availability.values.toList()[0].enumToString;
  List<String> _daysOfWeeks =
      DayOfWeek.values.toList().map((e) => e.enumToString).toList();
  List<String> _weekNumberString =
      WeekNumber.values.toList().map((e) => e.enumToString).toList();
  List<String> _monthsList =
      MonthOfYear.values.toList().map((e) => e.enumToString).toList();
  List<int> _monthDaysNumberList = List.generate(30, (index) => index + 1);
  List<String> _eventEndsList =
      RecurrenceRuleEndType.values.toList().map((e) => e.enumToString).toList();
  List<Calendar> _calendarsList =
      CalendarManager.sharedInstance.writableCalendars;
  String _currentReccurence =
      RecurrenceFrequency.values.toList()[0].enumToString;
  String _selectedDaysOfWeekForMonthly =
      DayOfWeek.values.toList()[0].enumToString;
  String _selectedEventEnd =
      RecurrenceRuleEndType.values.toList()[0].enumToString;
  List<bool> _selectedDaysOfWeek =
      DayOfWeek.values.toList().map((e) => false).toList();
  String _selectedWeekNumber = WeekNumber.values.toList()[0].enumToString;
  bool _byDayofMonth = false;
  int _selectedMonthDayNumber = 1;
  String _selectedMonthforYear = MonthOfYear.values.toList()[0].enumToString;
  bool _isAllDay = false;
  bool _isRecurring = false;
  Calendar? _selectedCalendar;
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now().add(Duration(hours: 1));
  DateTime _occuranceDate = DateTime.now();
  List<Attendee> _attendees = [];
  List<Reminder> _reminders = [];
  late String _title;
  String? _description;
  String? _location;
  String? url;
  String repeatEvery = "1";
  String _occurances = "1";

  GlobalKey<FormState> _formKey = GlobalKey();
  // MARK: Ovverriden Methods

  @override
  Widget build(BuildContext context) {
    _selectedCalendar ??= _calendarsList[0];
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Event",
            style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
      body: _body(),
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Calendar',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    DropdownButton<Calendar>(
                      value: _selectedCalendar,
                      onChanged: (Calendar? newValue) {
                        setState(() {
                          _selectedCalendar = newValue!;
                        });
                      },
                      items: _calendarsList
                          .map<DropdownMenuItem<Calendar>>((Calendar value) {
                        return DropdownMenuItem<Calendar>(
                          value: value,
                          child: Text(value.name ?? ""),
                        );
                      }).toList(),
                    )
                  ]),
            ),
            TextInputWidget(
                labelText: "Title",
                hintText: "Meeting with Gloria....",
                keyBoardType: TextInputType.text,
                obscureText: false,
                controller: null,
                onSaved: (value) {
                  _title = value;
                },
                validationText: "Title is required",
                textInputAction: TextInputAction.done),
            TextInputWidget(
                labelText: "Description",
                hintText: "Remember to buy flowers...",
                keyBoardType: TextInputType.text,
                obscureText: false,
                controller: null,
                onSaved: (value) {
                  _description = value;
                },
                validationText: null,
                textInputAction: TextInputAction.done),
            TextInputWidget(
                labelText: "Location",
                hintText: "Sydney, Australia",
                keyBoardType: TextInputType.text,
                obscureText: false,
                controller: null,
                onSaved: (value) {
                  _location = value;
                },
                validationText: null,
                textInputAction: TextInputAction.done),
            TextInputWidget(
                labelText: "URL",
                hintText: "https://google.com",
                keyBoardType: TextInputType.url,
                obscureText: false,
                controller: null,
                onSaved: (value) {
                  url = value;
                },
                validationText: null,
                textInputAction: TextInputAction.done),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Availability',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    DropdownButton<String>(
                      value: _currentAvailability,
                      onChanged: (String? newValue) {
                        setState(() {
                          _currentAvailability = newValue!;
                        });
                      },
                      items: _availabilityStrings
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ]),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('All Day',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Switch(
                          value: _isAllDay,
                          onChanged: (bool value) => setState(() {
                                _isAllDay = value;
                              }))
                    ])),
            Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('From',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      InkWell(
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              onConfirm: (DateTime dateTime) {
                            setState(() {
                              _fromDate = dateTime;
                            });
                          });
                        },
                        child: Text(
                          HelperMethods.formatDateTime(_fromDate),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      )
                    ])),
            Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('To',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      InkWell(
                        onTap: () {
                          DatePicker.showDateTimePicker(context,
                              onConfirm: (DateTime dateTime) {
                            setState(() {
                              _toDate = dateTime;
                            });
                          });
                        },
                        child: Text(
                          HelperMethods.formatDateTime(_toDate),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      )
                    ])),
            // Container(
            //   padding: const EdgeInsets.fromLTRB(8.0, 8, 16, 0),
            //   alignment: Alignment.centerLeft,
            //   child: TextButton.icon(
            //       onPressed: () {},
            //       icon: Icon(Icons.person_add),
            //       label: Text('Attendees',
            //           style: TextStyle(
            //               fontSize: 15,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.black))),
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(8.0, 8, 16, 0),
            //   child: ListView.builder(
            //       shrinkWrap: true,
            //       physics: NeverScrollableScrollPhysics(),
            //       itemCount: _attendees.length,
            //       itemBuilder: (context, index) {
            //         Attendee _attendee = _attendees[index];
            //         return Row(children: [
            //           Text(_attendee.emailAddress ?? "",
            //               style: TextStyle(color: Colors.blue, fontSize: 13)),
            //           Text(_attendee.role.toString(),
            //               style: TextStyle(fontSize: 12)),
            //           IconButton(
            //               onPressed: () {
            //                 setState(() {
            //                   _attendees.remove(_attendee);
            //                 });
            //               },
            //               icon: Icon(Icons.remove, color: Colors.red))
            //         ]);
            //       }),
            // ),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 16, 0),
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.alarm),
                  label: Text('Add Reminders',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 16, 0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _reminders.length,
                  itemBuilder: (context, index) {
                    Reminder reminder = _reminders[index];
                    return Row(children: [
                      Text("${reminder.minutes ?? 0} before event",
                          style: TextStyle(color: Colors.blue, fontSize: 13)),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _attendees.remove(reminder);
                            });
                          },
                          icon: Icon(Icons.remove, color: Colors.red))
                    ]);
                  }),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Is Recurring?',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Switch(
                          value: _isRecurring,
                          onChanged: (bool value) => setState(() {
                                _isRecurring = value;
                              }))
                    ])),
            !_isRecurring
                ? Container()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Select Recurrence Type',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          DropdownButton<String>(
                            value: _currentReccurence,
                            onChanged: (String? newValue) {
                              setState(() {
                                _currentReccurence = newValue!;
                              });
                            },
                            items: _recurrenceTypeString
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ]),
                  ),
            _isRecurring &&
                    _currentReccurence == RecurrenceFrequency.Daily.enumToString
                ? _dailyRecurrenceFields()
                : Container(),
            _isRecurring &&
                    _currentReccurence ==
                        RecurrenceFrequency.Weekly.enumToString
                ? _weeklyRecurrenceFields()
                : Container(),
            _isRecurring &&
                    _currentReccurence ==
                        RecurrenceFrequency.Monthly.enumToString
                ? _monthlyReccurrenceFields()
                : Container(),
            _isRecurring &&
                    _currentReccurence ==
                        RecurrenceFrequency.Yearly.enumToString
                ? _yearlyReccurrenceFields()
                : Container(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Event ends',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    DropdownButton<String>(
                      value: _selectedEventEnd,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedEventEnd = newValue!;
                        });
                      },
                      items: _eventEndsList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ]),
            ),
            _selectedEventEnd ==
                    RecurrenceRuleEndType.MaxOccurrences.enumToString
                ? _maxOccurencesFields()
                : Container(),
            _selectedEventEnd ==
                    RecurrenceRuleEndType.SpecifiedEndDate.enumToString
                ? _dateSpecifeidOccurenceFields()
                : Container(),
            Card(
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState!.save();
                      _createEvent();
                    }
                  },
                  child: Text('Add Event',
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dailyRecurrenceFields() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        TextInputWidget(
            labelText: 'Repeat Every',
            hintText: '1',
            keyBoardType: TextInputType.number,
            obscureText: false,
            controller: null,
            onSaved: (value) {
              repeatEvery = value;
            },
            validationText: null,
            textInputAction: null,
            suffix: Padding(
              padding: const EdgeInsets.only(right: 8, top: 15),
              child: Text(
                'Day(s)',
                textAlign: TextAlign.center,
              ),
            )),
      ],
    );
  }

  Widget _weeklyRecurrenceFields() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        TextInputWidget(
            labelText: 'Repeat Every',
            hintText: '1',
            keyBoardType: TextInputType.number,
            obscureText: false,
            controller: null,
            onSaved: (value) {
              repeatEvery = value;
            },
            validationText: null,
            textInputAction: null,
            suffix: Padding(
              padding: const EdgeInsets.only(right: 8, top: 15),
              child: Text('Week(s)'),
            )),
        Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
            child: Text('Repeat on',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
          child: ListView.builder(
              itemCount: _daysOfWeeks.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_daysOfWeeks[index],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Checkbox(
                        value: _selectedDaysOfWeek[index],
                        onChanged: (value) {
                          setState(() {
                            _selectedDaysOfWeek[index] = value ?? false;
                          });
                        }),
                  ],
                );
              }),
        ),
      ],
    );
  }

  Widget _monthlyReccurrenceFields() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        TextInputWidget(
            labelText: 'Repeat Every',
            hintText: '1',
            keyBoardType: TextInputType.number,
            obscureText: false,
            controller: null,
            onSaved: (value) {
              repeatEvery = value;
            },
            validationText: null,
            textInputAction: null,
            suffix: Padding(
              padding: const EdgeInsets.only(right: 8, top: 15),
              child: Text('Months(s)'),
            )),
        Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('By day of the month',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Switch(
                      value: _byDayofMonth,
                      onChanged: (bool value) => setState(() {
                            _byDayofMonth = value;
                          }))
                ])),
        !_byDayofMonth
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                child: Column(
                  children: [
                    Text('Monthly on',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          value: _selectedWeekNumber,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedWeekNumber = newValue!;
                            });
                          },
                          items: _weekNumberString
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                          value: _selectedDaysOfWeekForMonthly,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDaysOfWeekForMonthly = newValue!;
                            });
                          },
                          items: _daysOfWeeks
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Day of Month',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    DropdownButton<int>(
                      value: _selectedMonthDayNumber,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedMonthDayNumber = newValue!;
                        });
                      },
                      items: _monthDaysNumberList
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text("${value}"),
                        );
                      }).toList(),
                    )
                  ],
                ),
              )
      ],
    );
  }

  Widget _yearlyReccurrenceFields() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        TextInputWidget(
            labelText: 'Repeat Every',
            hintText: '1',
            keyBoardType: TextInputType.number,
            obscureText: false,
            controller: null,
            onSaved: (value) {
              repeatEvery = value;
            },
            validationText: null,
            textInputAction: null,
            suffix: Padding(
              padding: const EdgeInsets.only(right: 8, top: 15),
              child: Text('years(s)'),
            )),
        Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('By day of the month',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Switch(
                      value: _byDayofMonth,
                      onChanged: (bool value) => setState(() {
                            _byDayofMonth = value;
                          }))
                ])),
        !_byDayofMonth
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                child: Column(
                  children: [
                    Text('Yearly on',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          value: _selectedWeekNumber,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedWeekNumber = newValue!;
                            });
                          },
                          items: _weekNumberString
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                          value: _selectedDaysOfWeekForMonthly,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDaysOfWeekForMonthly = newValue!;
                            });
                          },
                          items: _daysOfWeeks
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                          value: _selectedMonthforYear,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedMonthforYear = newValue!;
                            });
                          },
                          items: _monthsList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Month',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        DropdownButton<String>(
                          value: _selectedMonthforYear,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedMonthforYear = newValue!;
                            });
                          },
                          items: _monthsList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                    Padding(padding: const EdgeInsets.all(8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Day of Month',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        DropdownButton<int>(
                          value: _selectedMonthDayNumber,
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedMonthDayNumber = newValue!;
                            });
                          },
                          items: _monthDaysNumberList
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text("${value}"),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ],
                ),
              )
      ],
    );
  }

  Widget _maxOccurencesFields() {
    return TextInputWidget(
        labelText: 'For the next',
        hintText: '1',
        keyBoardType: TextInputType.number,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          _occurances = value;
        },
        validationText: null,
        textInputAction: null,
        suffix: Padding(
          padding: const EdgeInsets.only(right: 8, top: 15),
          child: Text('Occurrence(s)'),
        ));
  }

  Widget _dateSpecifeidOccurenceFields() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 0),
      child: InkWell(
        onTap: () {
          DatePicker.showDateTimePicker(context,
              onConfirm: (DateTime dateTime) {
            setState(() {
              _occuranceDate = dateTime;
            });
          });
        },
        child: Text(
          HelperMethods.formatDateTime(_occuranceDate),
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
    );
  }

  _createEvent() async {
    RecurrenceRule reccurrance = RecurrenceRule(
      _currentReccurence.stringReccurrenceToEnum,
      totalOccurrences:
          _selectedEventEnd == RecurrenceRuleEndType.MaxOccurrences.enumToString
              ? int.parse(_occurances)
              : null,
      endDate: _selectedEventEnd ==
              RecurrenceRuleEndType.SpecifiedEndDate.enumToString
          ? _occuranceDate
          : null,
      interval: int.parse(repeatEvery),
      dayOfMonth: _currentReccurence == RecurrenceFrequency.Monthly.enumToString
          ? _selectedMonthDayNumber
          : null,
      daysOfWeek: _currentReccurence == RecurrenceFrequency.Weekly.enumToString
          ? _daysOfWeeks
              .where((element) =>
                  _selectedDaysOfWeek[_daysOfWeeks.indexOf(element)])
              .toList()
              .map((e) => e.stringDaysOfWeeksToEnum)
              .toList()
          : null,
      monthOfYear: _currentReccurence == RecurrenceFrequency.Yearly.enumToString
          ? _selectedMonthforYear.stringMonthOfYearToEnum
          : null,
      weekOfMonth:
          _currentReccurence == RecurrenceFrequency.Monthly.enumToString ||
                  _currentReccurence == RecurrenceFrequency.Yearly.enumToString
              ? _selectedWeekNumber.stringWeekNumberToEnum
              : null,
    );
    Event event = Event(
      _selectedCalendar?.id,
      title: _title,
      description: _description,
      availability: _currentAvailability.stringAvailabilityToEnum,
      allDay: _isAllDay,
      start: tz.TZDateTime.from(_fromDate, tz.local),
      end: tz.TZDateTime.from(_toDate, tz.local),
      attendees: _attendees,
      reminders: _reminders,
      recurrenceRule: _isRecurring ? reccurrance : null,
    );
    event.location = _location;
    event.url = Uri.parse(url ?? "");
    bool result =
        await CalendarManager.sharedInstance.addEvent(event, (String? error) {
      HelperMethods.showSnackBar(context, error ?? "Some error occured");
    });
    if (result) {
      HelperMethods.showSnackBar(context, "Event added Successfully");
    }
  }
}
