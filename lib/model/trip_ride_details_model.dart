import 'dart:convert';

import 'package:intl/intl.dart';

class SingleRideDetailsModel {
  final String? success;
  final dynamic error;
  final String? message;
  final List<SingleRideData>? data;

  SingleRideDetailsModel({
    this.success,
    this.error,
    this.message,
    this.data,
  });

  factory SingleRideDetailsModel.fromRawJson(String str) => SingleRideDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SingleRideDetailsModel.fromJson(Map<String, dynamic> json) => SingleRideDetailsModel(
        success: json["success"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? [] : List<SingleRideData>.from(json["data"]!.map((x) => SingleRideData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SingleRideData {
  final String? id;
  final dynamic rideType;
  final String? idUserApp;
  final String? departName;
  final String? distanceUnit;
  final String? destinationName;
  final String? latitudeDepart;
  final String? longitudeDepart;
  final String? latitudeArrivee;
  final String? longitudeArrivee;
  final String? numberPoeple;
  final String? place;
  final String? statut;
  final dynamic idConducteur;
  final DateTime? creer;
  final String? trajet;
  final String? tripObjective;
  final String? tripCategory;
  final List<Tax>? tax;
  final String? discount;
  final String? tipAmount;
  final String? montant;
  final String? adminCommission;
  final String? nom;
  final String? prenom;
  final String? otp;
  final String? distance;
  final String? phone;
  final dynamic userphoto;
  final dynamic dateRetour;
  final String? heureRetour;
  final String? statutRound;
  final String? duree;
  final String? statutPaiement;
  final String? carPrice;
  final String? subTotal;
  final String? bookingtype;
  final int? bookingTypeId;
  final String? rideRequiredOnDate;
  final String? rideRequiredOnTime;
  final String? taxAmount;
  final String? bookforOthersMobileno;
  final String? bookforOthersName;
  final dynamic vehicleId;
  final String? carmodel;
  final String? brandname;
  final String? payment;
  final String? paymentImage;
  final String? paymentmethodid;
  final List<Addon>? addon;
  final String? brand;
  final String? model;
  final DateTime? bookigDate;
  final String? bookingTime;
  final String? paymentmethod;
  final String? idVehicule;
  final String? carMake;
  final String? milage;
  final String? km;
  final String? color;
  final String? numberplate;
  final String? passenger;
  final String? vehicleImageid;
  final String? nomConducteur;
  final String? driverPhone;
  final String? driverphoto;
  final String? drivername;
  final String? consumerName;

  SingleRideData({
    this.id,
    this.rideType,
    this.idUserApp,
    this.departName,
    this.distanceUnit,
    this.destinationName,
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
    this.tripObjective,
    this.tripCategory,
    this.tax,
    this.discount,
    this.tipAmount,
    this.montant,
    this.adminCommission,
    this.nom,
    this.prenom,
    this.otp,
    this.distance,
    this.phone,
    this.userphoto,
    this.dateRetour,
    this.heureRetour,
    this.statutRound,
    this.duree,
    this.statutPaiement,
    this.carPrice,
    this.subTotal,
    this.bookingtype,
    this.bookingTypeId,
    this.rideRequiredOnDate,
    this.rideRequiredOnTime,
    this.taxAmount,
    this.bookforOthersMobileno,
    this.bookforOthersName,
    this.vehicleId,
    this.carmodel,
    this.brandname,
    this.payment,
    this.paymentImage,
    this.paymentmethodid,
    this.addon,
    this.brand,
    this.model,
    this.bookigDate,
    this.bookingTime,
    this.paymentmethod,
    this.idVehicule,
    this.carMake,
    this.milage,
    this.km,
    this.color,
    this.numberplate,
    this.passenger,
    this.vehicleImageid,
    this.nomConducteur,
    this.driverPhone,
    this.drivername,
    this.driverphoto,
    this.consumerName,
  });

  factory SingleRideData.fromRawJson(String str) => SingleRideData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SingleRideData.fromJson(Map<String, dynamic> json) => SingleRideData(
        id: json["id"],
        rideType: json["ride_type"],
        idUserApp: json["id_user_app"],
        departName: json["depart_name"],
        distanceUnit: json["distance_unit"],
        destinationName: json["destination_name"],
        latitudeDepart: json["latitude_depart"],
        longitudeDepart: json["longitude_depart"],
        latitudeArrivee: json["latitude_arrivee"],
        longitudeArrivee: json["longitude_arrivee"],
        numberPoeple: json["number_poeple"],
        place: json["place"],
        statut: json["statut"],
        idConducteur: json["id_conducteur"],
        creer: json["creer"] == null ? null : DateTime.parse(json["creer"]),
        trajet: json["trajet"],
        tripObjective: json["trip_objective"],
        tripCategory: json["trip_category"],
        tax: json["tax"] == null ? [] : List<Tax>.from(json["tax"]!.map((x) => Tax.fromJson(x))),
        discount: json["discount"],
        tipAmount: json["tip_amount"],
        montant: json["montant"],
        adminCommission: json["admin_commission"],
        nom: json["nom"],
        prenom: json["prenom"],
        otp: json["otp"],
        distance: json["distance"],
        phone: json["phone"],
        userphoto: json["userphoto"],
        dateRetour: json["date_retour"],
        heureRetour: json["heure_retour"],
        statutRound: json["statut_round"],
        duree: json["duree"],
        statutPaiement: json["statut_paiement"],
        carPrice: json["car_Price"],
        subTotal: json["sub_total"],
        bookingtype: json["bookingtype"],
        bookingTypeId: json["booking_type_id"],
        rideRequiredOnDate: json["ride_required_on_date"],
        // rideRequiredOnDate: json["ride_required_on_date"] == null ? null : DateFormat('dd MMM, yyyy hh:mm a').parse(json["ride_required_on_date"]),
        rideRequiredOnTime: json["ride_required_on_time"],
        taxAmount: json["tax_amount"],
        bookforOthersMobileno: json["bookfor_others_mobileno"],
        bookforOthersName: json["bookfor_others_name"],
        vehicleId: json["vehicle_Id"],
        carmodel: json["carmodel"],
        brandname: json["brandname"],
        payment: json["payment"],
        paymentImage: json["payment_image"],
        paymentmethodid: json["paymentmethodid"],
        addon: json["addon"] == null ? [] : List<Addon>.from(json["addon"]!.map((x) => Addon.fromJson(x))),
        brand: json["brand"],
        model: json["model"],
        bookigDate: json["BookigDate"] == null ? null : DateFormat('dd MMM, yyyy hh:mm a').parse(json["BookigDate"]),
        // bookigDate: json["BookigDate"],
        bookingTime: json["BookingTime"],
        paymentmethod: json["paymentmethod"],
        idVehicule: json["idVehicule"],
        carMake: json["car_make"],
        milage: json["milage"],
        km: json["km"],
        color: json["color"],
        numberplate: json["numberplate"],
        passenger: json["passenger"],
        vehicleImageid: json["vehicle_imageid"],
        nomConducteur: json["nomConducteur"],
        driverPhone: json["driver_phone"],
        driverphoto: json["driverphoto"],
        drivername: json["drivername"],
        consumerName: json["consumer_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ride_type": rideType,
        "id_user_app": idUserApp,
        "depart_name": departName,
        "distance_unit": distanceUnit,
        "destination_name": destinationName,
        "latitude_depart": latitudeDepart,
        "longitude_depart": longitudeDepart,
        "latitude_arrivee": latitudeArrivee,
        "longitude_arrivee": longitudeArrivee,
        "number_poeple": numberPoeple,
        "place": place,
        "statut": statut,
        "id_conducteur": idConducteur,
        "creer": creer?.toIso8601String(),
        "trajet": trajet,
        "trip_objective": tripObjective,
        "trip_category": tripCategory,
        "tax": tax == null ? [] : List<dynamic>.from(tax!.map((x) => x.toJson())),
        "discount": discount,
        "tip_amount": tipAmount,
        "montant": montant,
        "admin_commission": adminCommission,
        "nom": nom,
        "prenom": prenom,
        "otp": otp,
        "distance": distance,
        "phone": phone,
        "userphoto": userphoto,
        "date_retour": dateRetour,
        "heure_retour": heureRetour,
        "statut_round": statutRound,
        "duree": duree,
        "statut_paiement": statutPaiement,
        "car_Price": carPrice,
        "sub_total": subTotal,
        "bookingtype": bookingtype,
        "booking_type_id": bookingTypeId,
        "ride_required_on_date": rideRequiredOnDate,
        "ride_required_on_time": rideRequiredOnTime,
        "tax_amount": taxAmount,
        "bookfor_others_mobileno": bookforOthersMobileno,
        "bookfor_others_name": bookforOthersName,
        "vehicle_Id": vehicleId,
        "carmodel": carmodel,
        "brandname": brandname,
        "payment": payment,
        "payment_image": paymentImage,
        "paymentmethodid": paymentmethodid,
        "addon": addon == null ? [] : List<dynamic>.from(addon!.map((x) => x.toJson())),
        "brand": brand,
        "model": model,
        "BookigDate": bookigDate?.toIso8601String(),
        "BookingTime": bookingTime,
        "paymentmethod": paymentmethod,
        "idVehicule": idVehicule,
        "car_make": carMake,
        "milage": milage,
        "km": km,
        "color": color,
        "numberplate": numberplate,
        "passenger": passenger,
        "vehicle_imageid": vehicleImageid,
        "nomConducteur": nomConducteur,
        "driver_phone": driverPhone,
        "driverphoto": driverphoto,
        "drivername": drivername,
        "consumer_name": consumerName,
      };
}

class Addon {
  final int? id;
  final int? bookingid;
  final int? addonid;
  final String? totalTax;
  final String? addonTotalAmount;
  final String? paymentStatus;
  final dynamic createdon;
  final String? transactionId;
  final String? addOnLabel;
  final String? packagePrice;
  final List<Tax>? taxes;

  Addon({
    this.id,
    this.bookingid,
    this.addonid,
    this.totalTax,
    this.addonTotalAmount,
    this.paymentStatus,
    this.createdon,
    this.transactionId,
    this.addOnLabel,
    this.packagePrice,
    this.taxes,
  });

  factory Addon.fromRawJson(String str) => Addon.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
        id: json["id"],
        bookingid: json["bookingid"],
        addonid: json["addonid"],
        totalTax: json["total_tax"],
        addonTotalAmount: json["addon_total_amount"],
        paymentStatus: json["payment_status"],
        createdon: json["createdon"],
        transactionId: json["transaction_id"],
        addOnLabel: json["add_on_label"],
        packagePrice: json["package_price"],
        taxes: json["taxes"] == null ? [] : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bookingid": bookingid,
        "addonid": addonid,
        "total_tax": totalTax,
        "addon_total_amount": addonTotalAmount,
        "payment_status": paymentStatus,
        "createdon": createdon,
        "transaction_id": transactionId,
        "add_on_label": addOnLabel,
        "package_price": packagePrice,
        "taxes": taxes == null ? [] : List<dynamic>.from(taxes!.map((x) => x.toJson())),
      };
}

class Tax {
  final String? taxType;
  final String? taxlabel;
  final String? tax;
  final String? rideTaxAmount;

  Tax({
    this.taxType,
    this.taxlabel,
    this.tax,
    this.rideTaxAmount,
  });

  factory Tax.fromRawJson(String str) => Tax.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        taxType: json["tax_type"],
        taxlabel: json["taxlabel"],
        tax: json["tax"],
        rideTaxAmount: json["ride_tax_amount"],
      );

  Map<String, dynamic> toJson() => {
        "tax_type": taxType,
        "taxlabel": taxlabel,
        "tax": tax,
        "ride_tax_amount": rideTaxAmount,
      };
}

enum TaxType { FIXED, PERCENTAGE }

final taxTypeValues = EnumValues({"Fixed": TaxType.FIXED, "Percentage": TaxType.PERCENTAGE});

enum Taxlabel { CGST, IGST, N_TAX }

final taxlabelValues = EnumValues({"CGST": Taxlabel.CGST, "IGST": Taxlabel.IGST, "NTax": Taxlabel.N_TAX});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
