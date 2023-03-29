import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/resources/user_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  //Setear valores para saber si inicio sesion o no y en base a eso mostrar opciones
  Future<void> setValueSection() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('valueSection', 0);
  }

  Future<int> getValueSection() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('valueSection')!.toInt();
  }

  Future<void> setNewValueSection() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('valueSection', 1);
  }

  Future<void> setCurrentCoordinatesLocations(Position position) async {}

  Future<void> getCurrentLocation() async {}

  Future<void> setDistance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('distance')) {
    } else {
      sharedPreferences.setDouble('distance', 15);
    }
  }

  Future<void> modifyDistance(double newValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble('distance', newValue);
  }

  Future<double> getDistance() async {
    double distance = 0.0;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    distance = await sharedPreferences.getDouble('distance')!;
    return distance;
  }

  Future<void> setValueLogged() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isLogged', true);
  }

  Future<void> changeValueLogged(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isLogged', value);
  }

  Future<bool> getValueLogged() async {
    bool isLogged = false;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('isLogged')) {
      isLogged = await sharedPreferences.getBool('isLogged')!;
    }

    return isLogged;
  }

  Future<bool> existsKeyUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool exists = false;
    if (sharedPreferences.containsKey('username')) {
      exists = true;
    }
    return exists;
  }

  Future<bool> existsKeyLogged() async {
    bool contains = false;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('isLogged')) {
      contains = true;
    }
    return contains;
  }

  Future<void> setNameUser(String userid) async {
    print('name USER' + userid);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String nameUser = await UserProvider().getNameAndSurnameUser(userid);
    sharedPreferences.setString('nameUser', nameUser);
  }

  Future<void> setUsername(String userid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('username', userid);
  }

  Future<void> deleteUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('username');
  }

  Future<String> getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? userid = await sharedPreferences.getString('username');
    return userid.toString();
  }

  Future<String> getNameUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String nameUser = "";
    if (sharedPreferences.containsKey('nameUser')) {
      String? resp = sharedPreferences.getString('nameUser');
      nameUser = resp!;
    }

    return nameUser;
  }

  Future<void> changeNameUser(String nameUser) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('nameUser', nameUser);
  }

  Future<bool> existsKeyNameUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('nameUser')) {
      return true;
    }
    return false;
  }
}
