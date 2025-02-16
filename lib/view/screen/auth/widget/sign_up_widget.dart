import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sado_ecommerce/data/model/body/register_model.dart';
import 'package:flutter_sado_ecommerce/helper/email_checker.dart';
import 'package:flutter_sado_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sado_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sado_ecommerce/main.dart';
import 'package:flutter_sado_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sado_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sado_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sado_ecommerce/utill/color_resources.dart';
import 'package:flutter_sado_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sado_ecommerce/utill/dimensions.dart';
import 'package:flutter_sado_ecommerce/utill/images.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_button.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sado_ecommerce/view/basewidget/custom_textfield.dart';
import 'package:flutter_sado_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'otp_verification_screen.dart';
import 'package:flutter_sado_ecommerce/utill/validation_utils.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  SignUpWidgetState createState() => SignUpWidgetState();
}

class SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();

  RegisterModel register = RegisterModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordComplex(String password) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return regex.hasMatch(password);
  }

  route(bool isRoute, String? token, String? tempToken,
      String? errorMessage) async {
    String phone =
        Provider.of<AuthProvider>(context, listen: false).countryDialCode +
            _phoneController.text.trim();
    if (isRoute) {
      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .emailVerification!) {
        Provider.of<AuthProvider>(context, listen: false)
            .checkEmail(_emailController.text.toString(), tempToken!)
            .then((value) async {
          if (value.isSuccess) {
            Provider.of<AuthProvider>(context, listen: false)
                .updateEmail(_emailController.text.toString());
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => VerificationScreen(
                        tempToken, '', _emailController.text.toString())),
                (route) => false);
          }
        });
      } else if (Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .phoneVerification!) {
        Provider.of<AuthProvider>(context, listen: false)
            .checkPhone(phone, tempToken!)
            .then((value) async {
          if (value.isSuccess) {
            Provider.of<AuthProvider>(context, listen: false)
                .updatePhone(phone);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => VerificationScreen(tempToken, phone, '')),
                (route) => false);
          }
        });
      } else {
        await Provider.of<ProfileProvider>(context, listen: false)
            .getUserInfo(context);
        Navigator.pushAndRemoveUntil(
            Get.context!,
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            (route) => false);
        _emailController.clear();
        _passwordController.clear();
        _nameController.clear();
        _phoneController.clear();
        _confirmPasswordController.clear();
        _referCodeController.clear();
      }
    } else {
      showCustomSnackBar(errorMessage, context);
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).setCountryCode(
        CountryCode.fromCountryCode(
                Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .countryCode!)
            .dialCode!,
        notify: false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referCodeController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeLarge),
            // First Name Field
            buildInputField(
              context: context,
              title: getTranslated('first_name', context)!,
              hintText: getTranslated('enter_first_name', context)!,
              controller: _nameController,
              focusNode: _nameFocus,
              nextFocus: _lastNameFocus,
              inputType: TextInputType.name,
              prefixIcon: Images.username,
              validator: (value) =>
                  ValidationUtils.validateFirstName(value, context),
            ),
            const SizedBox(
                height: Dimensions.paddingSizeSmall), // Default padding

            // Last Name Field
            buildInputField(
              context: context,
              title: getTranslated('last_name', context)!,
              hintText: getTranslated('enter_last_name', context)!,
              controller: _lastNameController,
              focusNode: _lastNameFocus,
              nextFocus: _emailFocus,
              inputType: TextInputType.name,
              prefixIcon: Images.username,
              validator: (value) =>
                  ValidationUtils.validateFirstName(value, context),
            ),
            const SizedBox(
                height: Dimensions.paddingSizeSmall), // Default padding

            // Email Field
            buildInputField(
              context: context,
              title: getTranslated('email', context)!,
              hintText: getTranslated('enter_your_email', context)!,
              controller: _emailController,
              focusNode: _emailFocus,
              nextFocus: _phoneFocus,
              inputType: TextInputType.emailAddress,
              prefixIcon: Images.email,
              validator: (value) =>
                  ValidationUtils.validateEmail(value, context),
            ),
            const SizedBox(
                height: Dimensions.paddingSizeSmall), // Default padding

            // Phone Field
            buildInputField(
              context: context,
              title: getTranslated('mobile_number', context)!,
              hintText: getTranslated('number_hint', context)!,
              controller: _phoneController,
              focusNode: _phoneFocus,
              nextFocus: _passwordFocus,
              inputType: TextInputType.phone,
              prefixIcon: Images.phone,
              validator: (value) =>
                  ValidationUtils.validatePhone(value, context),
            ),
            const SizedBox(
                height: Dimensions.paddingSizeSmall), // Default padding

            // Password Field
            buildInputField(
              context: context,
              title: getTranslated('password', context)!,
              hintText: getTranslated('enter_your_password', context)!,
              controller: _passwordController,
              focusNode: _passwordFocus,
              nextFocus: _confirmPasswordFocus,
              isPassword: true,
              prefixIcon: Images.lock,
              validator: (value) =>
                  ValidationUtils.validatePassword(value, context),
            ),
            const SizedBox(
                height: Dimensions.paddingSizeSmall), // Default padding

            // Confirm Password Field
            buildInputField(
              context: context,
              title: getTranslated('confirm_password', context)!,
              hintText: getTranslated('re_enter_password', context)!,
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              nextFocus: _referCodeFocus,
              isPassword: true,
              prefixIcon: Images.lock,
              validator: (value) => ValidationUtils.validateConfirmPassword(
                  value, _passwordController.text, context),
            ),
            const SizedBox(
                height: Dimensions.paddingSizeSmall), // Default padding

            // Referral Code Field
            buildInputField(
              context: context,
              title: getTranslated('refer_code', context)!,
              hintText: getTranslated('enter_refer_code', context)!,
              controller: _referCodeController,
              focusNode: _referCodeFocus,
              inputAction: TextInputAction.done,
              isRequired: false,
            ),
            const SizedBox(
                height:
                    Dimensions.paddingSizeOverLarge), // Spacing before button

            // Sign Up Button
            Consumer<AuthProvider>(builder: (context, authProvider, _) {
              return Provider.of<AuthProvider>(context).isLoading
                  ? Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : CustomButton(
                      buttonText: getTranslated('sign_up', context)!,
                      onTap: () => _handleSignUp(context),
                    );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildInputField({
    required BuildContext context,
    required String title,
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
    String? prefixIcon,
    FocusNode? nextFocus,
    TextInputType inputType = TextInputType.text,
    TextInputAction inputAction = TextInputAction.next,
    bool isPassword = false,
    bool isRequired = true,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: textRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
            if (isRequired)
              Text(' *', style: textRegular.copyWith(color: Colors.red)),
          ],
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        CustomTextField(
          hintText: hintText,
          controller: controller,
          focusNode: focusNode,
          nextFocus: nextFocus,
          inputType: inputType,
          borderColor: Theme.of(context).primaryColor.withOpacity(0.5),
          inputAction: inputAction,
          isPassword: isPassword,
          prefixIcon: prefixIcon,
          validator: validator,
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      ],
    );
  }

  void _handleSignUp(BuildContext context) {
    String firstName = _nameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber =
        Provider.of<AuthProvider>(context, listen: false).countryDialCode +
            _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String referCode = _referCodeController.text.trim();

    if (formKey.currentState!.validate()) {
      register.fName = firstName;
      register.lName = lastName;
      register.email = email;
      register.phone = phoneNumber;
      register.password = password;
      register.referCode = referCode;
      Provider.of<AuthProvider>(context, listen: false)
          .registration(register, route);
    }
  }
}
