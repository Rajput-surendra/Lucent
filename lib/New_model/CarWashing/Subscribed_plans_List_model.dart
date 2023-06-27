/// status : true
/// message : "Plan purchased successfully"
/// data : [{"title":"Premium Plan","id":"84","user_id":"164","plan_id":"26","transaction_id":"rzp_test_1DP5mmOlF5G5ag","amount":"900.00","name":"ftvtg","block":"ggybyb","flot":"ybybbyby","society":"Indore","mobile":"5598595995","address":"vijay nagar Indore","lat":null,"lng":null,"status":"0","time_slot":"08:00 AM To 09:00 AM","model":"ybybybby","vehicle_number":"yyybyby","parking":"hbbbyybhby","landmark":"byyhububbu","coupon_code":"","subtotal":"1000.00","discount":"100.00","end_date":"27 Sep, 2023","created_at":"27 Jun, 2023","time":"3","type":"2","start_date":"28 Jun, 2023"},{"title":"Gold Plan","id":"85","user_id":"164","plan_id":"27","transaction_id":"rzp_test_1DP5mmOlF5G5ag","amount":"900.00","name":"ththth","block":"grrtth","flot":"fvfvdfvfv","society":"Indore","mobile":"2659595959","address":"vijay nagar Indore","lat":null,"lng":null,"status":"0","time_slot":"07:00 AM To 08:00 AM","model":"rgfghr","vehicle_number":"rgfhth","parking":"gerggr","landmark":"efgebffbhrr","coupon_code":"WELCOME20","subtotal":"1000.00","discount":"100.00","end_date":"25 Jul, 2023","created_at":"27 Jun, 2023","time":"28","type":"1","start_date":"28 Jun, 2023"},{"title":"Gold Plan","id":"86","user_id":"164","plan_id":"27","transaction_id":" rzp_test_1DP5mmOlF5G5ag","amount":"900.00","name":" ththth","block":" grrtth,","flot":" fvfvdfvfv","society":" Indore","mobile":" 2659595959","address":" vijay nagar Indore","lat":null,"lng":null,"status":"0","time_slot":" 07:00 AM To 08:00 AM","model":" rgfghr","vehicle_number":" rgfhth","parking":" gerggr,","landmark":" efgebffbhrr","coupon_code":" WELCOME20","subtotal":"1000.00","discount":"100.00","end_date":"25 Jul, 2023","created_at":"27 Jun, 2023","time":"28","type":"1","start_date":"28 Jun, 2023"}]

