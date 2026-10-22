import '../../domain/entities/patient_entity.dart';

class EmergencyContactModel extends EmergencyContact {
  const EmergencyContactModel({
    required super.name,
    required super.relation,
    required super.phone,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      name: json['name'] as String,
      relation: json['relation'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'relation': relation,
    'phone': phone,
  };
}

class PatientModel extends PatientEntity {
  const PatientModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.age,
    required super.gender,
    required super.bloodGroup,
    required super.emergencyContact,
    required super.medicalHistory,
    required super.allergies,
    required super.registeredAt,
  });

  factory PatientModel.fromEntity(PatientEntity entity) {
    return PatientModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      age: entity.age,
      gender: entity.gender,
      bloodGroup: entity.bloodGroup,
      emergencyContact: entity.emergencyContact,
      medicalHistory: entity.medicalHistory,
      allergies: entity.allergies,
      registeredAt: entity.registeredAt,
    );
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      gender: json['gender'] as String? ?? 'Other',
      bloodGroup:
          (json['bloodGroup'] ?? json['blood_group']) as String? ?? 'O+',
      emergencyContact: json['emergencyContact'] != null
          ? EmergencyContactModel.fromJson(
              json['emergencyContact'] as Map<String, dynamic>,
            )
          : (json['emergency_contact'] != null
                ? EmergencyContactModel.fromJson(
                    json['emergency_contact'] as Map<String, dynamic>,
                  )
                : const EmergencyContactModel(
                    name: '',
                    relation: '',
                    phone: '',
                  )),
      medicalHistory:
          (json['medicalHistory'] ?? json['medical_history']) as String? ?? '',
      allergies: json['allergies'] as String? ?? '',
      registeredAt: json['registeredAt'] != null
          ? DateTime.parse(json['registeredAt'] as String)
          : (json['registered_at'] != null
                ? DateTime.parse(json['registered_at'] as String)
                : DateTime.now()),
    );
  }

  Map<String, dynamic> toSupabaseMap() {
    final contact = emergencyContact;
    final contactModel = contact is EmergencyContactModel
        ? contact
        : EmergencyContactModel(
            name: contact.name,
            relation: contact.relation,
            phone: contact.phone,
          );

    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'blood_group': bloodGroup,
      'emergency_contact': contactModel.toJson(),
      'medical_history': medicalHistory,
      'allergies': allergies,
      'registered_at': registeredAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    final contact = emergencyContact;
    final contactModel = contact is EmergencyContactModel
        ? contact
        : EmergencyContactModel(
            name: contact.name,
            relation: contact.relation,
            phone: contact.phone,
          );

    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'emergencyContact': contactModel.toJson(),
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'registeredAt': registeredAt.toIso8601String(),
    };
  }
}
