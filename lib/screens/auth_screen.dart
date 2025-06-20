
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';

class AuthScreen extends ConsumerStatefulWidget {

    const AuthScreen({Key? key}) : super(key: key);

    @override
    _AuthScreenState createState() => _AuthScreenState();
  }

class _AuthScreenState extends ConsumerState<AuthScreen> {

  bool isLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.watch(authControllerProvider.notifier);

    final size = MediaQuery.of(context).size;
    final topHeight = size.height * 0.4;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              // Top gradient with SVG illustration from assets
              Container(
                height: topHeight,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xDF00796B), Color(0xD526A69A)],
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/illustrations/auth_top.svg',
                    width: size.width * 0.8,
                    height: topHeight * 0.6,
                    fit: BoxFit.contain,
                    // Show error if asset fails to load
                    errorBuilder: (context, error, stackTrace) {
                      // Log error details
                      debugPrint('SVG load error: $error');
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.error, color: Colors.white),
                          SizedBox(height: 4),
                          Text(
                            'No se pudo cargar auth_top.svg',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Card form
              Positioned(
                top: topHeight - 60,
                left: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Swapper',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: Color(0xFF054F42),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isLogin ? 'Inicio de sesión' : 'Registro',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (authState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            authState.error!.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      // Email field
                      SizedBox(
                        height: 56,
                        child: TextFormField(
                          controller: _emailController,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Color(0xFF212121),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Correo',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xFF616161),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      SizedBox(
                        height: 56,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Color(0xFF212121),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(0xFF616161),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Primary button
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF00796B), Color(0xFF26A69A)],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: authState.isLoading

                                ? null
                                : () {
                              final email =
                              _emailController.text.trim();
                              final password =
                              _passwordController.text.trim();
                              if (isLogin) {
                                authController.signIn(email, password);
                              } else {
                                authController.register(email, password);
                              }
                            },
                            child: authState.isLoading
                                ? const CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            )
                                : Text(
                              isLogin ? 'Entrar' : 'Registrarme',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),

                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Toggle link
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 16),
                          children: [
                            TextSpan(
                              text: isLogin ? 'Crear cuenta' : 'Ya tengo cuenta',
                              style: TextStyle(
                                color: isLogin ? const Color(0xFFFFB74D) : const Color(0xFF616161),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                            ),
                            const TextSpan(text: ' / ', style: TextStyle(color: Color(0xFF616161))),
                            TextSpan(
                              text: isLogin ? 'Ya tengo cuenta' : 'Crear cuenta',
                              style: TextStyle(
                                color: isLogin ? const Color(0xFF616161) : const Color(0xFFFFB74D),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
