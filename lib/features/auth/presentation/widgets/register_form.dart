import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../core/utils/validators/input_validators.dart';
import '../../../../shared/widgets/common/custom_button.dart';
import '../../../../shared/widgets/common/custom_text_field.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            validator: (value) => InputValidators.required(value, fieldName: 'Name'),
            prefixIcon: const Icon(Icons.person_outlined),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          CustomTextField(
            label: 'Email',
            hint: 'Enter your email address',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: InputValidators.email,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          CustomTextField(
            label: 'Password',
            hint: 'Create a strong password',
            controller: _passwordController,
            obscureText: true,
            validator: InputValidators.password,
            prefixIcon: const Icon(Icons.lock_outlined),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          CustomTextField(
            label: 'Confirm Password',
            hint: 'Confirm your password',
            controller: _confirmPasswordController,
            obscureText: true,
            validator: (value) => InputValidators.confirmPassword(value, _passwordController.text),
            prefixIcon: const Icon(Icons.lock_outlined),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          CheckboxListTile(
            value: _acceptTerms,
            onChanged: (value) {
              setState(() {
                _acceptTerms = value ?? false;
              });
            },
            title: const Text('I accept the Terms of Service and Privacy Policy'),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: 'Create Account',
                onPressed: state is AuthLoading || !_acceptTerms ? null : _handleRegister,
                isLoading: state is AuthLoading,
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept the terms and conditions')),
        );
        return;
      }

      context.read<AuthBloc>().add(
        RegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          deviceId: 'device_id_placeholder',
          deviceName: 'Flutter App',
        ),
      );
    }
  }
}