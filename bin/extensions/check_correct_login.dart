bool checkCorrectLogin(String login) {
  if (login.length < 3) {
    return false;
  }
  if (int.tryParse(login) != null) {
    return false;
  }
  if (login.contains(' ')) {
    return false;
  }
  if (["password", "qwerty"].contains(login)) {
    return false;
  }

  return true;
}
