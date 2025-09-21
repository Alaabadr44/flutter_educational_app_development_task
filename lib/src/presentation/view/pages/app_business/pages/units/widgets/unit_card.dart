import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/config/app_colors.dart';

import '../../../../../../../domain/entities/unit_data.dart';
import '../../../../../common/text_widget.dart';

class UnitCard extends StatelessWidget {
  final UnitData unit;
  final VoidCallback? onTap;

  const UnitCard({super.key, required this.unit, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor.withOpacity(0.05),
                AppColors.primaryColor.withOpacity(0.02),
              ],
            ),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with unit info
              Row(
                children: [
                  // Unit icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.library_books_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Unit name and ID
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: unit.name ?? 'Unit name not available',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                          maxLine: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (unit.id != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Unit #${unit.id}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Lessons count badge
                  if (unit.lessons != null && unit.lessons!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.successColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_circle_outline,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${unit.lessons!.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Unit details
              _buildUnitDetails(),

              const SizedBox(height: 16),

              // Action button
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        children: [
          // System information row
          if (unit.systemId != null || unit.stageId != null) ...[
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _buildSystemInfo(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Created date
          if (unit.createdAt != null) ...[
            if (unit.systemId != null || unit.stageId != null)
              const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  'Created: ${_formatDate(unit.createdAt!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],

          // Lessons info
          if (unit.lessons != null) ...[
            if (unit.createdAt != null ||
                unit.systemId != null ||
                unit.stageId != null)
              const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.playlist_play, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  unit.lessons!.isEmpty
                      ? 'No lessons available'
                      : '${unit.lessons!.length} ${unit.lessons!.length == 1 ? 'lesson' : 'lessons'} available',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        unit.lessons!.isEmpty
                            ? Colors.orange[700]
                            : Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final hasLessons = unit.lessons != null && unit.lessons!.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton.icon(
        onPressed: hasLessons ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              hasLessons ? AppColors.primaryColor : Colors.grey[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: hasLessons ? 2 : 0,
        ),
        icon: Icon(
          hasLessons ? Icons.play_arrow : Icons.lock_outline,
          size: 18,
        ),
        label: Text(
          hasLessons ? 'Start Lessons' : 'No Lessons',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  String _buildSystemInfo() {
    final info = <String>[];

    if (unit.systemId != null) {
      info.add('System: ${unit.systemId}');
    }
    if (unit.stageId != null) {
      info.add('Stage: ${unit.stageId}');
    }
    if (unit.classroomId != null) {
      info.add('Classroom: ${unit.classroomId}');
    }
    if (unit.termId != null) {
      info.add('Term: ${unit.termId}');
    }

    return info.join(' • ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
