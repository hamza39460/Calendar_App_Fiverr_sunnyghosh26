import 'package:calendar_events_app/AppRoutes.dart';
import 'package:calendar_events_app/HelperMethods.dart';
import 'package:calendar_events_app/Screens/AddEvent.dart';
import 'package:calendar_events_app/Screens/EventDetailScreen.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../CalendarManager.dart';

class DateTimeLineScreen extends StatefulWidget {
  @override
  _DateTimeLineScreenState createState() => _DateTimeLineScreenState();
}

class _DateTimeLineScreenState extends State<DateTimeLineScreen> {
  // MARK: Private Properties
  DateTime _selectedDate = DateTime.now();
  // MARK: Initializer
  @override
  void initState() {
    CalendarManager.sharedInstance.retrieveCalendars();
    super.initState();
  }

  // MARK: Build Functions
  @override
  Widget build(BuildContext context) {
    CalendarManager.sharedInstance.fetchEvents(_selectedDate);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppRoutes.pushWithThen(context, AddEvent(), () {
              CalendarManager.sharedInstance.fetchEvents(_selectedDate);
            });
          },
          child: Icon(Icons.add),
        ),
        body: SafeArea(child: _body2()));
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
          },
          weekendTextStyle: TextStyle(
            color: Colors.red,
          ),
          selectedDateTime: _selectedDate,
          thisMonthDayBorderColor: Colors.grey,
        ),
      );

  Widget get _eventsList => ValueListenableBuilder(
      valueListenable: CalendarManager.sharedInstance.eventsFetched,
      builder: (context, isEventFetched, child) => isEventFetched == false
          ? Container()
          : CalendarManager.sharedInstance.calendarEvents.length == 0
              ? Center(
                  child: Text(
                    "No Events Found",
                    style: TextStyle(fontSize: 14),
                  ),
                )
              : ListView.builder(
                  itemCount:
                      CalendarManager.sharedInstance.calendarEvents.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    Event event =
                        CalendarManager.sharedInstance.calendarEvents[index];
                    String startDate = HelperMethods.formatDateTime(
                        DateTime.parse(event.start!.toIso8601String()));
                    String? endDate;
                    if (event.end != null) {
                      endDate = HelperMethods.formatDateTime(
                          DateTime.parse(event.end!.toIso8601String()));
                    } else {
                      endDate = null;
                    }
                    return InkWell(
                      onTap: () => AppRoutes.pushWithThen(
                          context, EventDetailScreen(event), () {
                        CalendarManager.sharedInstance
                            .fetchEvents(_selectedDate);
                      }),
                      child: Card(
                        color: Colors.blueAccent,
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: [
                            IconSlideAction(
                              caption: 'Edit',
                              color: Colors.indigo,
                              icon: Icons.edit,
                              onTap: () => print('Edit'),
                            ),
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async {
                                bool result = await CalendarManager
                                    .sharedInstance
                                    .deleteEvent(
                                        event.calendarId, event.eventId);
                                if (result) {
                                  HelperMethods.showSnackBar(
                                      context, 'Event Deleted');
                                  CalendarManager.sharedInstance
                                      .fetchEvents(_selectedDate);
                                } else {
                                  HelperMethods.showSnackBar(
                                      context, 'Cannot Delete the event.');
                                }
                                setState(() {});
                              },
                            ),
                          ],
                          child: ListTile(
                            title: Text(event.title ?? "",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            subtitle: Text(
                                "Start: ${startDate}\nEnd: ${endDate ?? ""}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            isThreeLine: true,
                          ),
                        ),
                      ),
                    );
                  },
                ));

  // MARK: Private Methods

}
