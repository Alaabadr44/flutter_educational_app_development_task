import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/config/app_colors.dart';

import '../../../../../../../core/config/l10n/generated/l10n.dart';
import '../../../../../../../domain/entities/subjects_data.dart';
import '../../../../../common/text_widget.dart';

class SubjectCompactCard extends StatefulWidget {
  final Subject subject;
  final VoidCallback? onTap;

  const SubjectCompactCard({super.key, required this.subject, this.onTap});

  @override
  State<SubjectCompactCard> createState() => _SubjectCompactCardState();
}

class _SubjectCompactCardState extends State<SubjectCompactCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with image and subscription
              Row(
                children: [
                  // Subject image
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child:
                        widget.subject.img != null &&
                                widget.subject.img!.isNotEmpty
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                _getCompleteImageUrl(widget.subject.img!),
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        _buildDefaultIcon(),
                              ),
                            )
                            : _buildDefaultIcon(),
                  ),

                  const SizedBox(width: 12),

                  // Subject name
                  Expanded(
                    child: TextWidget(
                      text: widget.subject.name ?? S.current.unknown_subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLine: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Type badge and subscription status
                  Column(
                    children: [
                      if (widget.subject.type != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.subject.type!.substring(0, 3).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (widget.subject.type != null)
                        const SizedBox(height: 2),
                      if (widget.subject.isSubscribe != null)
                        Icon(
                          widget.subject.isSubscribe!
                              ? Icons.verified
                              : Icons.lock,
                          size: 16,
                          color:
                              widget.subject.isSubscribe!
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Basic info (always visible)
              _buildBasicInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Icon(Icons.book_outlined, size: 14, color: _getSubjectColor());
  }

  String _getCompleteImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return 'https://taseese.org$imagePath';
  }

  Widget _buildBasicInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price
          _buildCompactPrice(),

          // Progress if available
          if (widget.subject.lessonsCount != null &&
              widget.subject.lessonsCount! > 0)
            _buildMiniProgress(),
        ],
      ),
    );
  }

  Widget _buildCompactPrice() {
    if (widget.subject.price == null) return const SizedBox.shrink();

    if (widget.subject.price! > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.price,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${widget.subject.price} SAR',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          S.current.free,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }

  Widget _buildMiniProgress() {
    final lessonsCount = widget.subject.lessonsCount ?? 0;
    final finishedLessons = widget.subject.finishesLessonsCount ?? 0;
    final progress = lessonsCount > 0 ? finishedLessons / lessonsCount : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$finishedLessons/$lessonsCount',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getSubjectColor() {
    if (widget.subject.color != null && widget.subject.color!.isNotEmpty) {
      try {
        String colorStr = widget.subject.color!;
        if (colorStr.startsWith('#')) {
          colorStr = colorStr.substring(1);
        }
        if (colorStr.length == 6) {
          colorStr = 'FF$colorStr';
        }
        return Color(int.parse(colorStr, radix: 16));
      } catch (e) {
        // Fallback to default color
      }
    }

    switch (widget.subject.type?.toLowerCase()) {
      case 'required':
        return Colors.blue[600]!;
      case 'optional':
        return Colors.purple[600]!;
      default:
        return Colors.indigo[600]!;
    }
  }
}

void showSubjectDetailsDialog(
  BuildContext context,
  Subject subject,
  Function(int) onUnitsTap,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 800),
          child: SubjectDetailsDialog(subject: subject, onUnitsTap: onUnitsTap),
        ),
      );
    },
  );
}

