/// status : true
/// message : "Time slot List"
/// data : [{"id":"2","from_time":"07:00:00","to_time":"08:00:00","created_at":"2023-06-16 14:49:20","updated_at":"2023-06-22 10:14:49","slot":"07:00 AM To 08:00 AM"},{"id":"3","from_time":"08:00:00","to_time":"09:00:00","created_at":"2023-06-16 14:49:20","updated_at":"2023-06-22 10:14:49","slot":"08:00 AM To 09:00 AM"},{"id":"4","from_time":"09:00:00","to_time":"10:00:00","created_at":"2023-06-16 14:49:20","updated_at":"2023-06-22 10:15:08","slot":"09:00 AM To 10:00 AM"},{"id":"5","from_time":"10:00:00","to_time":"11:00:00","created_at":"2023-06-16 14:49:20","updated_at":"2023-06-22 10:15:08","slot":"10:00 AM To 11:00 AM"}]

class GetTimeModel {
  GetTimeModel({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  GetTimeModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Data>? _data;
GetTimeModel copyWith({  bool? status,
  String? message,
  List<Data>? data,
}) => GetTimeModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "2"
/// from_time : "07:00:00"
/// to_time : "08:00:00"
/// created_at : "2023-06-16 14:49:20"
/// updated_at : "2023-06-22 10:14:49"
/// slot : "07:00 AM To 08:00 AM"

class Data {
  Data({
      String? id, 
      String? fromTime, 
      String? toTime, 
      String? createdAt, 
      String? updatedAt, 
      String? slot,}){
    _id = id;
    _fromTime = fromTime;
    _toTime = toTime;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _slot = slot;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _fromTime = json['from_time'];
    _toTime = json['to_time'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _slot = json['slot'];
  }
  String? _id;
  String? _fromTime;
  String? _toTime;
  String? _createdAt;
  String? _updatedAt;
  String? _slot;
Data copyWith({  String? id,
  String? fromTime,
  String? toTime,
  String? createdAt,
  String? updatedAt,
  String? slot,
}) => Data(  id: id ?? _id,
  fromTime: fromTime ?? _fromTime,
  toTime: toTime ?? _toTime,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  slot: slot ?? _slot,
);
  String? get id => _id;
  String? get fromTime => _fromTime;
  String? get toTime => _toTime;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get slot => _slot;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['from_time'] = _fromTime;
    map['to_time'] = _toTime;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['slot'] = _slot;
    return map;
  }

}