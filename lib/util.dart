bool getBool(dynamic value) {
  switch (value) {
    case bool:
      return value;
    case int:
      return value == 0 ? false : true;
    default:
      return false;
  }
}
