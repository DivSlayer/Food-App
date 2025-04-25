
import 'package:food_app/utils/regexes.dart';

class Validators {
  static (bool, String?) validatePhone(String value) {
    String? phoneError;
    if (value != '') {
      if (!phoneRegexValidate(value)) {
        phoneError = 'شماره همراه نامعتبر است';
        return (false, phoneError);
      } else {
        phoneError = null;
        return (true, phoneError);
      }
    } else {
      phoneError = null;
      return (false, phoneError);
    }
  }
}
