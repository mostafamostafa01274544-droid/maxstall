import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:gap/gap.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;

  const ProgressIndicatorWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toStringAsFixed(0);

    return GlassCard(
      borderColor: AppColors.neonPrimary.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonPrimary),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'Converting…',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.neonPrimary),
                  ),
                ],
              ),
              Text(
                '$pct%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.neonPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
              ),
            ],
          ),
          const Gap(14),
          LinearPercentIndicator(
            percent: progress.clamp(0.0, 1.0),
            lineHeight: 6,
            backgroundColor: AppColors.neonPrimary.withOpacity(0.12),
            linearGradient: AppColors.gradientPrimary,
            barRadius: const Radius.circular(3),
            padding: EdgeInsets.zero,
            animation: false,
          ),
          const Gap(10),
          Text(
            'Hardware-accelerated via Media3 Transformer…',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
