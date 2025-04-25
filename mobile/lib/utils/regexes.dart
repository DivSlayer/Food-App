bool hasNumberAndString(String value) {
  RegExp reg1 = RegExp(r'[0-9]', caseSensitive: false);
  RegExp reg2 = RegExp(r'[a-zA-Z]', caseSensitive: false);
  return reg1.hasMatch(value) && reg2.hasMatch(value);
}

bool phoneRegexValidate(String value) {
  RegExp reg1 = RegExp(r'09', caseSensitive: false);
  RegExp reg2 = RegExp(r'۰۹', caseSensitive: false);
  return (reg1.hasMatch(value) || reg2.hasMatch(value)) && value.length == 11;
}
