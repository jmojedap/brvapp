/*
 * Constantes y herramientas para Validación de formularios
 */

import 'package:form_field_validator/form_field_validator.dart';

//Constante validator para contraseña de usuario
final kPasswordValidator = MultiValidator([
  RequiredValidator(errorText: 'la contraseña es requerida'),
  MinLengthValidator(8, errorText: 'debe tener al menos 8 caracteres')
]);

//Constante validator para email requerido
final kRequiredEmailValidator = MultiValidator([
  RequiredValidator(errorText: 'El e-mail es requerido'),
  EmailValidator(errorText: 'Ingrese un e-mail válido')
]);
