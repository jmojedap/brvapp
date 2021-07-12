import 'package:flutter/material.dart';
import 'package:brave_app/src/components/bottom_bar_component.dart';

class ReservationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReservationScreenState();
  }
}

class _ReservationScreenState extends State<ReservationScreen> {
  int _step = 1;
  int _keyDia = -1;
  int _keyZona = -1;
  int _keyHorario = -1;
  String _titleAppBar = 'Reservar entrenamiento';

  Map _diaSelection = {'title': '', 'subtitle': ''};
  Map _zonaSelection = {'title': '[ ZONA ]', 'subtitle': ''};
  Map _horarioSelection = {'title': '[ HORA ]', 'subtitle': ''};

  final List<Map> _dias = [
    {'title': 'Hoy', 'subtitle': 'Viernes, 9 de julio', 'enabled': true},
    {'title': 'Mañana', 'subtitle': 'Sábado, 10 de julio', 'enabled': true},
  ];

  final List<Map> _zonas = [
    {'title': 'Zona 1 Resistencia', 'enabled': true},
    {'title': 'Zona 2 Fuerza', 'enabled': true},
    {'title': 'Zona 3 Ejercicio funcional', 'enabled': true},
    {'title': 'Zona 4 Boxeo y MMA', 'enabled': true},
    {'title': 'Zona 5 Fuerza del core TRX', 'enabled': true},
  ];

  final List<Map> _horarios = [
    {'hora': '05:00 am', 'cupos': 5, 'enabled': true},
    {'hora': '06:20 am', 'cupos': 3, 'enabled': true},
    {'hora': '07:40 am', 'cupos': 3, 'enabled': true},
    {'hora': '09:00 am', 'cupos': 3, 'enabled': true},
    {'hora': '10:20 am', 'cupos': 3, 'enabled': true},
    {'hora': '12:20 pm', 'cupos': 0, 'enabled': false},
    {'hora': '04:00 pm', 'cupos': 3, 'enabled': true},
    {'hora': '05:20 pm', 'cupos': 0, 'enabled': false},
    {'hora': '06:20 pm', 'cupos': 5, 'enabled': true},
    {'hora': '06:20 pm', 'cupos': 10, 'enabled': true},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(_diaSelection['title']),
                  subtitle: Text(_diaSelection['subtitle']),
                  onTap: () => _setStep(1),
                  selected: _step == 1,
                ),
                ListTile(
                  leading: Icon(Icons.place_outlined),
                  title: Text(_zonaSelection['title']),
                  onTap: () => _setStep(2),
                  selected: _step == 2,
                  enabled: _step >= 2,
                ),
                ListTile(
                  leading: Icon(Icons.watch_later_outlined),
                  title: Text(_horarioSelection['title']),
                  onTap: () => _setStep(3),
                  selected: _step == 3,
                  enabled: _step >= 3,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 200),
              child: _setBody(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarComponent(),
    );
  }

  _setStep(int step) {
    _step = step;
    setState(() {
      _setBody();
    });
  }

  _setBody() {
    if (_step == 1) {
      return stepDias();
    } else if (_step == 2) {
      _titleAppBar = 'Selecciona la zona';
      return stepZonas();
    } else if (_step == 3) {
      _titleAppBar = 'Selecciona el horario';
      return stepHorarios();
    } else if (_step == 4) {
      _titleAppBar = 'Confirma';
      return stepConfirm();
    } else if (_step == 5) {
      return stepConfirmed();
    }

    return stepConfirm();
  }

  Widget _cupos(int qtyCupos) {
    final List<Widget> cupos = [];

    Color cupoColor = Colors.black12;

    cupos.add(Text(qtyCupos.toString() + ' cupos '));
    for (var i = 0; i < 10; i++) {
      if (i >= (10 - qtyCupos)) {
        cupoColor = Colors.green[400];
      }

      cupos.add(
        Container(
          margin: EdgeInsets.only(right: 1),
          child: CircleAvatar(
            backgroundColor: cupoColor,
            radius: 4,
          ),
        ),
      );
    }

    return Row(
      children: cupos,
    );
  }

  //Seleccion de horario
  Widget stepDias() {
    return ListView.builder(
      itemCount: _dias.length,
      itemBuilder: (BuildContext context, int index) {
        Icon _icono = Icon(Icons.radio_button_off);
        if (index == _keyDia) _icono = Icon(Icons.radio_button_checked);
        return ListTileTheme(
          selectedColor: Colors.white,
          selectedTileColor: Colors.green,
          child: ListTile(
            leading: _icono,
            title: Text(_dias[index]['title']),
            subtitle: Text(_dias[index]['subtitle']),
            enabled: _dias[index]['enabled'],
            selected: index == _keyDia,
            onTap: () {
              setState(() {
                _keyDia = index;
                _diaSelection['title'] = _dias[index]['title'];
                _diaSelection['subtitle'] = _dias[index]['subtitle'];
                print(_keyDia);
                _setStep(2);
              });
            },
          ),
        );
      },
    );
  }

  //Seleccion de horario
  Widget stepZonas() {
    return ListView.builder(
      itemCount: _zonas.length,
      itemBuilder: (BuildContext context, int index) {
        Icon _icono = Icon(Icons.radio_button_off);
        if (index == _keyZona) _icono = Icon(Icons.radio_button_checked);
        return ListTileTheme(
          selectedTileColor: Colors.green,
          selectedColor: Colors.white,
          child: ListTile(
            leading: _icono,
            title: Text(_zonas[index]['title']),
            enabled: _zonas[index]['enabled'],
            selected: index == _keyZona,
            onTap: () {
              setState(() {
                _keyZona = index;
                _zonaSelection['title'] = _zonas[index]['title'];
                print(_keyZona);
                _setStep(3);
              });
            },
          ),
        );
      },
    );
  }

  //Seleccion de horario
  Widget stepHorarios() {
    return ListView.builder(
      itemCount: _horarios.length,
      itemBuilder: (BuildContext context, int index) {
        Icon _icono = Icon(Icons.radio_button_off);
        if (index == _keyHorario) _icono = Icon(Icons.radio_button_checked);
        return ListTileTheme(
          selectedTileColor: Colors.green,
          selectedColor: Colors.white,
          child: ListTile(
            leading: _icono,
            title: Text(_horarios[index]['hora']),
            //subtitle: Text(_horarios[index]['cupos'].toString() + ' cupos'),
            subtitle: _cupos(_horarios[index]['cupos']),
            enabled: _horarios[index]['enabled'],
            selected: index == _keyHorario,
            onTap: () {
              setState(() {
                _keyHorario = index;
                _horarioSelection['title'] = _horarios[index]['hora'];
                _setStep(4);
              });
            },
          ),
        );
      },
    );
  }

  Widget stepConfirm() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _setStep(5);
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
              Navigator.of(context).pop();
            },
            child: Text('Ir a calendario'),
          )
        ],
      ),
    );
  }
}
