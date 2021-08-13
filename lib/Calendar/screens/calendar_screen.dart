import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:brave_app/src/components/drawer_component.dart';
import 'package:brave_app/Calendar/models/event_model.dart';

import 'event_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  String userId = UserSimplePreferences.getUserId();
  EventModel eventModel = EventModel();

  Future<Map<DateTime, List<CleanCalendarEvent>>> futureEvents;
  Map<DateTime, List<CleanCalendarEvent>> mapEvents = {};

  @override
  void initState() {
    super.initState();
    futureEvents = eventModel.getEvents(userId);

    futureEvents.then((response) {
      mapEvents = response;
      setState(() {});
    });

    /*_handleNewDate(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
      ),
      body: SafeArea(
        child: Calendar(
          startOnMonday: true,
          weekDays: ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'],
          events: mapEvents,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.purple[600],
          todayColor: Colors.green[800],
          eventColor: Colors.green,
          locale: 'es_ES',
          todayButtonText: 'Hoy',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          dayOfWeekStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
          onEventSelected: _displayEvent,
        ),
      ),
      drawer: DrawerComponent(),
      bottomNavigationBar: BottomBarComponent(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Reserva', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.of(context).pushNamed('/reservation_screen');
        },
        backgroundColor: Colors.purple,
      ),
    );
  }

  /*void _handleNewDate(date) {
    print('Date selected: $date');
  }*/

  void _displayEvent(event) {
    String _eventId = event.location;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventScreen(_eventId),
      ),
    );
  }
}
