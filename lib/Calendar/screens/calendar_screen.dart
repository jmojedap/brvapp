import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:brave_app/src/components/drawer_component.dart';
import 'package:brave_app/Calendar/models/event_model.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<CleanCalendarEvent>> _events = {};

  EventModel eventModel = EventModel();
  List mapEvents = [];

  @override
  void initState() {
    super.initState();
    _events = eventModel.getEvents();

    _handleNewDate(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
      ),
      body: SafeArea(
        child: Calendar(
          startOnMonday: false,
          weekDays: ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa', 'Do'],
          events: _events,
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
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
        ),
      ),
      drawer: DrawerComponent(),
      bottomNavigationBar: BottomBarComponent(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Reserva', style: TextStyle(color: Colors.white)),
        onPressed: () {
          _getEvents();
          //Navigator.of(context).pushNamed('/reservation_screen');
        },
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }

  void _getEvents() {
    _events = eventModel.getEvents();
    print('Cargando eventos');
    setState(() {});
  }
}
