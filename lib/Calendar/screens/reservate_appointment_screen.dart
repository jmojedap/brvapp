import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:flutter/material.dart';
import 'package:brave_app/Common/screens/bottom_bar_component.dart';
import 'package:brave_app/Config/constants.dart';
import 'dart:async';
import 'package:brave_app/Calendar/models/calendar_tools.dart';
import 'package:intl/intl.dart';

class ReservateAppointmentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReservateAppointmentScreenState();
  }
}

class _ReservateAppointmentScreenState
    extends State<ReservateAppointmentScreen> {
// Variables
//--------------------------------------------------------------------------
  String userId = UserSimplePreferences.getUserId();
  String saveReservationError = '';

  int _step = 1;
  String titleAppBar = 'Reservar cita';

  int _keyType = -1;
  Map _typeSelection = {'id': '0', 'title': '', 'keyColor': 'disabled'};
  List<Map> _appointmentTypes = [
    {'type_id': '221', 'title': 'Control nutrición'},
    {'type_id': '223', 'title': 'Estética masajes'},
    {'type_id': '225', 'title': 'Estética máquina'},
  ];

  int _keyDay = -1;
  Map _daySelection = {'id': '0', 'title': ''};
  Future<List<Map>> _appointmentDays;

  int _keyAppointment = -1;
  Map _appointmentSelection = {'id': '0', 'title': ''};
  Future<List<Map>> _appointmentsFuture;
  List<Map> _appointments;

  Future<Map> _saveReservationResponse;

  @override
  void initState() {
    super.initState();
  }

// Constructor Scaffold
//--------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleAppBar),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.circle,
                    color: kBgColors[_typeSelection['keyColor']],
                  ),
                  title: Text(_typeSelection['title']),
                  subtitle: Text('Tipo'),
                  onTap: () => _setStep(1),
                  selected: _step == 1,
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(_daySelection['title']),
                  subtitle: Text('Día'),
                  onTap: () => _setStep(2),
                  selected: _step == 2,
                ),
                ListTile(
                  leading: Icon(Icons.watch_later_outlined),
                  title: Text(_appointmentSelection['title']),
                  subtitle: Text('Hora'),
                  onTap: () => _setStep(3),
                  selected: _step == 3,
                  enabled: _step >= 3,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 225),
              child: _setBody(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarComponent(0),
    );
  }

// Funciones
//--------------------------------------------------------------------------

  //Establecer paso del proceso y actualizar estado
  _setStep(int step) {
    _step = step;
    setState(() {
      _setBody();
    });
  }

  //Establecer el contenido del body, seleccion de elemento
  _setBody() {
    if (_step == 1) {
      _keyType = -1;
      //Reiniciar selección día
      _keyDay = -1;
      _daySelection = {'id': '0', 'title': ''};
      //Reiniciar selección cita
      _keyAppointment = -1;
      _appointmentSelection = {'id': '0', 'title': ''};
      return stepTypes();
    } else if (_step == 2) {
      titleAppBar = 'Selecciona el día';
      //Reiniciar selección cita
      _keyAppointment = -1;
      _appointmentSelection = {'id': '0', 'title': ''};
      return stepDays();
    } else if (_step == 3) {
      titleAppBar = 'Selecciona el horario';
      return stepAppointments();
    } else if (_step == 4) {
      titleAppBar = 'Verifica y confirma';
      return stepConfirm();
    } else if (_step == 5) {
      return stepConfirmed();
    } else if (_step == 11) {
      return stepError();
    } else if (_step == 99) {
      return Center(child: CircularProgressIndicator());
    }

    return stepConfirm();
  }

// Paso 1: Selección del tipo de cita
//--------------------------------------------------------------------------

  //Widget ListView, selección de tipo
  Widget stepTypes() {
    return ListView(children: _typesWidgetList());
  }

  //Lista con widgets de tipos
  List<Widget> _typesWidgetList() {
    List<Widget> types = [];

    _appointmentTypes.asMap().forEach(
      (index, item) {
        Icon _icono = Icon(Icons.radio_button_off);

        if (index == _keyType) _icono = Icon(Icons.radio_button_checked);

        Widget typeTile = ListTileTheme(
          selectedColor: Colors.white,
          selectedTileColor: Colors.green,
          child: ListTile(
            leading: _icono,
            title: Text(item['title']),
            selected: index == _keyType,
            onTap: () {
              setState(() {
                _keyType = index;
                _typeSelection['id'] = item['type_id'];
                _typeSelection['title'] = item['title'];
                _typeSelection['keyColor'] = 'event_' + item['type_id'];
                _setDays();
              });
            },
          ),
        );

        types.add(typeTile); //Agregar Widget a Lista
      },
    );

    return types;
  }

