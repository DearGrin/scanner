import 'package:desktopscanner/lib/Bloc/scan_browser_bloc.dart';
import 'package:desktopscanner/lib/Models/device_model.dart';
import 'package:desktopscanner/lib/Models/finder_settings_model.dart';
import 'package:flutter/material.dart';


class ScanBrowserScreen extends StatefulWidget{

  final ScanBrowserBloc scanBrowserBloc = ScanBrowserBloc();
  @override
  State<StatefulWidget> createState() {
    return ScanBrowserScreenState();
  }
}

class ScanBrowserScreenState extends State<ScanBrowserScreen> {
  final FinderSettingsModel _finderSettingsForm = FinderSettingsModel();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<DeviceModel> selectedDevices;
  final ColumnsList _columnsList = ColumnsList();

  @override
  void initState() {
    scanBrowserBloc.lookForDevices(80, 80);
    selectedDevices = scanBrowserBloc.selectedDevices;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('Scanner'),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _showMyDialog,
                ),
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: deviceTable(),
              ),
            ),
          );
        }

  Widget deviceTable(){
    return StreamBuilder(
      stream: scanBrowserBloc.devices,
      builder: (context, AsyncSnapshot<List<DeviceModel>> snapshot){
        if(snapshot.hasData)
          {
            return DataTable(
              columns: _columnsList.getColumns.map((e) => DataColumn(label: Text(e)),).toList(),
              rows: deviceRows(snapshot),
            );
          }
        else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        else {
          return Text("No active devices found");
        }
      },
    );
  }

  List<DataRow> deviceRows(AsyncSnapshot<List<DeviceModel>> _deviceList){
    var list = _deviceList.data.map((deviceList) => DataRow(
      selected: selectedDevices.contains(deviceList),
      onSelectChanged: (b ) {_onSelectedRow(b, deviceList);},
      cells:
      [
        DataCell(Text(deviceList.ip)),
        DataCell(Text(deviceList.rawAdress)),
        DataCell(Text(deviceList.interfaceName)),
        DataCell(Text(deviceList.type)),
        DataCell(Text(deviceList.isLoopback)),
      ],
    ),
    ).toList();
    return list;
  }

  _onSelectedRow(bool isSelected, DeviceModel device){
    setState(() {
      if (isSelected) {
        scanBrowserBloc.selectDevice(device);
      } else {
        scanBrowserBloc.deselectDevice(device);
      }
    });
  }


  _showMyDialog(){
   scaffoldKey.currentState.showBottomSheet<void>(
         (BuildContext context) {
           return Container(
             height: 300,
             child: Card(
               child: Padding(
                 padding: EdgeInsets.only(
                     top: 24.0, bottom: 24.0, right: 32.0, left: 32.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text('Search Settings'),
                     TextField(
                       keyboardType: TextInputType.phone,
                       onChanged: (value) {_finderSettingsForm.fromPort = int.parse(value);},
                       decoration: InputDecoration(
                         hintText: 'From port'
                       ),
                     ),
                     TextField(
                       keyboardType: TextInputType.phone,
                       onChanged: (value) {_finderSettingsForm.toPort = int.parse(value);},
                       decoration: InputDecoration(
                         hintText: 'To port'
                       ),
                     ),
                     FlatButton(
                       color: Colors.green,
                       child: Text('Start search'),
                       onPressed: _onSubmitFinderSettings,
                     ),
                     FlatButton(
                       color: Colors.red,
                       child: Text('Close'),
                       onPressed: () {Navigator.of(context).pop();},
                     ),
                   ],
                 ),
               ),
             ),
           );
         });
  }

    void _onSubmitFinderSettings(){
    scanBrowserBloc.lookForDevices(_finderSettingsForm.fromPort, _finderSettingsForm.toPort);
    Navigator.of(context).pop();
    }
}
