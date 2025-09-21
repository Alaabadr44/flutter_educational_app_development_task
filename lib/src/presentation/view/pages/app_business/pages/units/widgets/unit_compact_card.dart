import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/config/app_colors.dart';

import '../../../../../../../domain/entities/unit_data.dart';
import '../../../../../common/text_widget.dart';

class UnitCompactCard extends StatelessWidget {
  final UnitData unit;
  final VoidCallback? onTap;

  const UnitCompactCard({super.key, required this.unit, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasLessons = unit.lessons != null && unit.lessons!.isNotEmpty;

    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: hasLessons ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  hasLessons
                      ? [
                        AppColors.primaryColor.withOpacity(0.05),
                        AppColors.primaryColor.withOpacity(0.02),
                      ]
                      : [
                        Colors.grey.withOpacity(0.05),
                        Colors.grey.withOpacity(0.02),
                      ],
            ),
            border: Border.all(
              color:
                  hasLessons
                      ? AppColors.primaryColor.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and lessons count
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Unit icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient:
                          hasLessons
                              ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.primaryColor.withOpacity(0.7),
                                ],
                              )
                              : LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.grey[400]!, Colors.grey[500]!],
                              ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow:
                          hasLessons
                              ? [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                              : [],
                    ),
                    child: Icon(
                      hasLessons ? Icons.library_books : Icons.lock_outline,
                      color: Colors.white,
                      size: 20,
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color:
                                hasLessons ? Colors.black87 : Colors.grey[600],
                            height: 1.3,
                          ),
                          maxLine: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (unit.id != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '#${unit.id}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Lessons count badge
                  if (hasLessons)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${unit.lessons!.length}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Quick info
              _buildQuickInfo(),

              const Spacer(),

              // Action button
              _buildCompactActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickInfo() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lessons info
          Row(
            children: [
              Icon(Icons.playlist_play, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  unit.lessons == null || unit.lessons!.isEmpty
                      ? 'No lessons'
                      : '${unit.lessons!.length} ${unit.lessons!.length == 1 ? 'lesson' : 'lessons'}',
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        unit.lessons == null || unit.lessons!.isEmpty
                            ? Colors.orange[700]
                            : Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // Date if available
          if (unit.createdAt != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _formatDate(unit.createdAt!),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactActionButton() {
    final hasLessons = unit.lessons != null && unit.lessons!.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 32,
      child: ElevatedButton(
        onPressed: hasLessons ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              hasLessons ? AppColors.primaryColor : Colors.grey[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: hasLessons ? 1 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(hasLessons ? Icons.play_arrow : Icons.lock_outline, size: 14),
            const SizedBox(width: 4),
            Text(
              hasLessons ? 'Start' : 'Locked',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}
