import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';
import '../../../core/utils/extension.dart';
import '../../../domain/entities/education_system.dart';
import 'text_widget.dart';
import 'ticker_widget.dart';

class EducationSystemCard extends StatelessWidget {
  final SelectionData educationSystem;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showSelectionIndicator;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool showShadow;
  final bool showImage;
  final double? textWidth;
  final bool enableTextScroll;

  const EducationSystemCard({
    super.key,
    required this.educationSystem,
    this.isSelected = false,
    this.onTap,
    this.showSelectionIndicator = true,
    this.margin,
    this.padding,
    this.borderRadius,
    this.showShadow = true,
    this.showImage = false,
    this.textWidth = 150,
    this.enableTextScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: _getBackgroundColor(context),
              borderRadius: BorderRadius.circular(borderRadius ?? 16),
              border: Border.all(
                color: _getBorderColor(),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: showShadow ? _getShadow() : null,
            ),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Left side - Icon/Image
                  _buildIcon(context),
                  const SizedBox(width: 16),

                  // Center - Content
                  Expanded(child: _buildContent(context)),

                  // Right side - Selection indicator
                  if (showSelectionIndicator) _buildSelectionIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isSelected
                  ? AppColors.primaryColor.withOpacity(0.3)
                  : Colors.transparent,
          width: 1,
        ),
      ),
      child:
          showImage && educationSystem.img != null
              ? _buildImage()
              : _buildDefaultIcon(context),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        educationSystem.img.toString(),
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => _buildDefaultIcon(context),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefaultIcon(BuildContext context) {
    return Icon(
      _getSystemIcon(),
      size: 32,
      color: isSelected ? AppColors.primaryColor : AppColors.grey600,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // System Name
        SizedBox(
          width: textWidth,
          child:
              enableTextScroll
                  ? TickerWidget(
                    speed: 30,
                    child: TextWidget(
                      text: educationSystem.name ?? 'Unknown System',
                      style: context.titleM?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected
                                ? AppColors.primaryColor
                                : AppColors.textPrimaryColor,
                      ),
                      maxLine: 1,
                    ),
                  )
                  : TextWidget(
                    text: educationSystem.name ?? 'Unknown System',
                    style: context.titleM?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected
                              ? AppColors.primaryColor
                              : AppColors.textPrimaryColor,
                    ),
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
        ),

        if (_hasAdditionalInfo()) ...[
          const SizedBox(height: 8),

          // System ID
          if (educationSystem.systemId != null) ...[
            _buildInfoRow(
              icon: Icons.tag,
              text: 'System ID: ${educationSystem.systemId}',
              context: context,
            ),
            const SizedBox(height: 4),
          ],

          // End Year
          if (educationSystem.endYear != null) ...[
            _buildInfoRow(
              icon: Icons.calendar_today,
              text: 'End Year: ${_formatDate(educationSystem.endYear!)}',
              context: context,
            ),
            const SizedBox(height: 4),
          ],

          // Last Updated
          if (educationSystem.updatedAt != null) ...[
            _buildInfoRow(
              icon: Icons.update,
              text: 'Updated: ${_formatDate(educationSystem.updatedAt!)}',
              context: context,
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey500),
        const SizedBox(width: 4),
        Expanded(
          child: TextWidget(
            text: text,
            style: context.bodyS?.copyWith(color: AppColors.grey600),
            maxLine: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionIndicator() {
    if (!isSelected) return const SizedBox(width: 24);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.check, color: Colors.white, size: 16),
    );
  }

  // Helper methods
  Color _getBackgroundColor(BuildContext context) {
    if (isSelected) {
      return AppColors.primaryColor.withOpacity(0.05);
    }
    return Colors.white;
  }

  Color _getBorderColor() {
    if (isSelected) {
      return AppColors.primaryColor;
    }
    return AppColors.grey100;
  }

  Color _getIconBackgroundColor() {
    if (isSelected) {
      return AppColors.primaryColor.withOpacity(0.1);
    }
    return AppColors.grey100;
  }

  List<BoxShadow> _getShadow() {
    if (isSelected) {
      return [
        BoxShadow(
          color: AppColors.primaryColor.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.grey.withOpacity(0.08),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  IconData _getSystemIcon() {
    final name = educationSystem.name?.toLowerCase() ?? '';

    if (name.contains('public') || name.contains('government')) {
      return Icons.account_balance;
    } else if (name.contains('private')) {
      return Icons.business;
    } else if (name.contains('international') || name.contains('global')) {
      return Icons.public;
    } else if (name.contains('vocational') || name.contains('technical')) {
      return Icons.build;
    } else if (name.contains('university') || name.contains('higher')) {
      return Icons.school;
    } else if (name.contains('elementary') || name.contains('primary')) {
      return Icons.child_care;
    } else if (name.contains('secondary') || name.contains('high')) {
      return Icons.trending_up;
    }

    return Icons.school; // Default icon
  }

  bool _hasAdditionalInfo() {
    return educationSystem.systemId != null ||
        educationSystem.endYear != null ||
        educationSystem.updatedAt != null;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Compact version for grid layouts
class EducationSystemCompactCard extends StatelessWidget {
  final SelectionData educationSystem;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? textWidth;
  final bool enableTextScroll;

  const EducationSystemCompactCard({
    super.key,
    required this.educationSystem,
    this.isSelected = false,
    this.onTap,
    this.textWidth = 120,
    this.enableTextScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppColors.primaryColor.withOpacity(0.05)
                      : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : AppColors.grey400,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      isSelected
                          ? AppColors.primaryColor.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.08),
                  blurRadius: isSelected ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon section
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : AppColors.grey100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _getSystemIcon(),
                      size: 18,
                      color:
                          isSelected
                              ? AppColors.primaryColor
                              : AppColors.grey600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Text section - always 2 lines, no ticker in grid
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: educationSystem.name ?? 'Unknown',
                          style: context.bodyS?.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.textPrimaryColor,
                          ),
                          textAlign: TextAlign.center,
                          maxLine: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Selection indicator
                  if (isSelected) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 12), // Maintain consistent height
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getSystemIcon() {
    final name = educationSystem.name?.toLowerCase() ?? '';

    if (name.contains('public') || name.contains('government')) {
      return Icons.account_balance;
    } else if (name.contains('private')) {
      return Icons.business;
    } else if (name.contains('international') || name.contains('global')) {
      return Icons.public;
    } else if (name.contains('vocational') || name.contains('technical')) {
      return Icons.build;
    } else if (name.contains('university') || name.contains('higher')) {
      return Icons.school;
    } else if (name.contains('elementary') || name.contains('primary')) {
      return Icons.child_care;
    } else if (name.contains('secondary') || name.contains('high')) {
      return Icons.trending_up;
    }

    return Icons.school; // Default icon
  }
}
