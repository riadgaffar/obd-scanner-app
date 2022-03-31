import 'package:formz/formz.dart';

enum IPAddressValidationError { empty }

class IPAddress extends FormzInput<String, IPAddressValidationError> {
  const IPAddress.pure() : super.pure('');
  const IPAddress.dirty([String value = '']) : super.dirty(value);

  @override
  IPAddressValidationError? validator(String value) {
    return value.isNotEmpty == true ? null : IPAddressValidationError.empty;
  }
}
