import 'package:calendar_events_app/CalendarManager.dart';
import 'package:calendar_events_app/HelperMethods.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

import '../AppRoutes.dart';

class EventDetailScreen extends StatelessWidget {
  // MARK: Private Properties
  Event _event;

  // MARK: Initializers
  EventDetailScreen(this._event);

  // MARK: Overridden Methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(_event.title ?? "",
            style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
      body: _body(context),
    );
  }

  // MARK: Private Widgets
  Widget _body(BuildContext context) {
    String? startDate;
    String? endDate;
    String allDay = "No";
    if (_event.allDay != null) {
      allDay = _event.allDay! ? "Yes" : "No";
    }
    if (_event.start != null) {
      startDate = HelperMethods.formatDateTime(
          DateTime.parse(_event.start!.toIso8601String()));
    }
    if (_event.end != null) {
      endDate = HelperMethods.formatDateTime(
          DateTime.parse(_event.end!.toIso8601String()));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.all(8)),
              Text(_event.title ?? "", style: TextStyle(fontSize: 24)),
              Padding(padding: const EdgeInsets.all(8)),
              Text("Starts at: $startDate", style: TextStyle(fontSize: 14)),
              Padding(padding: const EdgeInsets.all(8)),
              Text("Ends at: $endDate", style: TextStyle(fontSize: 14)),
              Padding(padding: const EdgeInsets.all(8)),
              Text("All Day: $allDay", style: TextStyle(fontSize: 14)),
              Padding(padding: const EdgeInsets.all(8)),
              Text("Location: ${_event.location ?? "N/A"}",
                  style: TextStyle(fontSize: 14)),
              Padding(padding: const EdgeInsets.all(8)),
              Text("URL: ${_event.url ?? "N/A"}",
                  style: TextStyle(fontSize: 14, color: Colors.blue)),
              Padding(padding: const EdgeInsets.all(8)),
              // Row(
              //   children: [
              //     Text("Attendees: ", style: TextStyle(fontSize: 14)),
              //     Container(
              //       width: MediaQuery.of(context).size.width * 0.50,
              //       child: (_event.attendees?.length ?? 0) == 0
              //           ? Text('N/A', style: TextStyle(fontSize: 14))
              //           : ListView.builder(
              //               shrinkWrap: true,
              //               itemCount: _event.attendees?.length ?? 0,
              //               itemBuilder: (context, index) {
              //                 return Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Text(
              //                       "${_event.attendees?[index]?.emailAddress ?? ""}",
              //                       style: TextStyle(fontSize: 14)),
              //                 );
              //               },
              //             ),
              //     )
              //   ],
              // ),
              Padding(padding: const EdgeInsets.all(8)),
              Text("Availability: ${_event.availability.enumToString}",
                  style: TextStyle(fontSize: 14)),
              Padding(padding: const EdgeInsets.all(8)),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextButton(
                          onPressed: () async {
                            bool result = await CalendarManager.sharedInstance
                                .deleteEvent(_event.calendarId, _event.eventId);
                            if (result) {
                              HelperMethods.showSnackBar(
                                  context, 'Event Deleted');
                            } else {
                              HelperMethods.showSnackBar(
                                  context, 'Cannot Delete the event.');
                            }
                          },
                          child: Text('Delete',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextButton(
                          onPressed: () => print("Edit"),
                          child: Text('Edit',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
