import 'package:flutter/material.dart';
import 'package:brave_app/Config/constants.dart';

class HealthSurveyScreen extends StatefulWidget {
  //HealthSurveyScreen({Key? key}) : super(key: key);

  @override
  _HealthSurveyScreenState createState() => _HealthSurveyScreenState();
}

class _HealthSurveyScreenState extends State<HealthSurveyScreen> {
  String step = 'survey';
  bool noneSymptom = true;
  Map<String, bool> symptomStatus = {
    'tos': false,
    'escalofrios': false,
    'diarrea': false,
    'dolor_garganta': false,
    'fiebre': false,
    'fatiga': false,
    'dificultad_respirar': false,
    'dolor_corporal': false,
    'dolor_cabeza': false,
    'falta_olfato': false,
    'falta_gusto': false,
  };
  bool fluLastDays = false;
  bool inContact = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Estado de salud'),
        ),
        body: bodyContent(step),
      ),
    );
  }

  Widget bodyContent(String step) {
    if (step == 'symptomsAlert') {
      return symptomsAlert();
    }
    return surveyContent();
  }

  Widget surveyContent() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
              'Selecciona si has experimentado uno o más de estos síntomas recientemente'),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              symptomButton('Tos', 'tos'),
              symptomButton('Escalofríos', 'escalofrios'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              symptomButton('Diarrea', 'diarrea'),
              symptomButton('Dolor de garganta', 'dolor_garganta'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              symptomButton('Fiebre mayor a 37.5', 'fiebre'),
              symptomButton('Fatiga', 'fatiga'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              symptomButton('Dificultad para respirar', 'dificultad_respirar'),
              symptomButton('Dolor corporal', 'dolor_corporal'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              symptomButton('Dolor de cabeza', 'dolor_cabeza'),
              symptomButton('Falta de olfato', 'falta_olfato'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              symptomButton('Falta de gusto', 'falta_gusto'),
              noneSymptomButton(),
            ],
          ),
          SizedBox(height: 12),
          SwitchListTile(
            title:
                Text('He presentado un cuadro gripal en los últimos 14 días'),
            value: fluLastDays,
            onChanged: (value) {
              setState(() {
                fluLastDays = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('He estado en contacto con personas infectadas'),
            value: inContact,
            onChanged: (value) {
              setState(() {
                inContact = value;
              });
            },
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              checkAnswer();
            },
            child: Text('Continuar'),
          ),
        ],
      ),
    );
  }

  Widget symptomButton(String symptomText, String symptomKey) {
    Color _bgColor = Colors.black12;
    Color _textColor = Colors.black87;
    if (symptomStatus[symptomKey]) {
      _bgColor = kBgColors['appSecondary'];
      _textColor = Colors.white;
    }
    return Expanded(
      child: InkWell(
        onTap: () {
          symptomStatus[symptomKey] = !symptomStatus[symptomKey];
          if (symptomStatus[symptomKey]) noneSymptom = false;
          print(symptomStatus[symptomKey]);
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.all(3),
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: _bgColor),
          child: Text(symptomText, style: TextStyle(color: _textColor)),
        ),
      ),
    );
  }

  Widget noneSymptomButton() {
    Color _bgColor = Colors.black12;
    Color _textColor = Colors.black87;
    if (noneSymptom) {
      _bgColor = kBgColors['appSecondary'];
      _textColor = Colors.white;
    }
    return Expanded(
      child: InkWell(
        onTap: () {
          noneSymptom = !noneSymptom;
          if (noneSymptom) {
            symptomStatus.forEach((key, value) {
              symptomStatus[key] = false;
            });
          }
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.all(3),
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: _bgColor),
          child: Text('NINGUNO', style: TextStyle(color: _textColor)),
        ),
      ),
    );
  }

// Resultado de encuestas
//------------------------------------------------------------------------------

  //Revisar si el usuario ha marcado alguno de los síntomas
  void checkAnswer() {
    symptomStatus.forEach((sympTomkey, status) {
      if (status) step = 'symptomsAlert';
    });
    if (fluLastDays) step = 'symptomsAlert';
    if (inContact) step = 'symptomsAlert';

    //Si tiene síntomas mostrar alerta
    if (step == 'symptomsAlert') {
      setState(() {
        bodyContent(step);
      });
    } else {
      //No tiene síntomas, ir a reservaciones
      Navigator.pop(context);
      Navigator.of(context).pushNamed('/reservation_screen');
    }
  }

  // Resultado respuesta encuesta con síntomas
  Widget symptomsAlert() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline_rounded, color: Colors.blue, size: 48),
          SizedBox(height: 18),
          Text(
            'En el momento presentas síntomas y no es posible continuar con el proceso de reserva.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Continuar'),
          ),
        ],
      ),
    );
  }
}
