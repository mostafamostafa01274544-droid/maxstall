import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../core/utils/file_utils.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class FileInfoTile extends StatelessWidget {
  final String path;
  final String label;
  final Color accentColor;

  const FileInfoTile({
    super.key,
    required this.path,
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    final size = file.existsSync()
        ? FileUtils.readableSize(file.lengthSync())
        : '—';
    final name = path.split('/').last;

    return GlassCard(
      borderColor: accentColor.withOpacity(0.4),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [accentColor.withOpacity(0.3), accentColor.withOpacity(0.1)],
              ),
            ),
            child: Icon(Icons.video_file_rounded, color: accentColor, size: 22),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: accentColor, fontSize: 10,
                  ),
                ),
                const Gap(2),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(size, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
