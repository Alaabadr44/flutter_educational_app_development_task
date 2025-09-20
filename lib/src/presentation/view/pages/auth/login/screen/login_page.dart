import 'package:flutter/material.dart';
import '../../../../../../core/config/injector.dart';
// Package imports:
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import '../../../../../../core/config/app_colors.dart';
import '../../../../../../core/config/l10n/generated/l10n.dart';
import '../../../../../../core/services/device_info_service.dart';
import '../../../../../../core/services/environment_service.dart';
import '../../../../../../core/utils/enums.dart';
import '../../../../../../core/utils/extension.dart';
import '../../../../../../core/utils/layout/responsive_layout.dart';
import '../../../../../../domain/entities/user_model.dart';
import '../../../../../view_model/blocs/auth_bloc/auth_bloc.dart';
import '../../../../../view_model/blocs/data_bloc/typedefs_bloc.dart';
import '../../../../app_logo.dart';
import '../../../../common/animation_widget.dart';
import '../../../../common/containers/general_container.dart';
import '../../../../common/fields/_field_helper/decoration_field.dart';
import '../../../../common/fields/_field_helper/form_key.dart';
import '../../../../common/fields/generic_text_field.dart';
import '../../../../common/text_widget.dart';
import '../controller/login_controller.dart';
import '../widget_keys.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController loginController;

  @override
  void initState() {
    super.initState();
    loginController = LoginController()..initDependencies();
  }

  void _fillWithTestData() {
    if (loginController.globalKey.currentState != null) {
      // Fill the form with test data
      loginController.globalKey.currentState!.patchValue({
        "email_or_phone": "01143525377",
        "password": "123456",
      });

      // Show success message with multiple feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.test_credentials_filled,
                style: context.bodyL?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                S.current.ready_to_login,
                style: context.bodyL?.copyWith(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  void dispose() {
    loginController.disposeDependencies();
    super.dispose();
  }





  void _onLoginSuccesses(BuildContext context) {
     loginController.saveValueIfRememberMe();
    
    loginController.playSound();
    context.nextReplacementNamed(
      AppLocalRoute.dashboard.route,
    );
  }



  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      showAppBar: false,
      onBackAllApp: (context) {
        loginController
            .authWithEmailPassword
            .authWithEmailPassword
            .cancelRequest
            ?.cancel();
      },
      builder: (context, info) {
        return BlocAuthListener<UserModel>(
          bloc:
              loginController.authWithEmailPassword.authWithEmailPassword
                  as AuthBloc<UserModel>,
          listener:
              (context, state) =>
                  loginController.authWithEmailPassword.listenLoginState(
                    state,
                    onSuccess: (data) {
                      _onLoginSuccesses(context);
                    },
                  ),
          child: AnimationWidget(
            type: AnimationDirection.fade,
            key: const Key(LoginPageKeys.animationWidget),
            child: Container(
              key: const Key(LoginPageKeys.mainContainer),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: FormKey(
                  formKey: loginController.globalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Offstage(
                        child: GenericTextField(
                          name: 'type',
                          initialValue: "child",
                        ),
                      ),
                      Offstage(
                        child: GenericTextField(
                          name: 'mobile_id',
                          initialValue: injector<DeviceInfoService>().deviceId,
                        ),
                      ),
                      Offstage(
                        child: GenericTextField(
                          name: 'device_type',
                          initialValue: context.deviceName,
                        ),
                      ),
                      // Logo Section
                      GeneralContainer.white(
                        key: const Key(LoginPageKeys.logoContainer),
                        padding: const EdgeInsets.all(20),
                        borderRadius: 20,
                        shadowColor: AppColors.primaryColor.withOpacity(0.1),
                        shadowBlurRadius: 20,
                        shadowOffset: const Offset(0, 10),
                        child: const Center(
                          child: AppLogo(key: Key(LoginPageKeys.appLogo)),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Welcome Text
                      Container(
                        key: const Key(LoginPageKeys.welcomeText),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextWidget(
                          text: S.current.welcome_back,
                          style: context.headlineL?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextWidget(
                        key: const Key(LoginPageKeys.subtitleText),
                        text: S.current.please_sign_in_to_your_account,
                        style: context.bodyL?.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Auth Way Selection (Phone/Email)
                      ValueListenableBuilder<AuthWay>(
                        valueListenable: loginController.authWayNotifier,
                        builder: (context, authWay, _) {
                          return Row(
                            children: [
                              Expanded(
                                child: RadioListTile<AuthWay>(
                                  title: TextWidget(
                                    text: S.current.phone,
                                    style: context.bodyM,
                                  ),
                                  value: AuthWay.phone,
                                  groupValue: authWay,
                                  onChanged: loginController.toggleAuthWay,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<AuthWay>(
                                  title: TextWidget(
                                    text: S.current.email,
                                    style: context.bodyM,
                                  ),
                                  value: AuthWay.email,
                                  groupValue: authWay,
                                  onChanged: loginController.toggleAuthWay,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Username Field with dynamic validation and icon
                      ValueListenableBuilder<AuthWay>(
                        valueListenable: loginController.authWayNotifier,
                        builder: (context, authWay, _) {
                          bool isPhone = authWay == AuthWay.phone;
                          return GeneralContainer.white(
                            child: GenericTextField(
                              key: const Key(LoginPageKeys.emailOrPhone),
                              name: 'email_or_phone',
                              autofillHints: const [AutofillHints.username],
                              textType:
                                  isPhone
                                      ? TextInputType.phone
                                      : TextInputType.emailAddress,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                if (authWay == AuthWay.email)
                                  FormBuilderValidators.email(),
                                if (authWay == AuthWay.phone)
                                  FormBuilderValidators.minLength(10),
                              ]),
                              obscureText: false,
                              textInputAction: TextInputAction.next,
                              decorationField:
                                  DecorationFields.generalDecorationField(
                                    context,
                                    labelText:
                                        isPhone
                                            ? S.current.phone_number
                                            : S.current.email_address,
                                    hintText:
                                        isPhone
                                            ? S.current.hintLoginPhoneNumber
                                            : S.current.hintEmail,
                                    prefixIcon: Container(
                                      padding: const EdgeInsets.all(12),
                                      child: Icon(
                                        isPhone
                                            ? Icons.phone_outlined
                                            : Icons.email_outlined,
                                        color: AppColors.primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      GeneralContainer.white(
                        key: const Key(LoginPageKeys.passwordContainer),
                        child: ValueListenableBuilder(
                          valueListenable: loginController.passwordNotifier,
                          builder: (context, isSecure, _) {
                            return GenericTextField(
                              key: const Key(LoginPageKeys.passwordField),
                              name: 'password',
                              autofillHints: const [AutofillHints.password],
                              textType: TextInputType.text,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText:
                                      context
                                          .localText
                                          .validator_field_required_title,
                                ),
                                FormBuilderValidators.minLength(6),
                              ]),
                              obscureText: isSecure,
                              textInputAction: TextInputAction.done,
                              decorationField:
                                  DecorationFields.generalDecorationField(
                                    context,
                                    labelText: context.localText.password,
                                    hintText:
                                        context.localText.hintLoginPassword,
                                    prefixIcon: Container(
                                      padding: const EdgeInsets.all(12),
                                      child: const Icon(
                                        Icons.lock_outline,
                                        color: AppColors.primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      key: const Key(
                                        LoginPageKeys.passwordVisibilityToggle,
                                      ),
                                      icon: Icon(
                                        isSecure
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppColors.grey600,
                                      ),
                                      onPressed:
                                          () =>
                                              loginController
                                                  .passwordNotifier
                                                  .value = !loginController
                                                      .passwordNotifier
                                                      .value,
                                    ),
                                  ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Remember Me Section
                      Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: loginController.rememberMeNotifier,
                            builder: (
                              BuildContext context,
                              dynamic value,
                              Widget? child,
                            ) {
                              return Transform.scale(
                                scale: 1.1,
                                child: Checkbox(
                                  key: const Key(
                                    LoginPageKeys.rememberMeCheckbox,
                                  ),
                                  value: value,
                                  onChanged: loginController.toggleRememberMe,
                                  activeColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          TextWidget(
                            key: const Key(LoginPageKeys.rememberMeText),
                            text: S.current.remember_me,
                            style: context.bodyM?.copyWith(
                              color: AppColors.grey600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Login Button
                      GeneralContainer.gradient(
                        key: const Key(LoginPageKeys.loginButtonContainer),
                        gradientColors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor.withOpacity(0.8),
                        ],
                        shadowColor: AppColors.primaryColor.withOpacity(0.3),
                        shadowBlurRadius: 15,
                        shadowOffset: const Offset(0, 8),
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            key: const Key(LoginPageKeys.loginButton),
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: TextWidget(
                              text: context.localText.signIn,
                              style: context.bodyL?.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Register Button
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      fab: Visibility(
        visible: EnvironmentService.isDevelopment,
        child: FloatingActionButton.extended(
          key: const Key(LoginPageKeys.fillTestDataButton),
          onPressed: _fillWithTestData,
          backgroundColor: AppColors.primaryColor,
          icon: const Icon(Icons.login, color: Colors.white),
          label: Text(
            S.current.fill_test_data,
            style: context.bodyL?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          tooltip: S.current.fill_with_test_credentials,
        ),
      ),
    );
  }


  void _login() {
    loginController.login();
  }
}
