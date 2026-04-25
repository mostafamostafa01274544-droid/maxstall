import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../bloc/converter_bloc.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class OutputOptionsForm extends StatefulWidget {
  const OutputOptionsForm({super.key});
  @override
  State<OutputOptionsForm> createState() => _OutputOptionsFormState();
}

class _OutputOptionsFormState extends State<OutputOptionsForm> {
  late TextEditingController _nameCtrl;
  late TextEditingController _dirCtrl;

  @override
  void initState() {
    super.initState();
    final s = context.read<ConverterBloc>().state;
    _nameCtrl = TextEditingController(text: s.outputName);
    _dirCtrl  = TextEditingController(text: s.outputDir);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dirCtrl.dispose();
    super.dispose();
  }

  InputDecoration _glassDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.neonPrimary, size: 18),
      filled: true,
      fillColor: AppColors.glassWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.neonPrimary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OUTPUT OPTIONS',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const Gap(16),
          TextField(
            controller: _nameCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: _glassDecoration('File Name (without extension)',
                Icons.drive_file_rename_outline_rounded),
            onChanged: (v) => context
                .read<ConverterBloc>()
                .add(OutputNameChangedEvent(v)),
          ),
          const Gap(12),
          TextField(
            controller: _dirCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: _glassDecoration(
                'Save Directory (leave blank = default)',
                Icons.folder_open_rounded),
            onChanged: (v) => context
                .read<ConverterBloc>()
                .add(OutputDirChangedEvent(v)),
          ),
        ],
      ),
    );
  }
}