class SubjectDetailsDialog extends StatelessWidget {
  final Subject subject;
  final Function(int) onUnitsTap;
  const SubjectDetailsDialog({
    super.key,
    required this.subject,
    required this.onUnitsTap,
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
                    subject.name ?? S.current.subject_name_not_available,
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

            // Subject image
            if (subject.img != null && subject.img!.isNotEmpty) ...[
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      _getCompleteImageUrl(subject.img!),
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.book_outlined,
                            size: 40,
                            color: _getSubjectColor(subject),
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Subject details
            _buildDetailSection(S.current.subject_details, [
              if (subject.type != null)
                _buildDetailRow(S.current.type, subject.type!),
              if (subject.price != null)
                _buildDetailRow(S.current.price, '${subject.price} SAR'),
              if (subject.oldPrice != null && subject.oldPrice! > 0)
                _buildDetailRow(
                  S.current.previous_price,
                  '${subject.oldPrice} SAR',
                ),
              if (subject.teacherPrice != null)
                _buildDetailRow(
                  S.current.teacher_price,
                  '${subject.teacherPrice} SAR',
                ),
              if (subject.isSubscribe != null)
                _buildDetailRow(
                  S.current.subscription_status,
                  subject.isSubscribe!
                      ? S.current.subscribed
                      : S.current.not_subscribed,
                ),
            ]),

            // Progress details
            if (subject.lessonsCount != null && subject.lessonsCount! > 0) ...[
              const SizedBox(height: 16),
              _buildProgressSection(context),
            ],

            // Answer statistics
            if (subject.trueAnswersCount != null ||
                subject.falseAnswersCount != null) ...[
              const SizedBox(height: 16),
              _buildStatsSection(context),
            ],

            // // System information
            // const SizedBox(height: 16),
            // _buildDetailSection('System Information', [
            //   if (subject.id != null)
            //     _buildDetailRow('Subject ID', '#${subject.id}'),
            //   if (subject.systemId != null)
            //     _buildDetailRow('System', '${subject.systemId}'),
            //   if (subject.stageId != null)
            //     _buildDetailRow('Stage', '${subject.stageId}'),
            //   if (subject.classroomId != null)
            //     _buildDetailRow('Classroom', '${subject.classroomId}'),
            //   if (subject.termId != null)
            //     _buildDetailRow('Term', '${subject.termId}'),
            //   if (subject.pathId != null)
            //     _buildDetailRow('Path', '${subject.pathId}'),
            // ]),

            // Timestamps
            if (subject.createdAt != null || subject.updatedAt != null) ...[
              const SizedBox(height: 16),
              _buildDetailSection(S.current.dates, [
                if (subject.createdAt != null)
                  _buildDetailRow(
                    S.current.created_date,
                    _formatDate(subject.createdAt!),
                  ),
                if (subject.updatedAt != null)
                  _buildDetailRow(
                    S.current.updated_date,
                    _formatDate(subject.updatedAt!),
                  ),
              ]),
            ],

            const SizedBox(height: 20),

            // Action button
            if (subject.isSubscribe == false)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onUnitsTap(subject.id!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getSubjectColor(subject),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.add_shopping_cart,
                    color: AppColors.reverseBaseColor,
                  ),
                  label: Text(
                    S.current.view_lessons,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.reverseBaseColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.reverseBaseColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final lessonsCount = subject.lessonsCount ?? 0;
    final finishedLessons = subject.finishesLessonsCount ?? 0;
    final progress = lessonsCount > 0 ? finishedLessons / lessonsCount : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.lesson_progress,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.reverseBaseColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!, width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.completed_lessons,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[800],
                    ),
                  ),
                  Text(
                    '$finishedLessons ${S.current.of_separator} $lessonsCount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue[600]!,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.answer_statistics,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.reverseBaseColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!, width: 1),
          ),
          child: Row(
            children: [
              if (subject.trueAnswersCount != null) ...[
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 32,
                        color: Colors.green[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${subject.trueAnswersCount}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        S.current.correct_answer,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (subject.falseAnswersCount != null) ...[
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.cancel, size: 32, color: Colors.red[600]),
                      const SizedBox(height: 8),
                      Text(
                        '${subject.falseAnswersCount}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.red[700],
                        ),
                      ),
                      Text(
                        S.current.wrong_answer,
                        style: TextStyle(fontSize: 12, color: Colors.red[600]),
                      ),
                    ],
                  ),
                ),
              ],

              if (subject.trueAnswersCount != null &&
                  subject.falseAnswersCount != null) ...[
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.analytics, size: 32, color: Colors.blue[600]),
                      const SizedBox(height: 8),
                      Text(
                        '${_calculateAccuracy()}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue[700],
                        ),
                      ),
                      Text(
                        S.current.accuracy_rate,
                        style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _calculateAccuracy() {
    final correct = subject.trueAnswersCount ?? 0;
    final incorrect = subject.falseAnswersCount ?? 0;
    final total = correct + incorrect;
    if (total == 0) return '0';
    return ((correct / total) * 100).toStringAsFixed(1);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

String _getCompleteImageUrl(String imagePath) {
  if (imagePath.startsWith('http')) {
    return imagePath;
  }
  return 'https://taseese.org$imagePath';
}

Color _getSubjectColor(Subject subject) {
  if (subject.color != null && subject.color!.isNotEmpty) {
    try {
      String colorStr = subject.color!;
      if (colorStr.startsWith('#')) {
        colorStr = colorStr.substring(1);
      }
      if (colorStr.length == 6) {
        colorStr = 'FF$colorStr';
      }
      return Color(int.parse(colorStr, radix: 16));
    } catch (e) {
      // Fallback to default color
    }
  }

  switch (subject.type?.toLowerCase()) {
    case 'required':
      return Colors.blue[600]!;
    case 'optional':
      return Colors.purple[600]!;
    default:
      return Colors.indigo[600]!;
  }
}
