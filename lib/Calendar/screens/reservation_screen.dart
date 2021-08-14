import 'package:brave_app/Accounts/models/user_simple_preferences.dart';
import 'package:flutter/material.dart';
import 'package:brave_app/src/components/bottom_bar_component.dart';
import 'package:brave_app/Config/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
//import 'package:brave_app/Calendar/models/day_model.dart';

class ReservationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReservationScreenState();
  }
}

class _ReservationScreenState extends State<ReservationScreen> {
// Variables
//--------------------------------------------------------------------------
  String userId;

  int _step = 1;
  String titleAppBar = 'Reservar entrenamiento';

  int _keyDay = -1;
  Map _daySelection = {'id': '0', 'title': ''};
  Future<List<Map>> _trainingDays;

  int _keyRoom = -1;
  Map _roomSelection = {'id': '0', 'title': ''};
  Future<List<Map>> _roomsFuture;
  List<Map> _rooms;

  int _keyTraining = -1;
  Map _trainingSelection = {'id': '0', 'title': ''};
  Future<List<Map>> _trainingsFuture;
  List<Map> _trainings;

  Future<Map> _saveReservationResponse;

  @override
  void initState() {
    super.initState();
    _trainingDays = _getTrainingDays();
    userId = UserSimplePreferences.getUserId() ?? '0';
    print(userId);
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
                  leading: Icon(Icons.calendar_today),
                  title: Text(_daySelection['title']),
                  subtitle: Text('Día'),
                  onTap: () => _setStep(1),
                  selected: _step == 1,
                ),
                ListTile(
                  leading: Icon(Icons.room_outlined),
                  title: Text(_roomSelection['title']),
                  subtitle: Text('Zona'),
                  onTap: () => _setStep(2),
                  selected: _step == 2,
                  enabled: _step >= 2,
                ),
                ListTile(
                  leading: Icon(Icons.watch_later_outlined),
                  title: Text(_trainingSelection['title']),
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
              margin: EdgeInsets.only(top: 230),
              child: _setBody(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarComponent(),
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
      _keyRoom = -1;
      _roomSelection = {'id': '0', 'title': ''};
      _keyTraining = -1;
      _trainingSelection = {'id': '0', 'title': ''};
      return stepDays();
    } else if (_step == 2) {
      _keyTraining = -1;
      _trainingSelection = {'id': '0', 'title': ''};
      titleAppBar = 'Selecciona la zona';
      return stepRooms();
    } else if (_step == 3) {
      titleAppBar = 'Selecciona el horario';
      return stepTrainings();
    } else if (_step == 4) {
      titleAppBar = 'Confirma';
      return stepConfirm();
    } else if (_step == 5) {
      return stepConfirmed();
    }

    return stepConfirm();
  }

// Paso 1: Selección de día
//--------------------------------------------------------------------------

  //Requerir a API listado días de entrenamiento
  Future<List<Map>> _getTrainingDays() async {
    const String urlDays = kUrlApi + 'reservations/get_training_days';
    final response = await http.get(Uri.parse(urlDays));

    List<Map> daysList = [];

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      for (var item in responseBody['days']) {
        daysList.add(item);
      }
      return daysList;
    } else {
      throw Exception('Error al solicitar días de entrenamiento');
    }
  }

  //Widget ListView, selección de día
  Widget stepDays() {
    return FutureBuilder(
      future: _trainingDays,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView(children: _daysWidgetList(snapshot.data));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
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
        if (index == _keyDay) _icono = Icon(Icons.radio_button_checked);

        Widget dayTile = ListTileTheme(
          selectedColor: Colors.white,
          selectedTileColor: Colors.green,
          child: ListTile(
            leading: _icono,
            title: Text(item['period_name']),
            selected: index == _keyDay,
            onTap: () {
              setState(() {
                _keyDay = index;
                _daySelection['id'] = item['id'];
                _daySelection['title'] = item['period_name'];
                _setRooms();
              });
            },
          ),
        );

        days.add(dayTile); //Agregar Widget a Lista
      },
    );

    return days;
  }

// Paso 2: Selección de Zona
//------------------------------------------------------------------------------

  void _setRooms() {
    _roomsFuture = _getRooms(_daySelection['id']);

    _roomsFuture.then((data) {
      _rooms = data;
      _setStep(2);
    });
  }

  //Requerir a API listado zonas de entrenamiento
  Future<List<Map>> _getRooms(dayId) async {
    final String urlRooms =
        kUrlApi + 'reservations/get_available_rooms/$dayId/$userId';
    final response = await http.get(Uri.parse(urlRooms));

    print(urlRooms);

    List<Map> roomsList = [];

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      for (var item in responseBody['rooms']) {
        roomsList.add(item);
      }
      return roomsList;
    } else {
      throw Exception('Error al solicitar zonas de entrenamiento');
    }
  }

  //Widget ListView, selección de zona de entrenamiento
  Widget stepRooms() {
    return ListView.builder(
      itemCount: _rooms.length,
      itemBuilder: (BuildContext context, int index) {
        Icon _icono = Icon(Icons.radio_button_off);
        if (index == _keyRoom) _icono = Icon(Icons.radio_button_checked);
        return ListTileTheme(
          selectedTileColor: Colors.green,
          selectedColor: Colors.white,
          child: ListTile(
            leading: _icono,
            title: titleRoom(_rooms[index]),
            enabled: _rooms[index]['available'] == 1,
            selected: index == _keyRoom,
            onTap: () {
              setState(() {
                _keyRoom = index;
                _roomSelection['id'] = _rooms[index]['room_id'];
                _roomSelection['title'] = _rooms[index]['name'];
                print(_keyRoom);
                _setTrainings();
              });
            },
          ),
        );
      },
    );
  }

  Widget titleRoom(Map room) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 12),
          width: 6,
          height: 24,
          color: kBgColors['room_' + room['room_id']],
        ),
        Text(room['name']),
      ],
    );
  }

