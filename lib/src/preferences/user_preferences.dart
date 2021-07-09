import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new UserPreferences();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...
*/

class UserPreferences {
  static final UserPreferences _instance = new UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del nombre
  get endpoint {
    return _prefs.getString('endpoint') ?? '';
  }

  set endpoint(String value) {
    _prefs.setString('endpoint', value);
  }

  // GET y SET del nombre
  get username {
    return _prefs.getString('username') ?? '';
  }

  set username(String value) {
    _prefs.setString('username', value);
  }

  // GET y SET del nombre
  get password {
    return _prefs.getString('password') ?? '';
  }

  set password(String value) {
    _prefs.setString('password', value);
  }

  get authFlag {
    return _prefs.getBool('authFlag') ?? false;
  }

  set authFlag(bool value) {
    _prefs.setBool('authFlag', value);
  }
}
