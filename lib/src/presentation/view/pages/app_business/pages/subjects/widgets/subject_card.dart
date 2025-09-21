import 'package:flutter/material.dart';

import '../../../../../../../core/config/l10n/generated/l10n.dart';
import '../../../../../../../domain/entities/subjects_data.dart';
import '../../../../../common/text_widget.dart';

class SubjectCard extends StatefulWidget {
  final Subject subject;
  final VoidCallback? onTap;
  final bool showPrice;
  final bool showProgress;

  const SubjectCard({
    super.key,
    required this.subject,
    this.onTap,
    this.showPrice = true,
    this.showProgress = true,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  bool isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with image and subscription status
              Row(
                children: [
                  // Subject image or icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getSubjectColor().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _getSubjectColor().withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child:
                        widget.subject.img != null &&
                                widget.subject.img!.isNotEmpty
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
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
                  const SizedBox(width: 16),

                  // Subject name and type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text:
                              widget.subject.name ?? S.current.unknown_subject,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                          maxLine: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.subject.type != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _getSubjectColor(),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: _getSubjectColor().withOpacity(0.3),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.subject.type!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Subscription status
                  if (widget.subject.isSubscribe != null)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:
                            widget.subject.isSubscribe!
                                ? Colors.green.withOpacity(0.15)
                                : Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              widget.subject.isSubscribe!
                                  ? Colors.green
                                  : Colors.orange,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        widget.subject.isSubscribe!
                            ? Icons.verified
                            : Icons.lock_outline,
                        size: 20,
                        color:
                            widget.subject.isSubscribe!
                                ? Colors.green[700]
                                : Colors.orange[700],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Basic info (always visible)
              _buildBasicInfo(context),

              const SizedBox(height: 12),

              // Details toggle button
              _buildDetailsButton(),

              // Expandable content with proper animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isExpanded ? null : 0,
                child:
                    isExpanded
                        ? Column(
                          children: [
                            const SizedBox(height: 16),
                            _buildExpandedContent(context),
                          ],
                        )
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Icon(Icons.book_outlined, size: 20, color: _getSubjectColor());
  }

  String _getCompleteImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return 'https://taseese.org$imagePath';
  }

  Widget _buildBasicInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price section with Arabic styling
        if (widget.showPrice) _buildCompactPriceSection(context),

        if (widget.showProgress && widget.subject.lessonsCount != null) ...[
          const SizedBox(height: 8),
          _buildCompactProgress(context),
        ],
      ],
    );
  }

  Widget _buildCompactPriceSection(BuildContext context) {
    if (widget.subject.price == null) return const SizedBox.shrink();

    final hasDiscount =
        widget.subject.oldPrice != null &&
        widget.subject.oldPrice! > 0 &&
        widget.subject.oldPrice! > widget.subject.price!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price display
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.price,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (widget.subject.price! > 0) ...[
                    Text(
                      '${widget.subject.price} SAR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _getSubjectColor(),
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${widget.subject.oldPrice} SAR',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        S.current.free,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          // Subscription status
          if (widget.subject.isSubscribe != null)
            Column(
              children: [
                Icon(
                  widget.subject.isSubscribe! ? Icons.verified : Icons.lock,
                  color:
                      widget.subject.isSubscribe!
                          ? Colors.green
                          : Colors.orange,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subject.isSubscribe!
                      ? S.current.subscribed
                      : S.current.not_subscribed,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        widget.subject.isSubscribe!
                            ? Colors.green[700]
                            : Colors.orange[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCompactProgress(BuildContext context) {
    final lessonsCount = widget.subject.lessonsCount ?? 0;
    final finishedLessons = widget.subject.finishesLessonsCount ?? 0;
    final progress = lessonsCount > 0 ? finishedLessons / lessonsCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.lesson_progress,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 8),
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
              const SizedBox(width: 8),
              Text(
                '$finishedLessons/$lessonsCount',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleExpanded,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isExpanded ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                isExpanded ? S.current.hide_details : S.current.show_details,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full price section with discount
        if (widget.showPrice) ...[
          _buildFullPriceSection(context),
          const SizedBox(height: 16),
        ],

        // Subscription button or detailed stats
        _buildSubscriptionSection(context),

        // Comprehensive information
        if (_hasSubjectDetails() || _hasIdData()) ...[
          const SizedBox(height: 16),
          _buildComprehensiveInfo(context),
        ],

        // Answer statistics
        if (widget.subject.trueAnswersCount != null ||
            widget.subject.falseAnswersCount != null) ...[
          const SizedBox(height: 16),
          _buildStatsSection(context),
        ],
      ],
    );
  }

  Widget _buildFullPriceSection(BuildContext context) {
    if (widget.subject.price == null) return const SizedBox.shrink();

    final hasDiscount =
        widget.subject.oldPrice != null &&
        widget.subject.oldPrice! > 0 &&
        widget.subject.oldPrice! > widget.subject.price!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getSubjectColor().withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getSubjectColor().withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.monetization_on, size: 16, color: _getSubjectColor()),
              const SizedBox(width: 6),
              Text(
                S.current.detailed_price,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getSubjectColor(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (widget.subject.price! > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.current.current_price, style: TextStyle(fontSize: 13)),
                Text(
                  '${widget.subject.price} SAR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _getSubjectColor(),
                  ),
                ),
              ],
            ),
            if (hasDiscount) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.previous_price,
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '${widget.subject.oldPrice} SAR',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${S.current.discount} ${_calculateDiscountPercentage()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (widget.subject.teacherPrice != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.teacher_price,
                    style: TextStyle(fontSize: 13, color: Colors.amber[700]),
                  ),
                  Text(
                    '${widget.subject.teacherPrice} SAR',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ] else ...[
            Row(
              children: [
                Icon(Icons.celebration, size: 14, color: Colors.green[700]),
                const SizedBox(width: 6),
                Text(
                  S.current.completely_free_subject,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[700],
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

  Widget _buildSubscriptionSection(BuildContext context) {
    if (widget.subject.isSubscribe == false) {
      return SizedBox(
        width: double.infinity,
        height: 36,
        child: ElevatedButton.icon(
          onPressed: () {
            if (widget.onTap != null) widget.onTap!();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _getSubjectColor(),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.add_shopping_cart, size: 16),
          label: Text(
            S.current.subscribe_now,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified, size: 16, color: Colors.green[700]),
                const SizedBox(width: 6),
                Text(
                  S.current.you_are_subscribed,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (widget.subject.trueAnswersCount != null ||
                widget.subject.falseAnswersCount != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.subject.trueAnswersCount != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.subject.trueAnswersCount} ${S.current.correct}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  if (widget.subject.falseAnswersCount != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cancel, size: 14, color: Colors.red[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.subject.falseAnswersCount} ${S.current.wrong}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ],
        ),
      );
    }
  }

  Widget _buildComprehensiveInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasSubjectDetails()) ...[
          _buildSectionTitle(S.current.subject_details_section),
          const SizedBox(height: 8),
          _buildDetailsGrid(context),
        ],
        if (_hasIdData()) ...[
          const SizedBox(height: 12),
          _buildSectionTitle(S.current.system_information),
          const SizedBox(height: 8),
          _buildIdsSection(context),
        ],
        if (widget.subject.createdAt != null ||
            widget.subject.updatedAt != null) ...[
          const SizedBox(height: 12),
          _buildTimestampsSection(context),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: _getSubjectColor(),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    final details = <String, String>{};

    if (widget.subject.id != null) details['ID'] = '#${widget.subject.id}';
    if (widget.subject.isUnit != null) {
      details[S.current.type] =
          widget.subject.isUnit!
              ? S.current.study_unit
              : S.current.regular_subject;
    }
    if (widget.subject.lessonsCount != null) {
      details[S.current.lessons] = '${widget.subject.lessonsCount}';
    }
    if (widget.subject.finishesLessonsCount != null) {
      details[S.current.completed] = '${widget.subject.finishesLessonsCount}';
    }

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children:
          details.entries
              .map((entry) => _buildDetailChip(entry.key, entry.value))
              .toList(),
    );
  }

  Widget _buildDetailChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdsSection(BuildContext context) {
    final ids = <String, int?>{
      S.current.system: widget.subject.systemId,
      S.current.stage: widget.subject.stageId,
      S.current.classroom: widget.subject.classroomId,
      S.current.term: widget.subject.termId,
      S.current.path: widget.subject.pathId,
    };

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children:
          ids.entries
              .where((entry) => entry.value != null)
              .map((entry) => _buildIdChip(entry.key, entry.value!))
              .toList(),
    );
  }

  Widget _buildIdChip(String label, int id) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: _getSubjectColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _getSubjectColor().withOpacity(0.3)),
      ),
      child: Text(
        '$label: $id',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: _getSubjectColor(),
        ),
      ),
    );
  }

  Widget _buildTimestampsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.subject.createdAt != null) ...[
            Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 12,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${S.current.created_date_label}: ${_formatDate(widget.subject.createdAt!)}',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
          if (widget.subject.updatedAt != null) ...[
            if (widget.subject.createdAt != null) const SizedBox(height: 3),
            Row(
              children: [
                Icon(Icons.update, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${S.current.updated_date_label}: ${_formatDate(widget.subject.updatedAt!)}',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, size: 14, color: Colors.blue[700]),
              const SizedBox(width: 6),
              Text(
                S.current.answer_statistics,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (widget.subject.trueAnswersCount != null) ...[
                _buildStatItem(
                  context,
                  icon: Icons.check_circle,
                  label: S.current.correct,
                  value: '${widget.subject.trueAnswersCount}',
                  color: Colors.green[600]!,
                ),
                const SizedBox(width: 12),
              ],
              if (widget.subject.falseAnswersCount != null) ...[
                _buildStatItem(
                  context,
                  icon: Icons.cancel,
                  label: S.current.wrong,
                  value: '${widget.subject.falseAnswersCount}',
                  color: Colors.red[600]!,
                ),
                const SizedBox(width: 12),
              ],
              if (widget.subject.trueAnswersCount != null &&
                  widget.subject.falseAnswersCount != null) ...[
                _buildAccuracyRate(context),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 9, color: color.withOpacity(0.8)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccuracyRate(BuildContext context) {
    final correct = widget.subject.trueAnswersCount ?? 0;
    final incorrect = widget.subject.falseAnswersCount ?? 0;
    final total = correct + incorrect;
    final accuracy = total > 0 ? (correct / total * 100) : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color:
            accuracy >= 70
                ? Colors.green.withOpacity(0.2)
                : Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            '${accuracy.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: accuracy >= 70 ? Colors.green[700] : Colors.orange[700],
            ),
          ),
          Text(
            S.current.accuracy,
            style: TextStyle(
              fontSize: 8,
              color: accuracy >= 70 ? Colors.green[600] : Colors.orange[600],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasSubjectDetails() {
    return widget.subject.id != null ||
        widget.subject.isUnit != null ||
        widget.subject.lessonsCount != null ||
        widget.subject.finishesLessonsCount != null;
  }

  bool _hasIdData() {
    return widget.subject.systemId != null ||
        widget.subject.stageId != null ||
        widget.subject.classroomId != null ||
        widget.subject.termId != null ||
        widget.subject.pathId != null;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _calculateDiscountPercentage() {
    if (widget.subject.oldPrice == null ||
        widget.subject.price == null ||
        widget.subject.oldPrice! <= widget.subject.price!) {
      return 0;
    }
    final discount =
        ((widget.subject.oldPrice! - widget.subject.price!) /
            widget.subject.oldPrice! *
            100);
    return discount.round();
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
