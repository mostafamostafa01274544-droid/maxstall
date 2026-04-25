import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class GradientButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final double height;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient = AppColors.gradientPrimary,
    this.height   = 56,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onTapDown(TapDownDetails _) async {
    await _ctrl.forward();
    HapticFeedback.lightImpact();
  }

  Future<void> _onTapUp(TapUpDetails _) async {
    await _ctrl.reverse();
    widget.onPressed?.call();
  }

  Future<void> _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.45,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTapDown: isEnabled ? _onTapDown : null,
        onTapUp:   isEnabled ? _onTapUp   : null,
        onTapCancel: isEnabled ? _onTapCancel : null,
        child: ScaleTransition(
          scale: _scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: widget.height,
            decoration: BoxDecoration(
              gradient: isEnabled ? widget.gradient : const LinearGradient(
                colors: [Color(0xFF444444), Color(0xFF333333)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: AppColors.neonPrimary.withAlpha(77),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      )
                    ]
                  : [],
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
