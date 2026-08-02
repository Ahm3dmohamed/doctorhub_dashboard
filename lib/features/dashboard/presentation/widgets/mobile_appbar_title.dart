import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MobileAppBarTitle extends StatelessWidget {
  const MobileAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.local_hospital_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        const Text('DoctorHub'),
      ],
    );
  }
}
