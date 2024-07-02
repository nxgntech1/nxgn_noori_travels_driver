import 'dart:convert';

class RideModel {
  final String? success;
  final dynamic error;
  final String? message;
  final List<RideData>? data;

  RideModel({
    this.success,
    this.error,
    this.message,
    this.data,
  });

  factory RideModel.fromRawJson(String str) => RideModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RideModel.fromJson(Map<String, dynamic> json) => RideModel(
        success: json["success"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? [] : List<RideData>.from(json["data"]!.map((x) => RideData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RideData {
  final String? id;
  final String? idUserApp;
  final String? distanceUnit;
  final String? departName;
  final String? destinationName;
  final String? otp;
  final String? latitudeDepart;
  final String? longitudeDepart;
  final String? latitudeArrivee;
  final String? longitudeArrivee;
  final String? numberPoeple;
  final String? place;
  late final String? statut;
  final String? idConducteur;
  final String? creer;
  final String? trajet;
  final String? feelSafeDriver;
  final String? nom;
  final String? prenom;
  final int? existingUserId;
  final String? distance;
  final String? rideType;
  final String? phone;
  final String? photoPath;
  final String? nomConducteur;
  final String? prenomConducteur;
  final String? driverPhone;
  final String? dateRetour;
  final String? heureRetour;
  final String? statutRound;
  final String? montant;
  final String? duree;
  final String? userId;
  final String? statutPaiement;
  final String? payment;
  final String? paymentImage;
  final String? tripObjective;
  final String? ageChildren1;
  final String? ageChildren2;
  final String? ageChildren3;
  final dynamic stops;
  final dynamic tax;
  final String? tipAmount;
  final String? discount;
  final String? adminCommission;
  final dynamic userInfo;
  final int? vehicleId;
  final String? bookforOthersMobileno;
  final String? bookforOthersName;
  final String? bookingtype;
  final String? rideRequiredOnDate;
  final String? rideRequiredOnTime;
  final String? odometerStartReading;
  final String? odometerEndReading;
  final String? consumerName;
  final String? drivername;
  final String? RideDataDriverPhone;
  final String? moyenne;
  final String? moyenneDriver;
  final String? idVehicule;
  final String? brand;
  final String? model;
  final String? color;
  final String? numberplate;
  final String? vehicleImage;

  RideData({
    this.id,
    this.idUserApp,
    this.distanceUnit,
    this.departName,
    this.destinationName,
    this.otp,
    this.latitudeDepart,
    this.longitudeDepart,
    this.latitudeArrivee,
    this.longitudeArrivee,
    this.numberPoeple,
    this.place,
    this.statut,
    this.idConducteur,
    this.creer,
    this.trajet,
    this.feelSafeDriver,
    this.nom,
    this.prenom,
    this.existingUserId,
    this.distance,
    this.rideType,
    this.phone,
    this.photoPath,
    this.nomConducteur,
    this.prenomConducteur,
    this.driverPhone,
    this.dateRetour,
    this.heureRetour,
    this.statutRound,
    this.montant,
    this.duree,
    this.userId,
    this.statutPaiement,
    this.payment,
    this.paymentImage,
    this.tripObjective,
    this.ageChildren1,
    this.ageChildren2,
    this.ageChildren3,
    this.stops,
    this.tax,
    this.tipAmount,
    this.discount,
    this.adminCommission,
    this.userInfo,
    this.vehicleId,
    this.bookforOthersMobileno,
    this.bookforOthersName,
    this.bookingtype,
    this.rideRequiredOnDate,
    this.rideRequiredOnTime,
    this.odometerStartReading,
    this.odometerEndReading,
    this.consumerName,
    this.drivername,
    this.RideDataDriverPhone,
    this.moyenne,
    this.moyenneDriver,
    this.idVehicule,
    this.brand,
    this.model,
    this.color,
    this.numberplate,
    this.vehicleImage,
  });

  factory RideData.fromRawJson(String str) => RideData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RideData.fromJson(Map<String, dynamic> json) => RideData(
        id: json["id"],
        idUserApp: json["id_user_app"],
        distanceUnit: json["distance_unit"],
        departName: json["depart_name"],
        destinationName: json["destination_name"],
        otp: json["otp"],
        latitudeDepart: json["latitude_depart"],
        longitudeDepart: json["longitude_depart"],
        latitudeArrivee: json["latitude_arrivee"],
        longitudeArrivee: json["longitude_arrivee"],
        numberPoeple: json["number_poeple"],
        place: json["place"],
        statut: json["statut"],
        idConducteur: json["id_conducteur"],
        creer: json["creer"],
        trajet: json["trajet"],
        feelSafeDriver: json["feel_safe_driver"],
        nom: json["nom"],
        prenom: json["prenom"],
        existingUserId: json["existing_user_id"],
        distance: json["distance"],
        rideType: json["ride_type"],
        phone: json["phone"],
        photoPath: json["photo_path"],
        nomConducteur: json["nomConducteur"],
        prenomConducteur: json["prenomConducteur"],
        driverPhone: json["driverPhone"],
        dateRetour: json["date_retour"],
        heureRetour: json["heure_retour"],
        statutRound: json["statut_round"],
        montant: json["montant"],
        duree: json["duree"],
        userId: json["userId"],
        statutPaiement: json["statut_paiement"],
        payment: json["payment"],
        paymentImage: json["payment_image"],
        tripObjective: json["trip_objective"],
        ageChildren1: json["age_children1"],
        ageChildren2: json["age_children2"],
        ageChildren3: json["age_children3"],
        stops: json["stops"],
        tax: json["tax"],
        tipAmount: json["tip_amount"],
        discount: json["discount"],
        adminCommission: json["admin_commission"],
        userInfo: json["user_info"],
        vehicleId: json["vehicle_id"],
        bookforOthersMobileno: json["bookfor_others_mobileno"],
        bookforOthersName: json["bookfor_others_name"],
        bookingtype: json["bookingtype"],
        rideRequiredOnDate: json["ride_required_on_date"],
        rideRequiredOnTime: json["ride_required_on_time"],
        odometerStartReading: json["odometer_start_reading"],
        odometerEndReading: json["odometer_end_reading"],
        consumerName: json["consumer_name"],
        drivername: json["drivername"],
        RideDataDriverPhone: json["driver_phone"],
        moyenne: json["moyenne"],
        moyenneDriver: json["moyenne_driver"],
        idVehicule: json["idVehicule"],
        brand: json["brand"],
        model: json["model"],
        color: json["color"],
        numberplate: json["numberplate"],
        vehicleImage: json["vehicle_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user_app": idUserApp,
        "distance_unit": distanceUnit,
        "depart_name": departName,
        "destination_name": destinationName,
        "otp": otp,
        "latitude_depart": latitudeDepart,
        "longitude_depart": longitudeDepart,
        "latitude_arrivee": latitudeArrivee,
        "longitude_arrivee": longitudeArrivee,
        "number_poeple": numberPoeple,
        "place": place,
        "statut": statut,
        "id_conducteur": idConducteur,
        "creer": creer,
        "trajet": trajet,
        "feel_safe_driver": feelSafeDriver,
        "nom": nom,
        "prenom": prenom,
        "existing_user_id": existingUserId,
        "distance": distance,
        "ride_type": rideType,
        "phone": phone,
        "photo_path": photoPath,
        "nomConducteur": nomConducteur,
        "prenomConducteur": prenomConducteur,
        "driverPhone": driverPhone,
        "date_retour": dateRetour,
        "heure_retour": heureRetour,
        "statut_round": statutRound,
        "montant": montant,
        "duree": duree,
        "userId": userId,
        "statut_paiement": statutPaiement,
        "payment": payment,
        "payment_image": paymentImage,
        "trip_objective": tripObjective,
        "age_children1": ageChildren1,
        "age_children2": ageChildren2,
        "age_children3": ageChildren3,
        "stops": stops,
        "tax": tax,
        "tip_amount": tipAmount,
        "discount": discount,
        "admin_commission": adminCommission,
        "user_info": userInfo,
        "vehicle_id": vehicleId,
        "bookfor_others_mobileno": bookforOthersMobileno,
        "bookfor_others_name": bookforOthersName,
        "bookingtype": bookingtype,
        "ride_required_on_date": rideRequiredOnDate,
        "ride_required_on_time": rideRequiredOnTime,
        "odometer_start_reading": odometerStartReading,
        "odometer_end_reading": odometerEndReading,
        "consumer_name": consumerName,
        "drivername": drivername,
        "driver_phone": RideDataDriverPhone,
        "moyenne": moyenne,
        "moyenne_driver": moyenneDriver,
        "idVehicule": idVehicule,
        "brand": brand,
        "model": model,
        "color": color,
        "numberplate": numberplate,
        "vehicle_image": vehicleImage,
      };
}

class Stops {
  String? latitude;
  String? location;
  String? longitude;

  Stops({this.latitude, this.location, this.longitude});

  Stops.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'].toString();
    location = json['location'].toString();
    longitude = json['longitude'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['location'] = location;
    data['longitude'] = longitude;
    return data;
  }
}

class UserInfo {
  String? name;
  String? email;
  String? phone;

  UserInfo({this.name, this.email, this.phone});

  UserInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
