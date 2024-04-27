import 'package:location/location.dart';

class LocationService {
  Location location = Location();


  ///First Step .
  ///Check  Location Service on Mobile
  //if(its Not enabled , Ask For enable )
  //if user Denied -> Show snakbar error

  Future<bool> checkAndRequestLocationService() async {
    bool isEnabled = await location.serviceEnabled();
    if (!isEnabled) {
      isEnabled = await location.requestService();
      if (!isEnabled) {
        return false;
      }
    }
    return true;
  }


  ///Second Step
  ///Check  Location Permission on Application
  // if - he has a Permission
  //   Check if user Denied For one time -> Ask for permission
  // if user not accepted again -> Not Granted (denied or denied forever )

  Future<bool> checkAndRequestLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();

      return permissionStatus == PermissionStatus.granted;
    }
    return true;
  }


  // void getRealTimeLocationData(void Function(LocationData)? onData) {
  //   ///Request a new location every 2 meter
  //   /// store previous location and compare with current Location
  //   ///update if current>2m of Previous Location
  //
  //   // location.changeSettings(
  //   //   distanceFilter: 5,
  //   // );
  //   location.onLocationChanged.listen(onData);
  // }

Future<LocationData> getData() async
{
  return await location.getLocation();
}

}
