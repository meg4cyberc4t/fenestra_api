import 'have_digit.dart';

bool checkCorrectInput(String value) {
  if (value.isEmpty) {
    return false;
  } else if (haveDigit(value)) {
    return false;
  } else if (["login", "password"].contains(value)) {
    return false;
  }
  return true;
}
