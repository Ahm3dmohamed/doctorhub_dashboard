import '../../../../core/errors/exceptions.dart';
import '../models/clinic_model.dart';

abstract class ClinicRemoteDataSource {
  Future<List<ClinicModel>> getClinics({
    String? query,
    String? cityFilter,
    int page = 1,
    int limit = 10,
  });

  Future<ClinicModel> createClinic(ClinicModel clinic);
  Future<ClinicModel> updateClinic(ClinicModel clinic);
  Future<bool> deleteClinic(String id);
}

class ClinicRemoteDataSourceImpl implements ClinicRemoteDataSource {
  final List<ClinicModel> _clinics = [
    const ClinicModel(
      id: 'clinic_1',
      name: 'Central Heart & Wellness Clinic',
      phone: '+1 (555) 111-2233',
      email: 'contact@centralheart.com',
      location: LocationModel(
        address: '100 Medical Center Blvd, Suite 400',
        city: 'New York',
        governorate: 'NY',
        latitude: 40.7128,
        longitude: -74.0060,
      ),
      galleryUrls: [],
      acceptedInsurance: ['Aetna', 'BlueCross', 'Cigna', 'UnitedHealth'],
      workingHours: 'Mon - Fri: 08:00 AM - 06:00 PM',
      totalDoctors: 12,
      rating: 4.9,
      isActive: true,
    ),
    const ClinicModel(
      id: 'clinic_2',
      name: 'Apex Orthopedic & Spine Center',
      phone: '+1 (555) 444-5566',
      email: 'info@apexortho.org',
      location: LocationModel(
        address: '450 Health Parkway, Floor 2',
        city: 'Chicago',
        governorate: 'IL',
        latitude: 41.8781,
        longitude: -87.6298,
      ),
      galleryUrls: [],
      acceptedInsurance: ['Medicare', 'Humana', 'Kaiser'],
      workingHours: 'Mon - Sat: 09:00 AM - 05:00 PM',
      totalDoctors: 8,
      rating: 4.7,
      isActive: true,
    ),
    const ClinicModel(
      id: 'clinic_3',
      name: 'Sunshine Pediatric Care',
      phone: '+1 (555) 777-8899',
      email: 'care@sunshinepeds.com',
      location: LocationModel(
        address: '12 Kinder Avenue',
        city: 'Los Angeles',
        governorate: 'CA',
        latitude: 34.0522,
        longitude: -118.2437,
      ),
      galleryUrls: [],
      acceptedInsurance: ['BlueCross', 'Medicaid', 'Molina'],
      workingHours: 'Mon - Fri: 08:30 AM - 04:30 PM',
      totalDoctors: 6,
      rating: 4.95,
      isActive: true,
    ),
  ];

  @override
  Future<List<ClinicModel>> getClinics({
    String? query,
    String? cityFilter,
    int page = 1,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var res = _clinics.toList();

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      res = res
          .where(
            (c) =>
                c.name.toLowerCase().contains(q) ||
                c.location.city.toLowerCase().contains(q) ||
                c.email.toLowerCase().contains(q),
          )
          .toList();
    }

    if (cityFilter != null && cityFilter.isNotEmpty && cityFilter != 'All') {
      res = res
          .where(
            (c) => c.location.city.toLowerCase() == cityFilter.toLowerCase(),
          )
          .toList();
    }

    return res;
  }

  @override
  Future<ClinicModel> createClinic(ClinicModel clinic) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final created = ClinicModel(
      id: 'clinic_${DateTime.now().millisecondsSinceEpoch}',
      name: clinic.name,
      phone: clinic.phone,
      email: clinic.email,
      location: clinic.location,
      galleryUrls: clinic.galleryUrls,
      acceptedInsurance: clinic.acceptedInsurance,
      workingHours: clinic.workingHours,
      totalDoctors: clinic.totalDoctors,
      rating: clinic.rating,
      isActive: clinic.isActive,
    );
    _clinics.insert(0, created);
    return created;
  }

  @override
  Future<ClinicModel> updateClinic(ClinicModel clinic) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _clinics.indexWhere((c) => c.id == clinic.id);
    if (idx == -1) throw const AppException(message: 'Patient not found');
    _clinics[idx] = clinic;
    return clinic;
  }

  @override
  Future<bool> deleteClinic(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _clinics.removeWhere((c) => c.id == id);
    return true;
  }
}
