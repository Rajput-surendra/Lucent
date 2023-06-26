import 'dart:convert';

/// response_code : "1"
/// msg : "City List"
/// data : [{"id":"4","name":"vijay nagar","state_id":"4","created_at":"2023-06-23 13:16:23","updated_at":"2023-06-23 13:16:23"}]

class GetAreaModel {
  GetAreaModel getCitiesResponseModelFromJson(String str) => GetAreaModel.fromJson(json.decode(str));

  String getCitiesResponseModelToJson(GetAreaModel data) => json.encode(data.toJson());

  GetAreaModel({
      String? responseCode, 
      String? msg, 
      List<GetPlacedData>? data,}){
    _responseCode = responseCode;
    _msg = msg;
    _data = data;
}

  GetAreaModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(GetPlacedData.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _msg;
  List<GetPlacedData>? _data;
GetAreaModel copyWith({  String? responseCode,
  String? msg,
  List<GetPlacedData>? data,
}) => GetAreaModel(  responseCode: responseCode ?? _responseCode,
  msg: msg ?? _msg,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get msg => _msg;
  List<GetPlacedData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "4"
/// name : "vijay nagar"
/// state_id : "4"
/// created_at : "2023-06-23 13:16:23"
/// updated_at : "2023-06-23 13:16:23"

class GetPlacedData {
  GetPlacedData({
      String? id, 
      String? name, 
      String? stateId, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _stateId = stateId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  GetPlacedData.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _stateId = json['state_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  String? _id;
  String? _name;
  String? _stateId;
  String? _createdAt;
  String? _updatedAt;
GetPlacedData copyWith({  String? id,
  String? name,
  String? stateId,
  String? createdAt,
  String? updatedAt,
}) => GetPlacedData(  id: id ?? _id,
  name: name ?? _name,
  stateId: stateId ?? _stateId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get name => _name;
  String? get stateId => _stateId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['state_id'] = _stateId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}