// Paso 3: Selección de Training
//------------------------------------------------------------------------------
  void _setTrainings() {
    _trainingsFuture = _getTrainings(_daySelection['id'], _roomSelection['id']);

    _trainingsFuture.then((data) {
      _trainings = data;
      _setStep(3);
    });
  }

  //Requerir a API listado zonas de entrenamiento
  Future<List<Map>> _getTrainings(String dayId, String roomId) async {
    final String urlTrainings =
        kUrlApi + 'trainings/get_trainings/$dayId/$roomId';
    final response = await http.get(Uri.parse(urlTrainings));

    List<Map> trainingsList = [];

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      for (var item in responseBody['list']) {
        trainingsList.add(item);
      }
      return trainingsList;
    } else {
      throw Exception('Error al solicitar listado de entrenamientos');
    }
  }

  //Widget ListView, selección de zona de entrenamiento
  /*Widget stepTrainings() {
    return ListView.builder(
      itemCount: _trainings.length,
      itemBuilder: (BuildContext context, int index) {
        Icon _icono = Icon(Icons.radio_button_off);
        if (index == _keyRoom) _icono = Icon(Icons.radio_button_checked);
        return ListTileTheme(
          selectedTileColor: Colors.green,
          selectedColor: Colors.white,
          child: ListTile(
            leading: _icono,
            title: Text(_rooms[index]['name']),
            enabled: _rooms[index]['available'] == 1,
            selected: index == _keyRoom,
            onTap: () {
              setState(() {
                _keyRoom = index;
                _roomSelection['title'] = _rooms[index]['name'];
                print(_keyRoom);
                _setStep(3);
              });
            },
          ),
        );
      },
    );
  }*/

  Widget stepTrainings() {
    return ListView.builder(
      itemCount: _trainings.length,
      itemBuilder: (BuildContext context, int index) {
        Icon _icono = Icon(Icons.radio_button_off);
        if (index == _keyTraining) _icono = Icon(Icons.radio_button_checked);
        return ListTileTheme(
          selectedTileColor: Colors.green,
          selectedColor: Colors.white,
          child: ListTile(
            leading: _icono,
            title: Text(_trainings[index]['title']),
            subtitle: _spotsWidget(_trainings[index]['total_spots'],
                _trainings[index]['available_spots']),
            enabled: _trainings[index]['active'] == 1,
            selected: index == _keyTraining,
            onTap: () {
              setState(() {
                _keyTraining = index;
                _trainingSelection['id'] = _trainings[index]['id'];
                _trainingSelection['title'] = _trainings[index]['title'];
                _setStep(4);
              });
            },
          ),
        );
      },
    );
  }

  //Widet Subtítulo Trainings, cupos disponibles
  Widget _spotsWidget(int totalSpots, int availableSpots) {
    double takenWidth = 0;
    double availableWidth = 100;

    availableWidth = 100 * (availableSpots / totalSpots);
    takenWidth = 100 - availableWidth;

    return Row(
      children: [
        Text(availableSpots.toString() + ' cupos'),
        SizedBox(width: 10),
        Container(
          height: 10,
          width: takenWidth,
          color: Colors.purple[700],
        ),
        Container(
          height: 10,
          width: availableWidth,
          color: Colors.black12,
        ),
      ],
    );
  }

// Paso 4: Requerir confirmación
//--------------------------------------------------------------------------
  Widget stepConfirm() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                //_setStep(5);
                _saveReservationResponse = _saveReservation();

                _saveReservationResponse.then((response) {
                  if (response['saved_id'] > 0) {
                    _setStep(5);
                  }
                });
              },
              child: Text(
                'Confirmar reserva',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  //Enviar datos de formulario y recibir datos de validación
  Future<Map> _saveReservation() async {
    String trainingId = _trainingSelection['id'];
    var url = Uri.parse(kUrlApi + 'reservations/save/$trainingId/$userId');
    //print(url);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      //print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al guardar reservación');
    }
  }

// Paso 5: Mostrar resultado confirmación
//------------------------------------------------------------------------------

  Widget stepConfirmed() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 48, color: Colors.green[600]),
          SizedBox(height: 20),
          Text('Reserva confirmada', style: TextStyle(fontSize: 28)),
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
}
