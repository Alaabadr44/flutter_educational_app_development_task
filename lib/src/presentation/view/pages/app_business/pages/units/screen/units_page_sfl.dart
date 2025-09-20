import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/config/app_colors.dart';

import '../../../../../../../core/utils/layout/responsive_layout.dart';
import '../../../../../../../core/utils/extension.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../domain/entities/subjects_data.dart';
import '../../../../../../../domain/entities/unit_data.dart';
import '../../../../../../view_model/blocs/data_bloc/typedefs_bloc.dart';
import '../../../../../common/assistance_pagination.dart';
import '../../../../../common/responsive_list_widget.dart';
import '../../../../../common/text_widget.dart';
import '../../../../../general/app_indicator.dart';
import '../controller/units_controller.dart';
import '../widgets/unit_compact_card.dart';
import '../widgets/unit_details_dialog.dart';

class UnitsPageSfl extends StatefulWidget {
  final Subject subject;
  const UnitsPageSfl({super.key, required this.subject});

  @override
  State<UnitsPageSfl> createState() => _UnitsPageSflState();
}

class _UnitsPageSflState extends State<UnitsPageSfl>
    with SingleTickerProviderStateMixin {
  late UnitsController _pageController;
  late TextEditingController _searchController;
  final Set<int> _expandedUnits = <int>{};
  String _searchQuery = '';
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _pageController = UnitsController();
    _pageController.initDependencies(context: context, subject: widget.subject);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.disposeDependencies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      isPadding: false,
      appBar: AppBar(
        title: Text(widget.subject.name ?? 'الوحدات الدراسية'),
        actions: [
          // Search toggle
          IconButton(
            onPressed: () => setState(() => _showSearch = !_showSearch),
            icon: Icon(_showSearch ? Icons.search_off : Icons.search),
            tooltip: _showSearch ? 'إخفاء البحث' : 'البحث',
          ),
          // View toggle button
          ValueListenableBuilder(
            valueListenable: _pageController.listTypeNotifier,
            builder: (context, listType, child) {
              return IconButton(
                onPressed: () => _pageController.toggleView(),
                icon: Icon(
                  listType == ListType.grid ? Icons.view_list : Icons.grid_view,
                ),
                tooltip: listType == ListType.grid ? 'List View' : 'Grid View',
              );
            },
          ),
        ],
      ),
      builder: (context, info) {
        return Column(
          children: [
            // Subject Header
            _buildSubjectHeader(),

            // Search bar
            if (_showSearch) _buildSearchBar(),

            // Units content
            Expanded(
              child: BlocDataBuilder<UnitData>(
                bloc: _pageController.unitsBloc,
                builder: (context, state) {
                  return state.maybeMap(
                    loading: (value) => const Center(child: AppIndicator()),
                    orElse:
                        () => const Center(
                          child: TextWidget(text: "لا توجد وحدات متاحة"),
                        ),
                    successList:
                        (data) => _buildUnitsContent(context, data.data!),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubjectHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.primaryColor.withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Subject image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child:
                widget.subject.img != null && widget.subject.img!.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        _getCompleteImageUrl(widget.subject.img!),
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.book,
                              size: 40,
                              color: AppColors.primaryColor,
                            ),
                      ),
                    )
                    : Icon(Icons.book, size: 40, color: AppColors.primaryColor),
          ),

          const SizedBox(width: 16),

          // Subject info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subject.name ?? 'اسم المادة غير متوفر',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Subject details
                Row(
                  children: [
                    if (widget.subject.type != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              widget.subject.type == 'required'
                                  ? AppColors.primaryColor
                                  : AppColors.successColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.subject.type == 'required'
                              ? 'إجباري'
                              : 'اختياري',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    if (widget.subject.price != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              widget.subject.price! > 0
                                  ? Colors.orange.withOpacity(0.2)
                                  : Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                widget.subject.price! > 0
                                    ? Colors.orange
                                    : Colors.green,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.subject.price! > 0
                              ? '${widget.subject.price} ر.س'
                              : 'مجاني',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                widget.subject.price! > 0
                                    ? Colors.orange[700]
                                    : Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // Progress info
                if (widget.subject.lessonsCount != null &&
                    widget.subject.lessonsCount! > 0) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.subject.finishesLessonsCount ?? 0} من ${widget.subject.lessonsCount} دروس مكتملة',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'البحث في الوحدات والدروس...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    icon: const Icon(Icons.clear),
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value.toLowerCase());
        },
      ),
    );
  }

  Widget _buildUnitsContent(BuildContext context, List<UnitData> units) {
    final filteredUnits = _filterUnits(units);

    if (filteredUnits.isEmpty) {
      return _searchQuery.isNotEmpty
          ? _buildNoSearchResults()
          : _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ValueListenableBuilder<ListType>(
        valueListenable: _pageController.listTypeNotifier,
        builder: (context, listType, child) {
          if (listType == ListType.list) {
            return _buildExpandableUnitsList(filteredUnits);
          } else {
            return _buildUnitsGrid(filteredUnits);
          }
        },
      ),
    );
  }

  Widget _buildExpandableUnitsList(List<UnitData> units) {
    return ListView.separated(
      itemCount: units.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final unit = units[index];
        final isExpanded = _expandedUnits.contains(unit.id);

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Unit header
              InkWell(
                onTap: () => _toggleUnitExpansion(unit.id),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Container(
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Unit icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.library_books,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Unit info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              unit.name ?? 'اسم الوحدة غير متوفر',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${unit.lessons?.length ?? 0} دروس',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Expand icon
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Lessons list
              if (isExpanded &&
                  unit.lessons != null &&
                  unit.lessons!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    children:
                        unit.lessons!
                            .asMap()
                            .entries
                            .map(
                              (entry) =>
                                  _buildLessonTile(entry.value, entry.key + 1),
                            )
                            .toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnitsGrid(List<UnitData> units) {
    return ResponsiveListWidget<UnitData>(
      items: units,
      listType: ListType.grid,
      shrinkWrap: false,
      hasRefreshIndicator: true,
      onRefresh: () async {
        _pageController.getUnits();
      },
      childAspectRatio: 0.85,
      maxCrossAxisExtent: 280,
      itemBuilder: (context, unit, index) {
        return UnitCompactCard(unit: unit, onTap: () => _onUnitTap(unit));
      },
    );
  }

  Widget _buildLessonTile(Lesson lesson, int lessonNumber) {
    final isCompleted = lesson.childAnswersPoint != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _onLessonTap(lesson),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isCompleted
                    ? AppColors.successColor.withOpacity(0.1)
                    : Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isCompleted
                      ? AppColors.successColor.withOpacity(0.3)
                      : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Lesson number
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      isCompleted
                          ? AppColors.successColor
                          : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child:
                      isCompleted
                          ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                          : Text(
                            '$lessonNumber',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),

              const SizedBox(width: 12),

              // Lesson info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.name ?? 'اسم الدرس غير متوفر',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(children: _buildLessonFeatures(lesson)),
                  ],
                ),
              ),

              // Progress indicator
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'مكتمل',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.successColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[100]!, Colors.blue[50]!],
                ),
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.library_books_outlined,
                size: 60,
                color: Colors.blue[400],
              ),
            ),
            const SizedBox(height: 24),
            const TextWidget(
              text: 'لا توجد وحدات متاحة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextWidget(
              text: 'سيتم إضافة الوحدات الدراسية قريباً',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _pageController.getUnits(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text(
                'تحديث',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onUnitTap(UnitData unit) {
    showUnitDetailsDialog(context, unit, (lesson) {
      Navigator.of(context).pop(); // Close dialog first
      _onLessonTap(lesson);
    });
  }

  void _onLessonTap(Lesson lesson) {
    // Navigate to questions page with lesson parameter
    context.nextNamed(AppLocalRoute.questions.route, argument: lesson);
  }

  // Helper methods
  String _getCompleteImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return 'https://taseese.org$imagePath';
  }

  List<UnitData> _filterUnits(List<UnitData> units) {
    if (_searchQuery.isEmpty) return units;

    return units.where((unit) {
      // Search in unit name
      final unitNameMatch = (unit.name ?? '').toLowerCase().contains(
        _searchQuery,
      );

      // Search in lessons
      final lessonsMatch =
          unit.lessons?.any(
            (lesson) =>
                (lesson.name ?? '').toLowerCase().contains(_searchQuery),
          ) ??
          false;

      return unitNameMatch || lessonsMatch;
    }).toList();
  }

  void _toggleUnitExpansion(int? unitId) {
    if (unitId == null) return;

    setState(() {
      if (_expandedUnits.contains(unitId)) {
        _expandedUnits.remove(unitId);
      } else {
        _expandedUnits.add(unitId);
      }
    });
  }

  List<Widget> _buildLessonFeatures(Lesson lesson) {
    final features = <Widget>[];

    if (lesson.videoCode != null && lesson.videoCode!.isNotEmpty) {
      features.add(_buildFeatureChip(Icons.play_circle, 'فيديو', Colors.red));
    }

    if (lesson.isAudio == 1 ||
        (lesson.audioFile != null && lesson.audioFile.toString().isNotEmpty)) {
      features.add(_buildFeatureChip(Icons.headphones, 'صوت', Colors.orange));
    }

    if (lesson.pdfFile != null && lesson.pdfFile!.isNotEmpty) {
      features.add(_buildFeatureChip(Icons.picture_as_pdf, 'PDF', Colors.blue));
    }

    if (lesson.textDesc != null && lesson.textDesc.toString().isNotEmpty) {
      features.add(_buildFeatureChip(Icons.text_fields, 'نص', Colors.green));
    }

    return features;
  }

  Widget _buildFeatureChip(IconData icon, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.orange[100]!, Colors.orange[50]!],
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.search_off,
                size: 50,
                color: Colors.orange[400],
              ),
            ),
            const SizedBox(height: 20),
            const TextWidget(
              text: 'لم يتم العثور على نتائج',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextWidget(
              text: 'لا توجد وحدات أو دروس تطابق البحث "$_searchQuery"',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.clear),
              label: const Text(
                'مسح البحث',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
