import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/config/app_colors.dart';

import '../../../../../../../domain/entities/unit_data.dart';

void showUnitDetailsDialog(
  BuildContext context,
  UnitData unit,
  Function(Lesson) onLessonTap,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 800),
          child: UnitDetailsDialog(unit: unit, onLessonTap: onLessonTap),
        ),
      );
    },
  );
}

class UnitDetailsDialog extends StatelessWidget {
  final UnitData unit;
  final Function(Lesson) onLessonTap;

  const UnitDetailsDialog({
    super.key,
    required this.unit,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 8,
      radius: const Radius.circular(4),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    unit.name ?? 'Unit name not available',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Unit info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1),
                    AppColors.primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.library_books,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (unit.id != null)
                              Text(
                                'Unit #${unit.id}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              unit.lessons == null || unit.lessons!.isEmpty
                                  ? 'No lessons available'
                                  : '${unit.lessons!.length} ${unit.lessons!.length == 1 ? 'lesson' : 'lessons'} available',
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    unit.lessons == null ||
                                            unit.lessons!.isEmpty
                                        ? Colors.orange[700]
                                        : Colors.green[700],
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (_hasSystemInfo()) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unit Information',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._buildSystemInfoRows(),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Lessons section
            if (unit.lessons != null && unit.lessons!.isNotEmpty) ...[
              Text(
                'Available Lessons',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: unit.lessons!.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final lesson = unit.lessons![index];
                  return _buildLessonCard(lesson, index + 1);
                },
              ),
            ] else ...[
              // Empty state
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange[200]!, width: 1),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 48,
                      color: Colors.orange[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No lessons available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lessons will be added soon',
                      style: TextStyle(fontSize: 14, color: Colors.orange[600]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(Lesson lesson, int lessonNumber) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => onLessonTap(lesson),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Lesson number
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.successColor,
                      AppColors.successColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$lessonNumber',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Lesson info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.name ?? 'Lesson name not available',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(children: [..._buildLessonFeatures(lesson)]),
                  ],
                ),
              ),

              // Play button
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLessonFeatures(Lesson lesson) {
    final features = <Widget>[];

    if (lesson.videoCode != null && lesson.videoCode!.isNotEmpty) {
      features.add(_buildFeatureChip(Icons.play_circle, 'Video', Colors.red));
    }

    if (lesson.isAudio == 1 || lesson.audioFile != null) {
      features.add(_buildFeatureChip(Icons.headphones, 'Audio', Colors.orange));
    }

    if (lesson.pdfFile != null && lesson.pdfFile!.isNotEmpty) {
      features.add(_buildFeatureChip(Icons.picture_as_pdf, 'PDF', Colors.blue));
    }

    if (features.isEmpty) {
      features.add(_buildFeatureChip(Icons.text_fields, 'Text', Colors.grey));
    }

    return features;
  }

  Widget _buildFeatureChip(IconData icon, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasSystemInfo() {
    return unit.systemId != null ||
        unit.stageId != null ||
        unit.classroomId != null ||
        unit.termId != null ||
        unit.subjectId != null ||
        unit.createdAt != null;
  }

  List<Widget> _buildSystemInfoRows() {
    final rows = <Widget>[];

    if (unit.systemId != null) {
      rows.add(_buildInfoRow('System', '${unit.systemId}'));
    }
    if (unit.stageId != null) {
      rows.add(_buildInfoRow('Stage', '${unit.stageId}'));
    }
    if (unit.classroomId != null) {
      rows.add(_buildInfoRow('Classroom', '${unit.classroomId}'));
    }
    if (unit.termId != null) {
      rows.add(_buildInfoRow('Term', '${unit.termId}'));
    }
    if (unit.subjectId != null) {
      rows.add(_buildInfoRow('Subject', '${unit.subjectId}'));
    }
    if (unit.createdAt != null) {
      rows.add(_buildInfoRow('Created Date', _formatDate(unit.createdAt!)));
    }

    return rows;
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
