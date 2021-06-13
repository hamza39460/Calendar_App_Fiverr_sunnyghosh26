import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalendarManager {
  static CalendarManager sharedInstance = CalendarManager();
  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  List<Calendar> _calendars = [];
  List<Event> calendarEvents = [];
  List<Calendar> get _readOnlyCalendars =>
      _calendars.where((c) => c.isReadOnly == true).toList();
  List<Calendar> get writableCalendars =>
      _calendars.where((c) => c.isReadOnly == false).toList();
  ValueNotifier eventsFetched = ValueNotifier(false);

  void retrieveCalendars() async {
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
      print("write ${writableCalendars.length}");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future retrieveCalendarEvents(
      String? forCalendarID, DateTime startDate) async {
    var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
        forCalendarID,
        RetrieveEventsParams(
            startDate: startDate, endDate: startDate.add(Duration(days: 1))));
    calendarEvents.addAll(calendarEventsResult.data!.toList());
  }

  void fetchEvents(DateTime _selectedDate) async {
    calendarEvents.clear();
    eventsFetched.value = false;
    for (Calendar calendar in _calendars) {
      await retrieveCalendarEvents(calendar.id, _selectedDate);
    }
    eventsFetched.value = true;
  }

  Future<bool> deleteEvent(String? calendarID, String? eventID) async {
    Result result =
        await _deviceCalendarPlugin.deleteEvent(calendarID, eventID);
    return result.isSuccess;
  }

  Future<bool> addEvent(Event event, Function(String?)? onCompletion) async {
    try {
      Result<String>? result =
          await _deviceCalendarPlugin.createOrUpdateEvent(event);

      if (result?.hasErrors ?? false) {
        onCompletion!(result?.errors.join(","));
        return false;
      } else {
        return true;
      }
    } catch (e) {
      onCompletion!("Some Error Occured");
      return false;
    }
  }
}
