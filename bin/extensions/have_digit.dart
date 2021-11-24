bool haveDigit(String s) =>
    s.codeUnits.where((element) => 48 < element && element < 57).isNotEmpty;
