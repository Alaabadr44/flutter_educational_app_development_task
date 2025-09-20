import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_bloc/src/presentation/view/pages/app_business/pages/subjects/controller/subjects_controller.dart';
import 'package:flutter_application_bloc/src/domain/entities/user_model.dart';
import 'package:flutter_application_bloc/src/domain/entities/education_system.dart';
import 'package:flutter_application_bloc/src/domain/entities/academic_term_selection.dart';
import 'package:flutter_application_bloc/src/domain/entities/educational_track_selection.dart';
import 'package:flutter_application_bloc/src/presentation/view/pages/app_business/models/user_selections_model.dart';
import 'package:flutter_application_bloc/src/core/services/user_service.dart';
import 'package:flutter_application_bloc/src/core/utils/page_controller.dart';
import 'package:flutter_application_bloc/src/presentation/view/mixins/list_type_view.dart';

void main() {
  group('SubjectsController Tests', () {
    late SubjectsController controller;
    late UserSelectionsModel testUserSelections;
    late UserModel testUser;

    setUp(() {
      // Set up test data
      testUser = UserModel(
        loginData: LoginData(
          id: 123,
          name: 'Test User',
          email: 'test@example.com',
        ),
      );

      testUserSelections = UserSelectionsModel(
        selectedAcademicTerm: AcademicTermSelection(id: 1, name: 'First Term'),
        selectedEducationalTrack: EducationalTrackSelection(
          id: 2,
          name: 'Scientific Track',
        ),
      );

      // Create controller
      controller = SubjectsController();

      // Set current user for testing
      UserService.setUser = testUser;
    });

    tearDown(() {
      try {
        controller.disposeDependencies();
      } catch (e) {
        // Ignore disposal errors in tests
      }
      // Clear user data
      UserService.setUser = UserModel();
    });

    group('Basic Properties', () {
      test('should initialize with null user selections', () {
        // Assert
        expect(controller.userSelections, isNull);
      });

      test('should implement AppPageController interface', () {
        // Assert
        expect(controller, isA<AppPageController>());
      });

      test('should throw UnimplementedError for route getter', () {
        // Act & Assert
        expect(() => controller.route, throwsUnimplementedError);
      });
    });

    group('User Selections Management', () {
      test(
        'should store user selections when provided during initialization',
        () {
          // Act
          controller.userSelections = testUserSelections;

          // Assert
          expect(controller.userSelections, equals(testUserSelections));
          expect(
            controller.userSelections?.selectedAcademicTerm?.id,
            equals(1),
          );
          expect(
            controller.userSelections?.selectedEducationalTrack?.id,
            equals(2),
          );
        },
      );

      test('should handle null user selections', () {
        // Act
        controller.userSelections = null;

        // Assert
        expect(controller.userSelections, isNull);
      });

      test('should work with minimal user selections', () {
        // Arrange
        final minimalSelections = UserSelectionsModel(
          selectedAcademicTerm: AcademicTermSelection(
            id: 5,
            name: 'Second Term',
          ),
        );

        // Act
        controller.userSelections = minimalSelections;

        // Assert
        expect(controller.userSelections?.selectedAcademicTerm?.id, equals(5));
        expect(controller.userSelections?.selectedEducationalTrack, isNull);
      });

      test('should work with complete user selections', () {
        // Arrange
        final completeSelections = UserSelectionsModel(
          selectedEducationSystem: SelectionData(id: 1, name: 'Public'),
          selectedEducationalStage: SelectionData(id: 7, name: 'High School'),
          selectedAcademicTerm: AcademicTermSelection(
            id: 1,
            name: 'First Term',
          ),
          selectedEducationalTrack: EducationalTrackSelection(
            id: 1,
            name: 'Scientific',
          ),
        );

        // Act
        controller.userSelections = completeSelections;

        // Assert
        expect(controller.userSelections, equals(completeSelections));
        expect(
          controller.userSelections?.selectedEducationSystem?.id,
          equals(1),
        );
        expect(
          controller.userSelections?.selectedEducationalStage?.id,
          equals(7),
        );
        expect(controller.userSelections?.selectedAcademicTerm?.id, equals(1));
        expect(
          controller.userSelections?.selectedEducationalTrack?.id,
          equals(1),
        );
      });
    });

    group('ListTypeView Mixin Integration', () {
      test('should include ListTypeView mixin', () {
        // Assert that the controller has the ListTypeView mixin
        expect(controller, isA<ListTypeView>());
      });
    });

    group('Controller State Management', () {
      test('should allow updating user selections multiple times', () {
        // Act
        controller.userSelections = testUserSelections;
        expect(controller.userSelections?.selectedAcademicTerm?.id, equals(1));

        // Change selections
        final newSelections = UserSelectionsModel(
          selectedAcademicTerm: AcademicTermSelection(
            id: 3,
            name: 'Third Term',
          ),
        );
        controller.userSelections = newSelections;

        // Assert
        expect(controller.userSelections?.selectedAcademicTerm?.id, equals(3));
        expect(controller.userSelections?.selectedEducationalTrack, isNull);
      });

      test('should handle clearing user selections', () {
        // Arrange
        controller.userSelections = testUserSelections;
        expect(controller.userSelections, isNotNull);

        // Act
        controller.userSelections = null;

        // Assert
        expect(controller.userSelections, isNull);
      });
    });

    group('UserService Integration', () {
      test('should work with UserService current user', () {
        // Assert that we can access UserService.currentUser
        expect(UserService.currentUser, isNotNull);
        expect(UserService.currentUser?.loginData?.id, equals(123));
        expect(UserService.currentUser?.loginData?.name, equals('Test User'));
      });

      test('should handle null current user', () {
        // Arrange
        UserService.setUser = UserModel(); // Clear user

        // Assert
        final currentUser = UserService.currentUser;
        expect(currentUser?.loginData?.id, isNull);
      });
    });
  });
}
