import 'package:permission_handler/permission_handler.dart';

class Permissions {
  Future<PermissionStatus> requestGPS() async {
    var permission = await Permission.location.request();
    return permission;
  }

  Future<bool> getCurrentStatusGPS() async {
    final status = await Permission.location.status;
    bool statusGPS = false;
    if (status == PermissionStatus.granted) {
      statusGPS = true;
    }
    return statusGPS;
  }
}
