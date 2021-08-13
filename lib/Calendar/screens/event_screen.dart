import 'package:brave_app/Config/constants.dart';
import 'package:flutter/material.dart';
import 'package:brave_app/Calendar/models/event_model.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  final String eventId;
  EventScreen(this.eventId);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  EventModel eventModel = EventModel();
  Future<Map> futureEventInfo;
  Map eventInfo = {'title': '', 'start': '', 'room_id': '10'};
  DateTime eventStart = DateTime.now();
  final DateFormat formatterDate = DateFormat.yMMMd('es_ES');
  final DateFormat formatterWeekDay = DateFormat.EEEE('es_ES');
  final DateFormat formatterHour = DateFormat('h:mm a');

  Future<Map> futureCancel;
  Map mapCancel = {'qty_deleted': -1, 'error': ''};

  @override
  void initState() {
    super.initState();
    futureEventInfo = eventModel.getReservatonInfo(widget.eventId, '202019');
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
        appBar: AppBar(title: Text('Reserva entrenamiento')),
        body: setBody(),
      ),
    );
  }

  //Verifica si hay datos del evento, si no muestra indicador de cargue
  Widget setBody() {
    if (eventInfo['title'] == '') {
      return Center(child: CircularProgressIndicator());
    }
    return eventContent();
  }

  //Bodoy con información sobre la reservación
  Widget eventContent() {
    return Container(
      padding: EdgeInsets.all(18),
      child: Column(
        children: [
          Text(eventInfo['title'], style: TextStyle(fontSize: 24)),
          Container(
            height: 1,
            margin: EdgeInsets.only(top: 6, bottom: 12),
            decoration:
                BoxDecoration(color: kBgColors['room_' + eventInfo['room_id']]),
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
          ElevatedButton(
            onPressed: () {
              cancelReservation();
            },
            child: Text('Cancelar reserva'),
          ),
        ],
      ),
    );
  }

// Cancelación de la reservación
//------------------------------------------------------------------------------

  Widget cancelResult() {
    return Center(
      child: Text('La reservación fue cancelada'),
    );
  }

  cancelReservation() {
    futureCancel = eventModel.cancelReservation(
      eventInfo['id'],
      eventInfo['training_id'],
    );

    futureCancel.then((value) {
      print(value);
      mapCancel = value;
    });
  }
}
