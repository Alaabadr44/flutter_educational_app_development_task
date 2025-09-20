// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../../../domain/entities/academic_term_selection.dart';
import '../../../../../domain/entities/classroom_grade_selection.dart';
import '../../../../../domain/entities/education_system.dart';
import '../../../../../domain/entities/educational_track_selection.dart';

class UserSelectionsModel {
  final SelectionData? selectedEducationSystem;
  final SelectionData? selectedEducationalStage;
  final ClassroomGradeSelection? selectedClassroom;
  final AcademicTermSelection? selectedAcademicTerm;
  final EducationalTrackSelection? selectedEducationalTrack;

  const UserSelectionsModel({
    this.selectedEducationSystem,
    this.selectedEducationalStage,
    this.selectedClassroom,
    this.selectedAcademicTerm,
    this.selectedEducationalTrack,
  });

  // Factory constructor to create from dashboard controller values
  factory UserSelectionsModel.fromController({
    SelectionData? educationSystem,
    SelectionData? educationalStage,
    ClassroomGradeSelection? classroom,
    AcademicTermSelection? academicTerm,
    EducationalTrackSelection? educationalTrack,
  }) {
    return UserSelectionsModel(
      selectedEducationSystem: educationSystem,
      selectedEducationalStage: educationalStage,
      selectedClassroom: classroom,
      selectedAcademicTerm: academicTerm,
      selectedEducationalTrack: educationalTrack,
    );
  }

  // CopyWith method for updating specific selections
  UserSelectionsModel copyWith({
    SelectionData? selectedEducationSystem,
    SelectionData? selectedEducationalStage,
    ClassroomGradeSelection? selectedClassroom,
    AcademicTermSelection? selectedAcademicTerm,
    EducationalTrackSelection? selectedEducationalTrack,
    bool clearEducationSystem = false,
    bool clearEducationalStage = false,
    bool clearClassroom = false,
    bool clearAcademicTerm = false,
    bool clearEducationalTrack = false,
  }) {
    return UserSelectionsModel(
      selectedEducationSystem:
          clearEducationSystem
              ? null
              : selectedEducationSystem ?? this.selectedEducationSystem,
      selectedEducationalStage:
          clearEducationalStage
              ? null
              : selectedEducationalStage ?? this.selectedEducationalStage,
      selectedClassroom:
          clearClassroom ? null : selectedClassroom ?? this.selectedClassroom,
      selectedAcademicTerm:
          clearAcademicTerm
              ? null
              : selectedAcademicTerm ?? this.selectedAcademicTerm,
      selectedEducationalTrack:
          clearEducationalTrack
              ? null
              : selectedEducationalTrack ?? this.selectedEducationalTrack,
    );
  }

  // Check if all required selections are complete
  bool get isComplete {
    return selectedEducationSystem != null &&
        selectedEducationalStage != null &&
        selectedClassroom != null &&
        selectedAcademicTerm != null &&
        (selectedEducationalStage?.id != 7 || selectedEducationalTrack != null);
  }

  // Check if educational track is required (stage ID == 7)
  bool get isEducationalTrackRequired {
    return selectedEducationalStage?.id == 7;
  }

  // Get completion progress (0.0 to 1.0)
  double get completionProgress {
    int totalRequired = isEducationalTrackRequired ? 5 : 4;
    int completed = 0;

    if (selectedEducationSystem != null) completed++;
    if (selectedEducationalStage != null) completed++;
    if (selectedClassroom != null) completed++;
    if (selectedAcademicTerm != null) completed++;
    if (!isEducationalTrackRequired || selectedEducationalTrack != null) {
      if (isEducationalTrackRequired) completed++;
    }

    return completed / totalRequired;
  }

  // Convert to Map for API requests or storage
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (selectedEducationSystem?.id != null) {
      map['system_id'] = selectedEducationSystem!.id;
    }
    if (selectedEducationalStage?.id != null) {
      map['educational_stage_id'] = selectedEducationalStage!.id;
    }
    if (selectedClassroom?.id != null) {
      map['classroom_id'] = selectedClassroom!.id;
    }
    if (selectedAcademicTerm?.id != null) {
      map['academic_term_id'] = selectedAcademicTerm!.id;
    }
    if (selectedEducationalTrack?.id != null) {
      map['educational_track_id'] = selectedEducationalTrack!.id;
    }

    return map;
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() => toMap();

  // Get user-friendly summary of selections
  Map<String, String?> get selectionsSummary {
    return {
      'Education System': selectedEducationSystem?.name,
      'Educational Stage': selectedEducationalStage?.name,
      'Classroom/Grade': selectedClassroom?.name,
      'Academic Term': selectedAcademicTerm?.name,
      if (isEducationalTrackRequired)
        'Educational Track': selectedEducationalTrack?.name,
    };
  }

  // Equality and hashCode for comparison
  @override
  bool operator ==(covariant UserSelectionsModel other) {
    if (identical(this, other)) return true;

    return other.selectedEducationSystem == selectedEducationSystem &&
        other.selectedEducationalStage == selectedEducationalStage &&
        other.selectedClassroom == selectedClassroom &&
        other.selectedAcademicTerm == selectedAcademicTerm &&
        other.selectedEducationalTrack == selectedEducationalTrack;
  }

  @override
  int get hashCode {
    return selectedEducationSystem.hashCode ^
        selectedEducationalStage.hashCode ^
        selectedClassroom.hashCode ^
        selectedAcademicTerm.hashCode ^
        selectedEducationalTrack.hashCode;
  }

  @override
  String toString() {
    return 'UserSelectionsModel('
        'educationSystem: ${selectedEducationSystem?.name}, '
        'educationalStage: ${selectedEducationalStage?.name}, '
        'classroom: ${selectedClassroom?.name}, '
        'academicTerm: ${selectedAcademicTerm?.name}, '
        'educationalTrack: ${selectedEducationalTrack?.name}, '
        'isComplete: $isComplete, '
        'progress: ${(completionProgress * 100).toStringAsFixed(1)}%'
        ')';
  }
}
