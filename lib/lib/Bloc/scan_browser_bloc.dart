
import 'package:desktopscanner/lib/API/scan_api.dart';
import 'package:desktopscanner/lib/Models/device_model.dart';
import 'package:rxdart/rxdart.dart';

class ScanBrowserBloc{
  final ScanApi _api = ScanApi();
  final _deviceListFetcher = PublishSubject<List<DeviceModel>>();
  List<DeviceModel> selectedDevices = [];

Stream<List<DeviceModel>> get devices =>_deviceListFetcher.stream;


  void lookForDevices(int fromPort, int toPort ) async{
   // await _api.getIP();
   // await _api.getSubNet();
   // await _api.start(fromPort, toPort);
    await _api.printIps();
    List<DeviceModel> _deviceList = _api.listOfDevices;
    _deviceListFetcher.sink.add(_deviceList);
  }


  void selectDevice(DeviceModel device){
    selectedDevices.add(device);
  }

  void deselectDevice(DeviceModel device){
    selectedDevices.remove(device);
  }

  void dispose(){
    _deviceListFetcher.close();
  }

}
final ScanBrowserBloc scanBrowserBloc = ScanBrowserBloc();