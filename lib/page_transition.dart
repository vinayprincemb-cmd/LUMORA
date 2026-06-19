// page_transition.dart
import 'package:flutter/material.dart';

class FadeSlideRoute<T>
    extends PageRouteBuilder<T> {
  final Widget page;

  FadeSlideRoute({required this.page})
      : super(
          transitionDuration:
              const Duration(
            milliseconds: 600,
          ),

          reverseTransitionDuration:
              const Duration(
            milliseconds: 400,
          ),

          pageBuilder:
              (
                context,
                animation,
                secondaryAnimation,
              ) =>
                  page,

          transitionsBuilder:
              (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
            // Slide animation from right
            const beginSlide = Offset(0.15, 0);
            const endSlide = Offset.zero;

            final slideTween = Tween(
              begin: beginSlide,
              end: endSlide,
            ).chain(
              CurveTween(
                curve: Curves.easeOutCubic,
              ),
            );

            // Fade animation
            final fadeTween = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).chain(
              CurveTween(
                curve: Curves.easeOutQuad,
              ),
            );

            final scaleTween = Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).chain(
              CurveTween(
                curve: Curves.easeOutCubic,
              ),
            );

            return FadeTransition(
              opacity:
                  animation.drive(fadeTween),

              child: SlideTransition(
                position:
                    animation.drive(slideTween),

                child: ScaleTransition(
                  scale: animation.drive(
                    scaleTween,
                  ),
                  child: child,
                ),
              ),
            );
          },
        );
}