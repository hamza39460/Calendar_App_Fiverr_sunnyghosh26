import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:intl/intl.dart';

class DateTimeLineScreen extends StatefulWidget {
  @override
  _DateTimeLineScreenState createState() => _DateTimeLineScreenState();
}

class _DateTimeLineScreenState extends State<DateTimeLineScreen> {
  // MARK: Private Properties
  DateTime _selectedDate = DateTime.now();
  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  List<Calendar> _calendars = [];
  List<Event> _calendarEvents = [];
  List<Calendar> get _readOnlyCalendars =>
      _calendars.where((c) => c.isReadOnly == true).toList();
  List<Calendar> get _writableCalendars =>
      _calendars.where((c) => c.isReadOnly == false).toList();
  ValueNotifier _eventsFetched = ValueNotifier(false);
  // MARK: Initializer
  @override
  void initState() {
    _retrieveCalendars();
    super.initState();
  }

  // MARK: Build Functions
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _body2()));
  }

  // MARK: Private Widgets
  Widget _body2() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [_calendarCrousal, _eventsList],
    );
  }

  Widget get _calendarCrousal => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        child: CalendarCarousel(
          onDayPressed: (DateTime date, List<Event> events) async {
            setState(() => _selectedDate = date);
            _fetchEvents();
          },
          weekendTextStyle: TextStyle(
            color: Colors.red,
          ),
          selectedDateTime: _selectedDate,
          thisMonthDayBorderColor: Colors.grey,
        ),
      );

  Widget get _eventsList => ValueListenableBuilder(
      valueListenable: _eventsFetched,
      builder: (context, isEventFetched, child) => isEventFetched == false
          ? Container()
          : _calendarEvents.length == 0
              ? Center(
                  child: Text(
                    "No Events Found",
                    style: TextStyle(fontSize: 14),
                  ),
                )
              : ListView.builder(
                  itemCount: _calendarEvents.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    Event event = _calendarEvents[index];
                    String startDate = _formatDateTime(
                        DateTime.parse(event.start!.toIso8601String()));
                    String? endDate;
                    if (event.end != null) {
                      endDate = _formatDateTime(
                          DateTime.parse(event.end!.toIso8601String()));
                    } else {
                      endDate = null;
                    }
                    return Card(
                      color: Colors.blueAccent,
                      child: ListTile(
                        title: Text(event.title ?? "",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        subtitle: Text(
                            "Start: ${startDate}\nEnd: ${endDate ?? ""}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        isThreeLine: true,
                      ),
                    );
                  },
                ));

  // MARK: Private Methods
  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null ||
              permissionsGranted.data == false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            permissionsGranted.data == false) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      _calendars = calendarsResult.data as List<Calendar>;
      _fetchEvents();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future _retrieveCalendarEvents(
      String? forCalendarID, DateTime startDate) async {
    var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
        forCalendarID,
        RetrieveEventsParams(
            startDate: startDate, endDate: startDate.add(Duration(days: 1))));
    _calendarEvents.addAll(calendarEventsResult.data!.toList());
  }

  void _fetchEvents() async {
    _calendarEvents.clear();
    _eventsFetched.value = false;
    for (Calendar calendar in _calendars) {
      await _retrieveCalendarEvents(calendar.id, _selectedDate);
    }
    _eventsFetched.value = true;
  }

  String _formatDateTime(DateTime dateTime) {
    DateFormat dateFormat = DateFormat("MMM dd, yyyy HH:mm:ss");
    return dateFormat.format(dateTime);
  }
}
