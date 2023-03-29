class UtilitiesEvent {
  String getDay(String day) {
    String dia = '';
    switch (day) {
      case 'L':
        dia = 'Lun';
        break;
      case 'M':
        dia = 'Mar';
        break;
      case 'X':
        dia = 'Mie';
        break;
      case 'J':
        dia = 'Jue';
        break;
      case 'V':
        dia = 'Vie';
        break;
      case 'S':
        dia = 'Sab';
        break;
      case 'D':
        dia = 'Dom';
        break;
    }
    return dia;
  }
}
