import 'package:doctorhub_dashboard/features/clinics/domain/entities/clinic_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.address,
    required super.city,
    required super.governorate,
    required super.latitude,
    required super.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'] as String,
      city: json['city'] as String,
      governorate: json['governorate'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'address': address,
    'city': city,
    'governorate': governorate,
    'latitude': latitude,
    'longitude': longitude,
  };
}

class ClinicModel extends ClinicEntity {
  const ClinicModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.email,
    required super.location,
    required super.galleryUrls,
    required super.acceptedInsurance,
    required super.workingHours,
    required super.totalDoctors,
    required super.rating,
    super.isActive = true,
  });

  factory ClinicModel.fromEntity(ClinicEntity entity) {
    return ClinicModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      email: entity.email,
      location: entity.location,
      galleryUrls: entity.galleryUrls,
      acceptedInsurance: entity.acceptedInsurance,
      workingHours: entity.workingHours,
      totalDoctors: entity.totalDoctors,
      rating: entity.rating,
      isActive: entity.isActive,
    );
  }

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      location: LocationModel.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      galleryUrls:
          (json['galleryUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      acceptedInsurance:
          (json['acceptedInsurance'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      workingHours: json['workingHours'] as String,
      totalDoctors: json['totalDoctors'] as int,
      rating: (json['rating'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'location':
        (location is LocationModel
                ? location as LocationModel
                : LocationModel(
                    address: location.address,
                    city: location.city,
                    governorate: location.governorate,
                    latitude: location.latitude,
                    longitude: location.longitude,
                  ))
            .toJson(),
    'galleryUrls': galleryUrls,
    'acceptedInsurance': acceptedInsurance,
    'workingHours': workingHours,
    'totalDoctors': totalDoctors,
    'rating': rating,
    'isActive': isActive,
  };
}
