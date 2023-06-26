import 'dart:convert';

/// response_code : "1"
/// msg : "State List"
/// data : [{"id":"4","name":"Indore","created_at":"2023-06-23 13:16:13","updated_at":"2023-06-23 13:16:13"}]

class GetCityModel {

  GetCityModel getCitiesResponseModelFromJson(String str) => GetCityModel.fromJson(json.decode(str));

  String getCitiesResponseModelToJson(GetCityModel data) => json.encode(data.toJson());

  GetCityModel({
      String? responseCode, 
      String? msg, 
      List<GetCitiesDataNew>? data,}){
    _responseCode = responseCode;
    _msg = msg;
    _data = data;
}

  GetCityModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(GetCitiesDataNew.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _msg;
  List<GetCitiesDataNew>? _data;
GetCityModel copyWith({  String? responseCode,
  String? msg,
  List<GetCitiesDataNew>? data,
}) => GetCityModel(  responseCode: responseCode ?? _responseCode,
  msg: msg ?? _msg,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get msg => _msg;
  List<GetCitiesDataNew>? get data => _data;

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
/// name : "Indore"
/// created_at : "2023-06-23 13:16:13"
/// updated_at : "2023-06-23 13:16:13"

class GetCitiesDataNew {
  GetCitiesDataNew({
      String? id, 
      String? name, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _name = name;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  GetCitiesDataNew.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  String? _id;
  String? _name;
  String? _createdAt;
  String? _updatedAt;
GetCitiesDataNew copyWith({  String? id,
  String? name,
  String? createdAt,
  String? updatedAt,
}) => GetCitiesDataNew(  id: id ?? _id,
  name: name ?? _name,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get name => _name;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}