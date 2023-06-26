/// status : true
/// message : "Subscription List"
/// data : [{"id":"18","type":"1","time":"28","amount":"999.00","vehicle_type":"Car","created_at":"2023-06-22 10:53:07","updated_at":"2023-06-22 10:53:07","plan_id":"13","title":"Gold Plan","time_text":"28 Days","is_purchased":false},{"id":"19","type":"1","time":"28","amount":"299.00","vehicle_type":"Car + Bike","created_at":"2023-06-22 10:53:17","updated_at":"2023-06-22 10:53:17","plan_id":"14","title":"Platinum Plan 1","time_text":"28 Days","is_purchased":false},{"id":"20","type":"2","time":"3","amount":"599.00","vehicle_type":"Car + Bike","created_at":"2023-06-22 10:53:17","updated_at":"2023-06-22 10:53:17","plan_id":"14","title":"Platinum Plan 2","time_text":"3 Months","is_purchased":false},{"id":"21","type":"2","time":"232","amount":"124.00","vehicle_type":"Car","created_at":"2023-06-22 11:48:54","updated_at":"2023-06-22 11:48:54","plan_id":"15","title":" Super Platinum","time_text":"232 Months","is_purchased":false},{"id":"23","type":"3","time":"1","amount":"555.00","vehicle_type":"Car","created_at":"2023-06-22 12:17:48","updated_at":"2023-06-22 12:17:48","plan_id":"15","title":"Platinum plaza Tewst","time_text":"1 Year","is_purchased":false}]

class GetSubscriptionPlansModel {
  GetSubscriptionPlansModel({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  GetSubscriptionPlansModel.fromJson(dynamic json) {
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
GetSubscriptionPlansModel copyWith({  bool? status,
  String? message,
  List<Data>? data,
}) => GetSubscriptionPlansModel(  status: status ?? _status,
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

/// id : "18"
/// type : "1"
/// time : "28"
/// amount : "999.00"
/// vehicle_type : "Car"
/// created_at : "2023-06-22 10:53:07"
/// updated_at : "2023-06-22 10:53:07"
/// plan_id : "13"
/// title : "Gold Plan"
/// time_text : "28 Days"
/// is_purchased : false

class Data {
  Data({
      String? id, 
      String? type, 
      String? time, 
      String? amount, 
      String? vehicleType, 
      String? createdAt, 
      String? updatedAt, 
      String? planId, 
      String? title, 
      String? timeText, 
      bool? isPurchased,}){
    _id = id;
    _type = type;
    _time = time;
    _amount = amount;
    _vehicleType = vehicleType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _planId = planId;
    _title = title;
    _timeText = timeText;
    _isPurchased = isPurchased;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _time = json['time'];
    _amount = json['amount'];
    _vehicleType = json['vehicle_type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _planId = json['plan_id'];
    _title = json['title'];
    _timeText = json['time_text'];
    _isPurchased = json['is_purchased'];
  }
  String? _id;
  String? _type;
  String? _time;
  String? _amount;
  String? _vehicleType;
  String? _createdAt;
  String? _updatedAt;
  String? _planId;
  String? _title;
  String? _timeText;
  bool? _isPurchased;
Data copyWith({  String? id,
  String? type,
  String? time,
  String? amount,
  String? vehicleType,
  String? createdAt,
  String? updatedAt,
  String? planId,
  String? title,
  String? timeText,
  bool? isPurchased,
}) => Data(  id: id ?? _id,
  type: type ?? _type,
  time: time ?? _time,
  amount: amount ?? _amount,
  vehicleType: vehicleType ?? _vehicleType,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  planId: planId ?? _planId,
  title: title ?? _title,
  timeText: timeText ?? _timeText,
  isPurchased: isPurchased ?? _isPurchased,
);
  String? get id => _id;
  String? get type => _type;
  String? get time => _time;
  String? get amount => _amount;
  String? get vehicleType => _vehicleType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get planId => _planId;
  String? get title => _title;
  String? get timeText => _timeText;
  bool? get isPurchased => _isPurchased;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['time'] = _time;
    map['amount'] = _amount;
    map['vehicle_type'] = _vehicleType;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['plan_id'] = _planId;
    map['title'] = _title;
    map['time_text'] = _timeText;
    map['is_purchased'] = _isPurchased;
    return map;
  }

}