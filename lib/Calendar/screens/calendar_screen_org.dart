import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:brave_app/src/components/drawer_component.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  final Map<DateTime, List<CleanCalendarEvent>> _events = {
    DateTime(2021, 7, 3): [
      CleanCalendarEvent(
        'Zona 2 Fuerza',
        startTime: DateTime(2021, 7, 3, 6, 20),
        endTime: DateTime(2021, 7, 7, 7, 20),
        color: Colors.pink,
      ),
      CleanCalendarEvent(
        'Cita Nutrición',
        startTime: DateTime(2021, 7, 3, 18, 30),
        endTime: DateTime(2021, 7, 3, 19, 30),
        color: Colors.lightBlue,
        description: 'Cita de control 1',
      ),
    ],
    DateTime(2021, 7, 6): [
      CleanCalendarEvent(
        'Zona 1 Resistencia',
        startTime: DateTime(2021, 7, 6, 10, 40),
        endTime: DateTime(2021, 7, 6, 11, 40),
        color: Colors.orange,
      ),
    ],
    DateTime(2021, 6, 29): [
      CleanCalendarEvent(
        'Zona 3 Ejercicio funcional',
        startTime: DateTime(2021, 6, 29, 10, 40),
        endTime: DateTime(2021, 6, 29, 11, 40),
        color: Colors.green,
      ),
    ],
    DateTime(2021, 6, 30): [
      CleanCalendarEvent(
        'Zona 4 Boxeo y MMA',
        startTime: DateTime(2021, 6, 29, 17, 20),
        endTime: DateTime(2021, 6, 29, 18, 20),
        color: Colors.red,
      ),
    ],
    DateTime(2021, 7, 1): [
      CleanCalendarEvent(
        'Zona 5 Fuerza del core TRX',
        startTime: DateTime(2021, 7, 1, 17, 20),
        endTime: DateTime(2021, 7, 1, 18, 20),
        color: Colors.purple,
      ),
    ],
    DateTime(2021, 7, 2): [
      CleanCalendarEvent(
        'Zona 2 Fuerza',
        startTime: DateTime(2021, 7, 2, 17, 20),
        endTime: DateTime(2021, 7, 2, 18, 20),
        color: Colors.pink,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
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
          Navigator.of(context).pushNamed('/reservation_screen');
        },
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }
}
