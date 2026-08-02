import 'package:equatable/equatable.dart';

// ─── Location ──────────────────────────────────────────────────────────────────

/// Represents a physical address with GPS coordinates.
///
/// Used by [ClinicEntity] to describe the clinic's geographic location.
class LocationEntity extends Equatable {
  final String address;
  final String city;
  final String governorate;
  final double latitude;
  final double longitude;

  const LocationEntity({
    required this.address,
    required this.city,
    required this.governorate,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [address, city, governorate, latitude, longitude];
}

// ─── Clinic ────────────────────────────────────────────────────────────────────

/// Represents a medical clinic or hospital branch in the DoctorHub system.
///
/// Contains contact details, location, accepted insurance plans,
/// and doctor counts. Extends [Equatable] for value-based equality.
class ClinicEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String email;
  final LocationEntity location;
  final List<String> galleryUrls;
  final List<String> acceptedInsurance;
  final String workingHours;
  final int totalDoctors;
  final double rating;
  final bool isActive;

  const ClinicEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.location,
    required this.galleryUrls,
    required this.acceptedInsurance,
    required this.workingHours,
    required this.totalDoctors,
    required this.rating,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        location,
        galleryUrls,
        acceptedInsurance,
        workingHours,
        totalDoctors,
        rating,
        isActive,
      ];
}
