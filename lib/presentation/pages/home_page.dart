import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as p;

import '../bloc/converter_bloc.dart';
import '../theme/app_theme.dart';
import '../widgets/file_info_tile.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/output_options_form.dart';
import '../widgets/progress_indicator_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // ── Animated gradient background ──────────────────────────
          _BackgroundGradient(),
          // ── Content ──────────────────────────────────────────────
          SafeArea(
            child: BlocBuilder<ConverterBloc, ConverterState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                      sliver: SliverList.list(children: [
                        _HeroHeader(),
                        const Gap(24),
                        _buildBody(context, state),
                      ]),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          ShaderMask(
            shaderCallback: (b) => AppColors.gradientPrimary.createShader(b),
            child: const Icon(Icons.transform_rounded,
                color: Colors.white, size: 24),
          ),
          const Gap(10),
          ShaderMask(
            shaderCallback: (b) => AppColors.gradientPrimary.createShader(b),
            child: const Text(
              'YJ Converter',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded,
              color: AppColors.textSecondary),
          onPressed: () =>
              context.read<ConverterBloc>().add(const ResetEvent()),
        ),
        const Gap(4),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ConverterState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Input file card
        if (state.inputPath != null)
          FileInfoTile(
            path: state.inputPath!,
            label: '📂  INPUT FILE',
            accentColor: AppColors.neonSecondary,
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
        if (state.inputPath != null) const Gap(16),

        // Output options form (visible when file is picked)
        if (state.status == ConversionStatus.picked ||
            state.status == ConversionStatus.failure)
          const OutputOptionsForm()
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms)
              .slideY(begin: 0.1, end: 0),
        if (state.status == ConversionStatus.picked ||
            state.status == ConversionStatus.failure)
          const Gap(16),

        // Progress bar
        if (state.status == ConversionStatus.converting)
          ProgressIndicatorWidget(progress: state.progress)
              .animate()
              .fadeIn(duration: 300.ms),
        if (state.status == ConversionStatus.converting) const Gap(16),

        // Output file card
        if (state.status == ConversionStatus.success &&
            state.outputPath != null) ...[
          FileInfoTile(
            path: state.outputPath!,
            label: '✅  OUTPUT FILE',
            accentColor: AppColors.neonPrimary,
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9)),
          const Gap(12),
          _SuccessBanner(state: state)
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms),
          const Gap(16),
        ],

        // Error banner
        if (state.status == ConversionStatus.failure &&
            state.errorMessage != null)
          _ErrorBanner(message: state.errorMessage!)
              .animate()
              .fadeIn(duration: 300.ms)
              .shakeX(),
        if (state.status == ConversionStatus.failure) const Gap(16),

        // CTA buttons
        _ActionButtons(state: state).animate().fadeIn(
              duration: 300.ms,
              delay: state.inputPath == null ? 0.ms : 150.ms,
            ),
      ],
    );
  }
}

// ── Background gradient widget ────────────────────────────────────────────────
class _BackgroundGradient extends StatefulWidget {
  @override
  State<_BackgroundGradient> createState() => _BackgroundGradientState();
}

class _BackgroundGradientState extends State<_BackgroundGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Alignment> _alignAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
    _alignAnim = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _alignAnim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color(0xFF0A0E1A), Color(0xFF1A0A2E),
              Color(0xFF0A1A2E), Color(0xFF0A0E1A),
            ],
            begin: _alignAnim.value,
            end: Alignment(-_alignAnim.value.x, -_alignAnim.value.y),
          ),
        ),
      ),
    );
  }
}

// ── Hero header ──────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (b) => AppColors.gradientPrimary.createShader(b),
          child: Text(
            'MP4 → 3GP',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 40,
                  height: 1.1,
                ),
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
        const Gap(8),
        Text(
          'Hardware-accelerated via Media3 Transformer.\n'
          '320×240 · H.264 · 1 Mbps · WorkManager background queue',
          style: Theme.of(context).textTheme.bodyMedium,
        ).animate().fadeIn(duration: 600.ms, delay: 150.ms),
      ],
    );
  }
}

// ── Success banner ───────────────────────────────────────────────────────────
class _SuccessBanner extends StatelessWidget {
  final ConverterState state;
  const _SuccessBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final elapsed = state.elapsed;
    final dir = state.outputPath != null
        ? p.dirname(state.outputPath!)
        : '—';

    return GlassCard(
      borderColor: AppColors.neonPrimary.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.neonPrimary, size: 22),
              const Gap(10),
              Expanded(
                child: Text(
                  'Conversion Complete!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.neonPrimary),
                ),
              ),
              if (elapsed != null)
                Text(
                  '${elapsed.inSeconds}s',
                  style: const TextStyle(
                      color: AppColors.neonPrimary, fontWeight: FontWeight.w700),
                ),
            ],
          ),
          const Gap(6),
          Text('Saved to: $dir',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ── Error banner ─────────────────────────────────────────────────────────────
class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: AppColors.neonAccent.withOpacity(0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_rounded,
              color: AppColors.neonAccent, size: 22),
          const Gap(10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.neonAccent),
            ),
          ),
        ],
      ),
    );
  }
}

// ── CTA buttons ──────────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final ConverterState state;
  const _ActionButtons({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ConverterBloc>();
    final isConverting = state.status == ConversionStatus.converting;

    if (state.status == ConversionStatus.success) {
      return GradientButton(
        onPressed: () => bloc.add(const ResetEvent()),
        gradient: const LinearGradient(
            colors: [Color(0xFF7C5CFC), Color(0xFFFF6B9D)]),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white),
            Gap(8),
            Text('Convert Another',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pick file button
        GradientButton(
          onPressed: isConverting
              ? null
              : () => bloc.add(const PickVideoEvent()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.video_library_rounded, color: Colors.black87),
              const Gap(10),
              Text(
                state.inputPath == null ? 'Select MP4 File' : 'Change File',
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                    fontSize: 16),
              ),
            ],
          ),
        ),

        // Convert button
        if (state.status == ConversionStatus.picked ||
            state.status == ConversionStatus.failure) ...[
          const Gap(12),
          GradientButton(
            onPressed: isConverting
                ? null
                : () => bloc.add(const StartConversionEvent()),
            gradient: const LinearGradient(
                colors: [Color(0xFF7C5CFC), Color(0xFF00F5C4)]),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.rocket_launch_rounded,
                    color: Colors.white, size: 20),
                const Gap(10),
                const Text('Convert to 3GP',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
              ],
            ),
          ),
        ],

        // Cancel button
        if (isConverting) ...[
          const Gap(12),
          TextButton.icon(
            onPressed: () => bloc.add(const CancelEvent()),
            icon: const Icon(Icons.cancel_outlined, color: AppColors.neonAccent),
            label: const Text('Cancel',
                style: TextStyle(color: AppColors.neonAccent)),
          ),
        ],
      ],
    );
  }
}
