import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  ///First Step .
  ///Check  Location Service on Mobile
  //if(its Not enabled , Ask For enable )
  //if user Denied -> Show snakbar error

  Future<void> checkAndRequestLocationService() async {
    bool isEnabled = await location.serviceEnabled();
    if (!isEnabled) {
      isEnabled = await location.requestService();
      if (!isEnabled) {
        throw LocationServiceException() ;
      }
    }

  }

  ///Second Step
  ///Check  Location Permission on Application
  // if - he has a Permission
  //   Check if user Denied For one time -> Ask for permission
  // if user not accepted again -> Not Granted (denied or denied forever )

  Future<void> checkAndRequestLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.deniedForever) {
      throw LocationPermissionException();
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();

     if(permissionStatus!=PermissionStatus.granted)
       {
         throw LocationPermissionException();
       }
    }

  }

  void getRealTimeLocationData(void Function(LocationData)? onData) async {
    ///Request a new location every 2 meter
    /// store previous location and compare with current Location
    ///update if current>2m of Previous Location

    // location.changeSettings(
    //   distanceFilter: 5,
    // );
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();

    location.onLocationChanged.listen(onData);
  }

  Future<LocationData> getData() async {
    return await location.getLocation();
  }
}

class LocationServiceException implements Exception {}
class LocationPermissionException implements Exception {}
