// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/utils/extension.dart';

// Project imports:

import '../../../core/config/l10n/generated/l10n.dart';
import 'assistance_pagination.dart';
import 'text_widget.dart';

class ResponsiveListWidget<MODEL> extends StatelessWidget {
  final List<MODEL> items;
  final Widget Function(BuildContext context, MODEL item, int index)
  itemBuilder;
  final EdgeInsetsGeometry? margin;
  final double? percentHeight;
  final double? maxCrossAxisExtent;
  final ScrollPhysics? physics;
  final Widget Function(BuildContext)? noDataAvailable;
  final ListType listType;
  final double? gapItem;
  final bool reverse;
  final bool shrinkWrap;
  final bool hasRefreshIndicator;
  final VoidCallback? onRefresh;
  final int? crossAxisCount;
  final double? childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;

  const ResponsiveListWidget({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.margin,
    this.percentHeight,
    this.maxCrossAxisExtent,
    this.physics,
    this.noDataAvailable,
    this.listType = ListType.both,
    this.reverse = false,
    this.shrinkWrap = false,
    this.hasRefreshIndicator = true,
    this.onRefresh,
    this.crossAxisCount,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.gapItem = 10,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = _buildContent(context);

    if (hasRefreshIndicator && onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async => onRefresh!(),
        child: content,
      );
    }

    return content;
  }

  Widget _buildContent(BuildContext context) {
    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    return switch (listType) {
      ListType.list => _buildListView(context),
      ListType.grid => _buildGridView(context),
      ListType.both =>
        context.isMobile ? _buildListView(context) : _buildGridView(context),
    };
  }

  Widget _buildListView(BuildContext context) {
    return ListView.separated(
      physics: physics,
      padding: margin ?? EdgeInsets.only(bottom: context.bottomPadding),
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: gapItem ?? 10),
      itemBuilder:
          (context, index) => itemBuilder(context, items[index], index),
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      physics: physics,
      padding: margin ?? EdgeInsets.only(bottom: context.bottomPadding),
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent:
            maxCrossAxisExtent ?? context.sizeSide.smallSide / 2.2,
        childAspectRatio:
            childAspectRatio ??
            getRatio(
              context,
              percentHeight ??
                  (context.orientationInfo.isPortrait ? 0.75 : 0.6),
            ),
        crossAxisSpacing: crossAxisSpacing ?? gapItem ?? 8,
        mainAxisSpacing: mainAxisSpacing ?? gapItem ?? 8,
      ),
      itemBuilder:
          (context, index) => itemBuilder(context, items[index], index),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return noDataAvailable?.call(context) ??
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nice animated container with gradient background
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey[200]!, Colors.grey[100]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 56,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 24),
                // Main message
                TextWidget(
                  text: S.of(context).no_item_found,
                  style: context.titleL?.copyWith(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // Helpful description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextWidget(
                    text:
                        "We couldn't find any items to display at the moment. Please check back later or try refreshing.",
                    style: context.bodyM?.copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                // Optional refresh button if onRefresh is available
                if (onRefresh != null) ...[
                  ElevatedButton.icon(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const TextWidget(text: "Refresh"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
  }

  double getRatio(BuildContext context, double percent) {
    // Improved aspect ratio calculation to prevent overflow
    double baseRatio =
        context.orientationInfo.isPortrait
            ? (context.sizeSide.width / context.sizeSide.largeSide) * percent
            : (context.sizeSide.height / context.sizeSide.largeSide) * percent;

    // Ensure minimum ratio to prevent extremely tall items
    return baseRatio.clamp(0.5, 1.5);
  }
}
