import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Config/constants.dart';
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
  bool loading = true;
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
      loading = false;
      setState(() {
        setContent();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendario')),
      body: SafeArea(child: setContent()),
      drawer: DrawerComponent(),
      bottomNavigationBar: BottomBarComponent(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Reserva', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.of(context).pushNamed('/reservation_screen');
        },
        backgroundColor: kBgColors['appSecondary'],
      ),
    );
  }

  Widget setContent() {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return calendar();
    }
  }

  Widget calendar() {
    return Calendar(
      startOnMonday: true,
      weekDays: ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'],
      events: mapEvents,
      isExpandable: true,
      eventDoneColor: Colors.green,
      selectedColor: kBgColors['appSecondary'],
      todayColor: kBgColors['appSecondary'],
      eventColor: Colors.white,
      locale: 'es_ES',
      todayButtonText: 'Hoy',
      isExpanded: true,
      expandableDateFormat: 'EEEE, dd. MMMM yyyy',
      dayOfWeekStyle: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w800,
        fontSize: 15,
      ),
      onEventSelected: _displayEvent,
    );
  }

  void _displayEvent(event) {
    String _eventId = event.location;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventScreen(_eventId),
      ),
    );
  }
}
