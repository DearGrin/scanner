import 'dart:io';
import 'package:desktopscanner/lib/Models/device_model.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
//import 'package:connectivity/connectivity.dart';



class ScanApi{
  String wifiIP;
  String subnet;
  final List<DeviceModel> listOfDevices = [];

  Future printIps() async {
    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        print(
            '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
        var item = DeviceModel(addr.address, addr.rawAddress.toString(), interface.name, addr.type.name, addr.isLoopback.toString());
        if(interface.name == 'Ethernet' || interface.name.contains('wlan'))
        {
          wifiIP = addr.address;
        }
        addDeviceToList(item);
      }
    }
    await getSubNet();
    checkPortRange(subnet, 80, 80);
  }


  Future<String> getSubNet() async{
    subnet = wifiIP.substring(0, wifiIP.lastIndexOf('.'));
    print(subnet);
    return subnet;
  }

  void addDeviceToList(DeviceModel device){
    bool hasEntry = false;
    for(var i in listOfDevices)
    {
      if(i.ip == device.ip)
      {
        hasEntry = true;
        print('match');
        break;
      }
    }
    if(!hasEntry)
      listOfDevices.add(device);
  }

  void checkPortRange(String subnet, int fromPort, int toPort) {
    if (fromPort > toPort) {
      return;
    }

    print('port $fromPort');

    final stream = NetworkAnalyzer.discover2(subnet, fromPort);

    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        String i = addr.ip;
        print('Found device: ${addr.ip}:$fromPort');
        var item = DeviceModel(i, '','','','');
        addDeviceToList(item);
      }
    }).onDone(() {
      checkPortRange(subnet, fromPort + 1, toPort);
    });
  }

  void getIpBinary(String ip){
    String bin ='';
    List<String> sep = ip.split(".");
    for (final i in sep)
    {
      var binstring = i.codeUnits.map((x) => x.toRadixString(2).padLeft(8, '0')).join();
      bin += binstring;
    }
    print(bin);
  }

}