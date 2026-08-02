import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/features/auth/presentation/pages/widgets/grid_painter.dart';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => AnimatedBackgroundState();
}

class AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          decoration: const BoxDecoration(
            gradient: AppColors.authBackgroundGradient,
          ),
          child: Stack(
            children: [
              // Glowing orb top-right
              Positioned(
                top: -100,
                right: -100,
                child: Opacity(
                  opacity: 0.15 + (_controller.value * 0.1),
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Glowing orb bottom-left
              Positioned(
                bottom: -150,
                left: -150,
                child: Opacity(
                  opacity: 0.1 + (_controller.value * 0.08),
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent,
                          AppColors.accent.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Grid pattern
              Opacity(
                opacity: 0.03,
                child: CustomPaint(
                  size: Size(
                    MediaQuery.sizeOf(context).width,
                    MediaQuery.sizeOf(context).height,
                  ),
                  painter: GridPainter(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