class SubscribedPlansListModel {
  SubscribedPlansListModel({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  SubscribedPlansListModel.fromJson(dynamic json) {
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
SubscribedPlansListModel copyWith({  bool? status,
  String? message,
  List<Data>? data,
}) => SubscribedPlansListModel(  status: status ?? _status,
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

/// title : "Premium Plan"
/// id : "84"
/// user_id : "164"
/// plan_id : "26"
/// transaction_id : "rzp_test_1DP5mmOlF5G5ag"
/// amount : "900.00"
/// name : "ftvtg"
/// block : "ggybyb"
/// flot : "ybybbyby"
/// society : "Indore"
/// mobile : "5598595995"
/// address : "vijay nagar Indore"
/// lat : null
/// lng : null
/// status : "0"
/// time_slot : "08:00 AM To 09:00 AM"
/// model : "ybybybby"
/// vehicle_number : "yyybyby"
/// parking : "hbbbyybhby"
/// landmark : "byyhububbu"
/// coupon_code : ""
/// subtotal : "1000.00"
/// discount : "100.00"
/// end_date : "27 Sep, 2023"
/// created_at : "27 Jun, 2023"
/// time : "3"
/// type : "2"
/// start_date : "28 Jun, 2023"

class Data {
  Data({
      String? title, 
      String? id, 
      String? userId, 
      String? planId, 
      String? transactionId, 
      String? amount, 
      String? name, 
      String? block, 
      String? flot, 
      String? society, 
      String? mobile, 
      String? address, 
      dynamic lat, 
      dynamic lng, 
      String? status, 
      String? timeSlot, 
      String? model, 
      String? vehicleNumber, 
      String? parking, 
      String? landmark, 
      String? couponCode, 
      String? subtotal, 
      String? discount, 
      String? endDate, 
      String? createdAt, 
      String? time, 
      String? type, 
      String? startDate,}){
    _title = title;
    _id = id;
    _userId = userId;
    _planId = planId;
    _transactionId = transactionId;
    _amount = amount;
    _name = name;
    _block = block;
    _flot = flot;
    _society = society;
    _mobile = mobile;
    _address = address;
    _lat = lat;
    _lng = lng;
    _status = status;
    _timeSlot = timeSlot;
    _model = model;
    _vehicleNumber = vehicleNumber;
    _parking = parking;
    _landmark = landmark;
    _couponCode = couponCode;
    _subtotal = subtotal;
    _discount = discount;
    _endDate = endDate;
    _createdAt = createdAt;
    _time = time;
    _type = type;
    _startDate = startDate;
}

  Data.fromJson(dynamic json) {
    _title = json['title'];
    _id = json['id'];
    _userId = json['user_id'];
    _planId = json['plan_id'];
    _transactionId = json['transaction_id'];
    _amount = json['amount'];
    _name = json['name'];
    _block = json['block'];
    _flot = json['flot'];
    _society = json['society'];
    _mobile = json['mobile'];
    _address = json['address'];
    _lat = json['lat'];
    _lng = json['lng'];
    _status = json['status'];
    _timeSlot = json['time_slot'];
    _model = json['model'];
    _vehicleNumber = json['vehicle_number'];
    _parking = json['parking'];
    _landmark = json['landmark'];
    _couponCode = json['coupon_code'];
    _subtotal = json['subtotal'];
    _discount = json['discount'];
    _endDate = json['end_date'];
    _createdAt = json['created_at'];
    _time = json['time'];
    _type = json['type'];
    _startDate = json['start_date'];
  }
  String? _title;
  String? _id;
  String? _userId;
  String? _planId;
  String? _transactionId;
  String? _amount;
  String? _name;
  String? _block;
  String? _flot;
  String? _society;
  String? _mobile;
  String? _address;
  dynamic _lat;
  dynamic _lng;
  String? _status;
  String? _timeSlot;
  String? _model;
  String? _vehicleNumber;
  String? _parking;
  String? _landmark;
  String? _couponCode;
  String? _subtotal;
  String? _discount;
  String? _endDate;
  String? _createdAt;
  String? _time;
  String? _type;
  String? _startDate;
Data copyWith({  String? title,
  String? id,
  String? userId,
  String? planId,
  String? transactionId,
  String? amount,
  String? name,
  String? block,
  String? flot,
  String? society,
  String? mobile,
  String? address,
  dynamic lat,
  dynamic lng,
  String? status,
  String? timeSlot,
  String? model,
  String? vehicleNumber,
  String? parking,
  String? landmark,
  String? couponCode,
  String? subtotal,
  String? discount,
  String? endDate,
  String? createdAt,
  String? time,
  String? type,
  String? startDate,
}) => Data(  title: title ?? _title,
  id: id ?? _id,
  userId: userId ?? _userId,
  planId: planId ?? _planId,
  transactionId: transactionId ?? _transactionId,
  amount: amount ?? _amount,
  name: name ?? _name,
  block: block ?? _block,
  flot: flot ?? _flot,
  society: society ?? _society,
  mobile: mobile ?? _mobile,
  address: address ?? _address,
  lat: lat ?? _lat,
  lng: lng ?? _lng,
  status: status ?? _status,
  timeSlot: timeSlot ?? _timeSlot,
  model: model ?? _model,
  vehicleNumber: vehicleNumber ?? _vehicleNumber,
  parking: parking ?? _parking,
  landmark: landmark ?? _landmark,
  couponCode: couponCode ?? _couponCode,
  subtotal: subtotal ?? _subtotal,
  discount: discount ?? _discount,
  endDate: endDate ?? _endDate,
  createdAt: createdAt ?? _createdAt,
  time: time ?? _time,
  type: type ?? _type,
  startDate: startDate ?? _startDate,
);
  String? get title => _title;
  String? get id => _id;
  String? get userId => _userId;
  String? get planId => _planId;
  String? get transactionId => _transactionId;
  String? get amount => _amount;
  String? get name => _name;
  String? get block => _block;
  String? get flot => _flot;
  String? get society => _society;
  String? get mobile => _mobile;
  String? get address => _address;
  dynamic get lat => _lat;
  dynamic get lng => _lng;
  String? get status => _status;
  String? get timeSlot => _timeSlot;
  String? get model => _model;
  String? get vehicleNumber => _vehicleNumber;
  String? get parking => _parking;
  String? get landmark => _landmark;
  String? get couponCode => _couponCode;
  String? get subtotal => _subtotal;
  String? get discount => _discount;
  String? get endDate => _endDate;
  String? get createdAt => _createdAt;
  String? get time => _time;
  String? get type => _type;
  String? get startDate => _startDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['id'] = _id;
    map['user_id'] = _userId;
    map['plan_id'] = _planId;
    map['transaction_id'] = _transactionId;
    map['amount'] = _amount;
    map['name'] = _name;
    map['block'] = _block;
    map['flot'] = _flot;
    map['society'] = _society;
    map['mobile'] = _mobile;
    map['address'] = _address;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['status'] = _status;
    map['time_slot'] = _timeSlot;
    map['model'] = _model;
    map['vehicle_number'] = _vehicleNumber;
    map['parking'] = _parking;
    map['landmark'] = _landmark;
    map['coupon_code'] = _couponCode;
    map['subtotal'] = _subtotal;
    map['discount'] = _discount;
    map['end_date'] = _endDate;
    map['created_at'] = _createdAt;
    map['time'] = _time;
    map['type'] = _type;
    map['start_date'] = _startDate;
    return map;
  }

}