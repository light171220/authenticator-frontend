import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/dimensions.dart';
import '../../../../core/utils/validators/input_validators.dart';
import '../../../../shared/widgets/common/custom_button.dart';
import '../../../../shared/widgets/common/custom_text_field.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
            hint: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            validator: InputValidators.required,
            prefixIcon: const Icon(Icons.lock_outlined),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: 'Sign In',
                onPressed: state is AuthLoading ? null : _handleLogin,
                isLoading: state is AuthLoading,
              );
            },
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: 'Sign In with Biometrics',
                onPressed: state is AuthLoading ? null : _handleBiometricLogin,
                variant: ButtonVariant.outline,
                icon: const Icon(Icons.fingerprint),
              );
            },
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          TextButton(
            onPressed: () {
              // Handle forgot password
            },
            child: const Text('Forgot Password?'),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          deviceId: 'device_id_placeholder',
          deviceName: 'Flutter App',
        ),
      );
    }
  }

  void _handleBiometricLogin() {
    context.read<AuthBloc>().add(const BiometricLoginRequested());
  }
}