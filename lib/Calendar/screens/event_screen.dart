import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:flutter/material.dart';
import 'package:brave_app/Calendar/models/event_model.dart';
import 'package:brave_app/Calendar/models/calendar_tools.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  final String eventId;
  EventScreen(this.eventId);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String userId = UserSimplePreferences.getUserId();
  String userKey = UserSimplePreferences.getUserKey();
  String section = 'info';
  EventModel eventModel = EventModel();
  Future<Map> futureEventInfo;
  Map eventInfo = {
    'title': '',
    'start': '',
    'color_key': '10',
    'event_type': 'Evento',
  };
  DateTime eventStart = DateTime.now();
  final DateFormat formatterDate = DateFormat.yMMMd('es_ES');
  final DateFormat formatterWeekDay = DateFormat.EEEE('es_ES');
  final DateFormat formatterHour = DateFormat('h:mm a');

  Future<Map> futureCancel;
  Map resultCancel = {'qty_deleted': -1, 'error': ''};

  @override
  void initState() {
    super.initState();
    futureEventInfo = CalendarTools().getEventInfo(widget.eventId, userId);
    futureEventInfo.then((value) {
      eventInfo = value;
      eventStart = DateTime.parse(eventInfo['start']);
      print(eventInfo);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(eventInfo['event_type'])),
        body: setBody(section),
      ),
    );
  }

  //Verifica si hay datos del evento, si no muestra indicador de cargue
  Widget setBody(String section) {
    if (eventInfo['start'] == '') {
      return Center(child: CircularProgressIndicator());
    } else {
      if (section == 'cancelResult') {
        return cancelResult();
      }
      return eventContent();
    }
  }

  //Body con información sobre la reservación
  Widget eventContent() {
    return Container(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 12),
                width: 6,
                height: 24,
                color: kBgColors['room_' + eventInfo['color_key']],
              ),
              Text(
                eventInfo['title'],
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(top: 6, bottom: 12),
            decoration: BoxDecoration(color: Colors.black12),
          ),
          Text(
            formatterWeekDay.format(eventStart),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 6),
          Text(formatterDate.format(eventStart)),
          SizedBox(height: 6),
          Text(
            formatterHour.format(eventStart),
            style: TextStyle(fontSize: 28),
          ),
          SizedBox(height: 24),
          //Si el evento es posterior a ahora, mostrar botón de cancelar
          if (eventStart.isAfter(DateTime.now())) cancelReservationButton(),
        ],
      ),
    );
  }

// Cancelación de la reservación
//------------------------------------------------------------------------------

  Widget cancelReservationButton() {
    return ElevatedButton(
      onPressed: () {
        showCancelConfirmDialog(context);
      },
      child: Text('Cancelar reserva'),
    );
  }

  showCancelConfirmDialog(BuildContext context) {
    // set up the buttons
    Widget noButton = TextButton(
      child: Text('No'),
      onPressed: () => Navigator.pop(context, 'Cancel'),
    );
    Widget yesButton = TextButton(
      child: Text('Sí'),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
        cancelEvent(eventInfo['type_id']);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cancelar reserva"),
      content: Text("¿Confirma que desea cancelar esta reserva?"),
      actions: [
        noButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Contenido para el body, resultado de la cancelación
  Widget cancelResult() {
    //Valores por defecto, éxito
    String _messageResult = 'La reservación fue cancelada';
    Icon _iconResult = Icon(Icons.check_circle, size: 36, color: Colors.blue);

    //Si ocurrió un error
    if (resultCancel['error'] != '') {
      _messageResult = resultCancel['error'];
      _iconResult = Icon(
        Icons.info_outline_rounded,
        color: Colors.yellow[700],
        size: 36,
      );
    }

    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _iconResult,
            SizedBox(height: 24),
            Text(_messageResult),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/calendar_screen', (route) => false);
              },
              child: Text('Calendario'),
            )
          ],
        ),
      ),
    );
  }

  // Cancelar un evento, según el tipo ID
  cancelEvent(eventTypeId) {
    if (eventTypeId == '213') {
      cancelReservation();
    } else {
      cancelAppointment();
    }
  }

  // Cancelar reserva de entrenamiento
  cancelReservation() {
    futureCancel = eventModel.cancelReservation(
      eventInfo['id'],
      eventInfo['training_id'],
    );

    futureCancel.then((response) {
      resultCancel = response;
      section = 'cancelResult';
      setState(() {});
    });
  }

  // Cancelar cita
  cancelAppointment() {
    futureCancel = CalendarTools().cancelAppointment(eventInfo['id'], userId);

    futureCancel.then((response) {
      resultCancel = response;
      section = 'cancelResult';
      setState(() {});
    });
  }
}
