
import 'package:equatable/equatable.dart';

class DeviceModel extends Equatable{
  final String ip;
  final String rawAdress;
  final String interfaceName;
  final String type;
  final String isLoopback;

  DeviceModel(this.ip, this.rawAdress, this.interfaceName, this.type, this.isLoopback);

  @override
  List<Object> get props => [ip, rawAdress, interfaceName, type, isLoopback];
}


class ColumnsList{
  final List<String> columns = [
    'ip',
    'raw address',
    'interface name',
    'type',
    'isLoopback'
  ];
  List<String> get getColumns => columns;
}

