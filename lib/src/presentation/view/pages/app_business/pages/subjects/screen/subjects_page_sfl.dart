import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/utils/extension.dart';

import '../../../../../../../core/config/l10n/generated/l10n.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/layout/responsive_layout.dart';
import '../../../../../../../domain/entities/subjects_data.dart';
import '../../../../../../view_model/blocs/data_bloc/typedefs_bloc.dart';
import '../../../../../common/assistance_pagination.dart';
import '../../../../../common/responsive_list_widget.dart';
import '../../../../../common/text_widget.dart';
import '../../../../../general/app_indicator.dart';
import '../../../models/user_selections_model.dart';
import '../controller/subjects_controller.dart';
import '../widgets/subject_card.dart';
import '../widgets/subject_compact_card.dart';

class SubjectsPageSfl extends StatefulWidget {
  final UserSelectionsModel userSelections;
  const SubjectsPageSfl({super.key, required this.userSelections});

  @override
  State<SubjectsPageSfl> createState() => _SubjectsPageSflState();
}

class _SubjectsPageSflState extends State<SubjectsPageSfl>
    with SingleTickerProviderStateMixin {
  late SubjectsController _pageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = SubjectsController();
    _pageController.initDependencies(
      context: context,
      userSelections: widget.userSelections,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.disposeDependencies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          // Navigate back to dashboard instead of default back behavior
          context.nextReplacementNamed(AppLocalRoute.dashboard.route);
        }
      },
      child: ResponsiveLayout(
        isPadding: true,
        appBar: AppBar(
          title: Text(S.current.subjects),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to dashboard when back button is pressed
              context.nextReplacementNamed(AppLocalRoute.dashboard.route);
            },
          ),
          actions: [
            // View toggle button
            ValueListenableBuilder(
              valueListenable: _pageController.listTypeNotifier,
              builder: (context, listType, child) {
                return IconButton(
                  onPressed: () => _pageController.toggleView(),
                  icon: Icon(
                    listType == ListType.grid
                        ? Icons.view_list
                        : Icons.grid_view,
                  ),
                  tooltip:
                      listType == ListType.grid
                          ? S.current.list_view
                          : S.current.grid_view,
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: const Icon(Icons.star),
                text: S.current.required_subjects,
              ),
              Tab(
                icon: const Icon(Icons.star_border),
                text: S.current.optional_subjects,
              ),
            ],
          ),
        ),
        builder: (context, info) {
          return RefreshIndicator(
            onRefresh: () async {
              _pageController.getSubjects();
              // Wait a bit for the loading to start
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: BlocDataBuilder<SubjectsData>(
              bloc: _pageController.subjectsBloc,
              builder: (context, state) {
                return state.maybeMap(
                  loading: (value) => const Center(child: AppIndicator()),
                  orElse:
                      () => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: TextWidget(
                              text: S.current.no_subjects_available,
                            ),
                          ),
                        ),
                      ),
                  successModel: (data) => _buildTabBarView(context, data.data),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBarView(BuildContext context, SubjectsData? subjectsData) {
    if (subjectsData == null) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: TextWidget(text: S.current.no_subjects_data_available),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // User selections summary
          _buildSelectionsSummary(),
          const SizedBox(height: 16),

          // TabBarView with fixed height
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Required subjects tab
                _buildTabContent(
                  context: context,
                  subjects: subjectsData.required ?? [],
                  isRequired: true,
                  emptyMessage: S.current.no_required_subjects_available,
                ),

                // Optional subjects tab
                _buildTabContent(
                  context: context,
                  subjects: subjectsData.optional ?? [],
                  isRequired: false,
                  emptyMessage: S.current.no_optional_subjects_available,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent({
    required BuildContext context,
    required List<Subject> subjects,
    required bool isRequired,
    required String emptyMessage,
  }) {
    if (subjects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isRequired ? Icons.star_outline : Icons.star_border_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              TextWidget(
                text: emptyMessage,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: _buildSubjectsList(subjects, isRequired: isRequired),
    );
  }

  Widget _buildSelectionsSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Builder(
                builder: (context) {
                  return TextWidget(
                    text: S.current.your_selections,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.userSelections
              .getLocalizedSelectionsSummary(context)
              .entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      TextWidget(
                        text: '${entry.key}: ',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: TextWidget(
                          text: entry.value ?? S.current.not_selected,
                          style: TextStyle(
                            color:
                                entry.value != null
                                    ? Colors.grey[700]
                                    : Colors.grey[500],
                            fontStyle:
                                entry.value != null
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList(
    List<Subject> subjects, {
    required bool isRequired,
  }) {
    return ValueListenableBuilder<ListType>(
      valueListenable: _pageController.listTypeNotifier,
      builder: (context, listType, child) {
        return ResponsiveListWidget<Subject>(
          items: subjects,
          listType: listType,
          shrinkWrap: true,
          hasRefreshIndicator: false,
          physics: const NeverScrollableScrollPhysics(),
          // Only two columns in grid with more space for cards
          childAspectRatio: listType == ListType.grid ? 0.9 : null,
          maxCrossAxisExtent: listType == ListType.grid ? 300 : null,
          itemBuilder: (context, subject, index) {
            return listType == ListType.grid
                ? SubjectCompactCard(
                  subject: subject,
                  onTap: () => _onSubjectTap(subject),
                )
                : SubjectCard(
                  subject: subject,
                  onTap: () => _onSubjectTap(subject),
                );
          },
        );
      },
    );
  }

  void _onSubjectTap(Subject subject) {
    // Show subject details dialog
    showSubjectDetailsDialog(context, subject, (id) {
      context.nextNamed(AppLocalRoute.units.route, argument: subject);
    });
  }
}
