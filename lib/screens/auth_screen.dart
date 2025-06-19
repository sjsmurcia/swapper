// Troubleshooting SVG asset loading:
// 1. In pubspec.yaml under flutter: ensure indentation (two spaces before assets, four spaces before path):
//
// flutter:
//   assets:
//     - assets/illustrations/auth_top.svg
//
// 2. Run `flutter pub get` and then `flutter clean`.
// 3. Perform a full app restart, not just hot reload.
// 4. Confirm the file exists at the specified path in your project directory.
// 5. Check for typos in the filename and folder names (case sensitive).

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
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

                      // Email field
                      SizedBox(
                        height: 56,
                        child: TextFormField(
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
                            onPressed: () {},
                            child: Text(
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