// Paso 2: Selección de día
//--------------------------------------------------------------------------

  void _setDays() {
    _setStep(99); //Loading indicator
    _appointmentDays =
        CalendarTools().getAppointmentsDays(userId, _typeSelection['id']);

    _appointmentDays.then((data) {
      _setStep(2);
    });
  }

  //Widget ListView, selección de día
  Widget stepDays() {
    return FutureBuilder(
      future: _appointmentDays,
      builder: (BuildContext context, AsyncSnapshot snapshotDays) {
        if (snapshotDays.hasData) {
          return ListView(children: _daysWidgetList(snapshotDays.data));
        } else if (snapshotDays.hasError) {
          return Text("${snapshotDays.error}");
        }

        // Por defecto, indicador carga en proceso
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  //Lista con widgets de días
  List<Widget> _daysWidgetList(daysList) {
    List<Widget> days = [];

    daysList.asMap().forEach(
      (index, item) {
        Icon _icono = Icon(Icons.radio_button_off);
        String _subtitleText = '';
        /*if (item['qty_user_reservations'] > 0) {
          _subtitleText = 'Ya tienes una reserva';
        }*/
        if (index == _keyDay) _icono = Icon(Icons.radio_button_checked);

        Widget dayTile = ListTileTheme(
          selectedColor: Colors.white,
          selectedTileColor: Colors.green,
          child: ListTile(
            leading: _icono,
            title: Text(item['period_name']),
            selected: index == _keyDay,
            //enabled: item['qty_user_reservations'] == 0,
            subtitle: Text(_subtitleText),
            onTap: () {
              setState(() {
                _keyDay = index;
                _daySelection['id'] = item['id'];
                _daySelection['title'] = item['period_name'];
                _setAppointments();
              });
            },
          ),
        );

        days.add(dayTile); //Agregar Widget a Lista
      },
    );

    return days;
  }

// Paso 3: Selección de citas, horarios
//------------------------------------------------------------------------------
  void _setAppointments() {
    _setStep(99); //Loading indicator
    _appointmentsFuture = CalendarTools()
        .getAppointments(_daySelection['id'], _typeSelection['id']);

    _appointmentsFuture.then((data) {
      _appointments = data;
      _setStep(3);
    });
  }

  Widget stepAppointments() {
    return ListView.builder(
      itemCount: _appointments.length,
      itemBuilder: (BuildContext context, int index) {
        Icon _icono = Icon(Icons.radio_button_off);
        if (index == _keyAppointment) _icono = Icon(Icons.radio_button_checked);
        // Hora de inicio
        DateTime _appointmentStart =
            DateTime.parse(_appointments[index]['start']);
        // Hora de inicio texto con formato
        String _appointmentHourStart =
            DateFormat('kk:mm a').format(_appointmentStart);
        return ListTileTheme(
          selectedTileColor: Colors.green,
          selectedColor: Colors.white,
          child: ListTile(
            leading: _icono,
            title: Text(_appointmentHourStart),
            enabled: _appointments[index]['active'] == 1,
            selected: index == _keyAppointment,
            onTap: () {
              setState(() {
                _keyAppointment = index;
                _appointmentSelection['id'] = _appointments[index]['id'];
                _appointmentSelection['title'] = _appointmentHourStart;
                _setStep(4); //Paso siguiente
              });
            },
          ),
        );
      },
    );
  }

// Paso 4: Requerir confirmación
//--------------------------------------------------------------------------
  Widget stepConfirm() {
    return Center(
      child: Column(
        children: [
          Container(
            child: Text('Verifica los datos y confirma tu cita'),
            padding: EdgeInsets.all(20),
          ),
          SizedBox(
            width: 180,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _setStep(99); //Loading indicator
                _saveReservationResponse = CalendarTools().reservateAppointment(
                  _appointmentSelection['id'],
                  userId,
                );

                _saveReservationResponse.then((response) {
                  print(response);
                  if (response['status'] == 1) {
                    _setStep(5);
                  } else {
                    saveReservationError = response['error'];
                    _setStep(11);
                  }
                });
              },
              child: Text(
                'RESERVAR',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                primary: kBgColors['appSecondary'],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Paso 5: Mostrar resultado confirmación
//------------------------------------------------------------------------------

  //Resultado de éxito al reservar una cita
  Widget stepConfirmed() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 36, color: Colors.blue),
          SizedBox(height: 15),
          Text('Cita reservada', style: TextStyle(fontSize: 28)),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/calendar_screen', (route) => false);
            },
            child: Text('Ir a calendario'),
          )
        ],
      ),
    );
  }

  //Resultado del intento reservar una cita, si hubo error.
  Widget stepError() {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline_rounded, size: 36, color: Colors.yellow[800]),
          SizedBox(height: 15),
          Text('La reserva no se guardó', style: TextStyle(fontSize: 15)),
          SizedBox(height: 15),
          Text(saveReservationError, style: TextStyle(fontSize: 18)),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/calendar_screen',
                (route) => false,
              );
            },
            child: Text('Ir a calendario'),
          ),
        ],
      ),
    );
  }
}
