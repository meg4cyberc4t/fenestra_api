bool checkCorrectLogin(String login) {
  if (login.length < 6) {
    return false;
  }
  if (int.tryParse(login) != null) {
    return false;
  }
  if (login.contains(' ')) {
    return false;
  }
  for (var item in [
    "password",
    "qwerty",
  ]) {
    if (login == item) {
      return false;
    }
  }
  return true;
}
