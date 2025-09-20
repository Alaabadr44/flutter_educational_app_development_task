import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Test enum for auth way selection
enum AuthWay { phone, email }

/// Simple Widget Tests for Login Page Components
///
/// These tests focus on testing individual components and UI elements
/// without requiring the full dependency injection setup.
void main() {
  group('Login Page Component Tests', () {
    group('Form Validation Tests', () {
      testWidgets('email validator should work correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormBuilderState>();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: FormBuilderTextField(
                name: 'email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);

        // Test empty field
        await tester.enterText(find.byType(FormBuilderTextField), '');
        expect(formKey.currentState!.validate(), isFalse);
        expect(
          formKey.currentState!.errors['email'],
          equals('Email is required'),
        );

        // Test invalid email
        await tester.enterText(
          find.byType(FormBuilderTextField),
          'invalid-email',
        );
        await tester.pump();
        expect(formKey.currentState!.validate(), isFalse);
        expect(
          formKey.currentState!.errors['email'],
          equals('Enter a valid email'),
        );

        // Test valid email
        await tester.enterText(
          find.byType(FormBuilderTextField),
          'test@example.com',
        );
        await tester.pump();
        expect(formKey.currentState!.validate(), isTrue);
        expect(formKey.currentState!.errors['email'], isNull);
      });

      testWidgets('phone validator should work correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormBuilderState>();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: FormBuilderTextField(
                name: 'phone',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone is required';
                  }
                  if (value.length < 10) {
                    return 'Phone must be at least 10 digits';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);

        // Test empty field
        await tester.enterText(find.byType(FormBuilderTextField), '');
        expect(formKey.currentState!.validate(), isFalse);
        expect(
          formKey.currentState!.errors['phone'],
          equals('Phone is required'),
        );

        // Test short phone
        await tester.enterText(find.byType(FormBuilderTextField), '123');
        await tester.pump();
        expect(formKey.currentState!.validate(), isFalse);
        expect(
          formKey.currentState!.errors['phone'],
          equals('Phone must be at least 10 digits'),
        );

        // Test valid phone
        await tester.enterText(
          find.byType(FormBuilderTextField),
          '01234567890',
        );
        await tester.pump();
        expect(formKey.currentState!.validate(), isTrue);
        expect(formKey.currentState!.errors['phone'], isNull);
      });

      testWidgets('password validator should work correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormBuilderState>();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: FormBuilderTextField(
                name: 'password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);

        // Test empty field
        await tester.enterText(find.byType(FormBuilderTextField), '');
        expect(formKey.currentState!.validate(), isFalse);
        expect(
          formKey.currentState!.errors['password'],
          equals('Password is required'),
        );

        // Test short password
        await tester.enterText(find.byType(FormBuilderTextField), '123');
        await tester.pump();
        expect(formKey.currentState!.validate(), isFalse);
        expect(
          formKey.currentState!.errors['password'],
          equals('Password must be at least 6 characters'),
        );

        // Test valid password
        await tester.enterText(find.byType(FormBuilderTextField), '123456');
        await tester.pump();
        expect(formKey.currentState!.validate(), isTrue);
        expect(formKey.currentState!.errors['password'], isNull);
      });
    });

    group('UI Component Tests', () {
      testWidgets('password visibility toggle should work', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool isObscured = true;

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    TextField(
                      obscureText: isObscured,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          key: const Key('toggle_button'),
                          icon: Icon(
                            isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscured = !isObscured;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        // Act & Assert
        await tester.pumpWidget(testWidget);

        // Initially should be obscured
        TextField textField = tester.widget(find.byType(TextField));
        expect(textField.obscureText, isTrue);
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);

        // Tap to toggle
        await tester.tap(find.byKey(const Key('toggle_button')));
        await tester.pump();

        // Should now be visible
        textField = tester.widget(find.byType(TextField));
        expect(textField.obscureText, isFalse);
        expect(find.byIcon(Icons.visibility), findsOneWidget);

        // Tap to toggle back
        await tester.tap(find.byKey(const Key('toggle_button')));
        await tester.pump();

        // Should be obscured again
        textField = tester.widget(find.byType(TextField));
        expect(textField.obscureText, isTrue);
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      });

      testWidgets('remember me checkbox should toggle', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool rememberMe = false;

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  children: [
                    Checkbox(
                      key: const Key('remember_checkbox'),
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Remember me'),
                  ],
                );
              },
            ),
          ),
        );

        // Act & Assert
        await tester.pumpWidget(testWidget);

        // Initially should be unchecked
        Checkbox checkbox = tester.widget(
          find.byKey(const Key('remember_checkbox')),
        );
        expect(checkbox.value, isFalse);

        // Tap to check
        await tester.tap(find.byKey(const Key('remember_checkbox')));
        await tester.pump();

        // Should now be checked
        checkbox = tester.widget(find.byKey(const Key('remember_checkbox')));
        expect(checkbox.value, isTrue);

        // Tap to uncheck
        await tester.tap(find.byKey(const Key('remember_checkbox')));
        await tester.pump();

        // Should be unchecked again
        checkbox = tester.widget(find.byKey(const Key('remember_checkbox')));
        expect(checkbox.value, isFalse);
      });

      testWidgets('radio buttons should work for auth way selection', (
        WidgetTester tester,
      ) async {
        // Arrange
        AuthWay selectedAuthWay = AuthWay.phone;

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    RadioListTile<AuthWay>(
                      key: const Key('phone_radio'),
                      title: const Text('Phone'),
                      value: AuthWay.phone,
                      groupValue: selectedAuthWay,
                      onChanged: (value) {
                        setState(() {
                          selectedAuthWay = value!;
                        });
                      },
                    ),
                    RadioListTile<AuthWay>(
                      key: const Key('email_radio'),
                      title: const Text('Email'),
                      value: AuthWay.email,
                      groupValue: selectedAuthWay,
                      onChanged: (value) {
                        setState(() {
                          selectedAuthWay = value!;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );

        // Act & Assert
        await tester.pumpWidget(testWidget);

        // Initially phone should be selected
        RadioListTile<AuthWay> phoneRadio = tester.widget(
          find.byKey(const Key('phone_radio')),
        );
        RadioListTile<AuthWay> emailRadio = tester.widget(
          find.byKey(const Key('email_radio')),
        );
        expect(phoneRadio.groupValue, equals(AuthWay.phone));
        expect(emailRadio.groupValue, equals(AuthWay.phone));

        // Tap email radio
        await tester.tap(find.byKey(const Key('email_radio')));
        await tester.pump();

        // Email should now be selected
        phoneRadio = tester.widget(find.byKey(const Key('phone_radio')));
        emailRadio = tester.widget(find.byKey(const Key('email_radio')));
        expect(phoneRadio.groupValue, equals(AuthWay.email));
        expect(emailRadio.groupValue, equals(AuthWay.email));

        // Tap phone radio
        await tester.tap(find.byKey(const Key('phone_radio')));
        await tester.pump();

        // Phone should be selected again
        phoneRadio = tester.widget(find.byKey(const Key('phone_radio')));
        emailRadio = tester.widget(find.byKey(const Key('email_radio')));
        expect(phoneRadio.groupValue, equals(AuthWay.phone));
        expect(emailRadio.groupValue, equals(AuthWay.phone));
      });
    });

    group('Form Builder Integration Tests', () {
      testWidgets('form should collect all field values correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormBuilderState>();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    key: const Key('email_field'),
                    name: 'email',
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  FormBuilderTextField(
                    key: const Key('password_field'),
                    name: 'password',
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  FormBuilderCheckbox(
                    key: const Key('remember_field'),
                    name: 'remember_me',
                    title: const Text('Remember me'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);

        // Fill form fields
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.tap(find.byKey(const Key('remember_field')));
        await tester.pump();

        // Save form
        formKey.currentState!.save();

        // Assert
        final formValue = formKey.currentState!.value;
        expect(formValue['email'], equals('test@example.com'));
        expect(formValue['password'], equals('password123'));
        expect(formValue['remember_me'], equals(true));
      });

      testWidgets('form should save field values correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormBuilderState>();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  FormBuilderTextField(
                    name: 'password',
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  ElevatedButton(
                    key: const Key('save_button'),
                    onPressed: () {
                      formKey.currentState!.save();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);

        // Fill fields
        await tester.enterText(
          find.byWidgetPredicate(
            (widget) =>
                widget is FormBuilderTextField && widget.name == 'email',
          ),
          'test@example.com',
        );
        await tester.enterText(
          find.byWidgetPredicate(
            (widget) =>
                widget is FormBuilderTextField && widget.name == 'password',
          ),
          'password123',
        );

        await tester.tap(find.byKey(const Key('save_button')));
        await tester.pump();

        // Assert - values should be saved
        final formValue = formKey.currentState!.value;
        expect(formValue['email'], equals('test@example.com'));
        expect(formValue['password'], equals('password123'));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('form fields should have proper semantics', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextField(
                  autofillHints: [AutofillHints.username],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email or Phone',
                    hintText: 'Enter your email or phone',
                  ),
                ),
                TextField(
                  autofillHints: [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                ),
              ],
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        final textFields =
            tester.widgetList<TextField>(find.byType(TextField)).toList();

        // First field (email/phone)
        expect(textFields[0].autofillHints, contains(AutofillHints.username));
        expect(textFields[0].textInputAction, equals(TextInputAction.next));
        expect(textFields[0].obscureText, isFalse);

        // Second field (password)
        expect(textFields[1].autofillHints, contains(AutofillHints.password));
        expect(textFields[1].textInputAction, equals(TextInputAction.done));
        expect(textFields[1].obscureText, isTrue);
      });

      testWidgets('buttons should be accessible', (WidgetTester tester) async {
        // Arrange
        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Sign In')),
                FloatingActionButton(
                  onPressed: () {},
                  tooltip: 'Fill with test data',
                  child: const Icon(Icons.login),
                ),
              ],
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);

        // Assert
        expect(find.text('Sign In'), findsOneWidget);
        expect(find.byIcon(Icons.login), findsOneWidget);

        final fab = tester.widget<FloatingActionButton>(
          find.byType(FloatingActionButton),
        );
        expect(fab.tooltip, equals('Fill with test data'));
      });
    });

    group('Performance Tests', () {
      testWidgets('form should build efficiently', (WidgetTester tester) async {
        // Arrange
        final stopwatch = Stopwatch()..start();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Column(
                children: List.generate(
                  10,
                  (index) => FormBuilderTextField(
                    name: 'field_$index',
                    decoration: InputDecoration(labelText: 'Field $index'),
                  ),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(find.byType(FormBuilderTextField), findsNWidgets(10));
      });

      testWidgets('should handle rapid interactions efficiently', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool isToggled = false;

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ElevatedButton(
                  key: const Key('toggle_button'),
                  onPressed: () {
                    setState(() {
                      isToggled = !isToggled;
                    });
                  },
                  child: Text(isToggled ? 'ON' : 'OFF'),
                );
              },
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);

        // Rapid taps
        for (int i = 0; i < 10; i++) {
          await tester.tap(find.byKey(const Key('toggle_button')));
          await tester.pump(const Duration(milliseconds: 10));
        }

        // Assert
        expect(find.byKey(const Key('toggle_button')), findsOneWidget);
        // Text should be 'OFF' after even number of taps
        expect(find.text('OFF'), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle null and empty values', (
        WidgetTester tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormBuilderState>();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: FormBuilderTextField(
                name: 'test_field',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Field cannot be empty';
                  }
                  return null;
                },
              ),
            ),
          ),
        );

        // Act & Assert
        await tester.pumpWidget(testWidget);

        // Test null/empty
        await tester.enterText(find.byType(FormBuilderTextField), '');
        expect(formKey.currentState!.validate(), isFalse);

        // Test whitespace only
        await tester.enterText(find.byType(FormBuilderTextField), '   ');
        expect(formKey.currentState!.validate(), isFalse);

        // Test valid value
        await tester.enterText(find.byType(FormBuilderTextField), 'valid');
        expect(formKey.currentState!.validate(), isTrue);
      });

      testWidgets('should handle long input values', (
        WidgetTester tester,
      ) async {
        // Arrange
        final longText = 'a' * 1000;
        final controller = TextEditingController();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: TextField(
              key: const Key('long_text_field'),
              controller: controller,
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.enterText(
          find.byKey(const Key('long_text_field')),
          longText,
        );
        await tester.pump();

        // Assert
        expect(controller.text, equals(longText));
      });

      testWidgets('should handle special characters', (
        WidgetTester tester,
      ) async {
        // Arrange
        const specialText = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
        final controller = TextEditingController();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: TextField(
              key: const Key('special_text_field'),
              controller: controller,
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.enterText(
          find.byKey(const Key('special_text_field')),
          specialText,
        );
        await tester.pump();

        // Assert
        expect(controller.text, equals(specialText));
      });
    });
  });
}
