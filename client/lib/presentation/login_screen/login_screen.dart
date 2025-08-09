import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _showSuccessAnimation = false;
  bool _isPasswordVisible = false;

  // Identifiants de test
  final Map<String, String> _mockCredentials = {
    'demo@motigoal.com': 'demo123',
    'user@example.com': 'password',
    'test@test.com': 'test123',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      // Simuler un délai réseau
      await Future.delayed(const Duration(seconds: 2));

      // Vérifier les identifiants
      if (_mockCredentials.containsKey(email) && _mockCredentials[email] == password) {
        // Succès - retour haptique
        HapticFeedback.heavyImpact();

        // Afficher un message de succès
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.celebration,
                    color: Colors.white,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Bienvenue ! +50 MotiCoins gagnés !',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          // Montrer l'animation de succès
          setState(() {
            _isLoading = false;
            _showSuccessAnimation = true;
          });
          
          // Naviguer vers le tableau de bord après un délai
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/dashboard-home');
          });
        }
      } else {
        // Erreur - afficher un message encourageant
        if (mounted) {
          setState(() => _isLoading = false);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Identifiants incorrects. Veuillez réessayer.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Essayez : demo@motigoal.com / demo123',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur de connexion. Veuillez réessayer.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _navigateToRegistration() {
    Navigator.pushReplacementNamed(context, '/registration-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Contenu principal
            Column(
              children: [
                // Barre d'application avec bouton retour
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Connexion',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 10.w), // Équilibrer le bouton retour
                    ],
                  ),
                ),

                // Contenu défilable
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Ajout d'un espace flexible pour centrer verticalement
                        SizedBox(height: 5.h),
                        SizedBox(height: 3.h),
                        
                        // En-tête de bienvenue
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bienvenue !',
                                style: AppTheme.lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Connectez-vous pour continuer votre parcours de productivité.',
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 4.h),
                            ],
                          ),
                        ),

                        // Ajout d'un espace flexible en bas pour équilibrer le centrage
                        SizedBox(height: 10.h),

                        // Formulaire de connexion
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          // Centrer horizontalement avec des marges
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Champ Email
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Veuillez entrer votre email';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value.trim())) {
                                      return 'Veuillez entrer un email valide';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Entrez votre adresse email',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(3.w),
                                      child: Icon(
                                        Icons.email,
                                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                        size: 20,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.lightTheme.colorScheme.outline,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.lightTheme.colorScheme.outline,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.lightTheme.colorScheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.lightTheme.colorScheme.error,
                                      ),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                                SizedBox(height: 3.h),

                                // Champ Mot de passe
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer votre mot de passe';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Mot de passe',
                                    hintText: 'Entrez votre mot de passe',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(3.w),
                                      child: Icon(
                                        Icons.lock,
                                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.lightTheme.colorScheme.outline,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.lightTheme.colorScheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppTheme.lightTheme.colorScheme.error,
                                      ),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.done,
                                ),
                                SizedBox(height: 1.h),

                                // Lien Mot de passe oublié
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Fonctionnalité de récupération de mot de passe à venir !',
                                            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Mot de passe oublié ?',
                                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // Bouton de connexion
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                        height: 5.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Text(
                                        'Connexion en cours...',
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Se connecter',
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Lien d'inscription
                        GestureDetector(
                          onTap: _navigateToRegistration,
                          child: RichText(
                            text: TextSpan(
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              children: [
                                const TextSpan(
                                    text: 'Pas encore de compte ? '),
                                TextSpan(
                                  text: 'Inscription',
                                  style: TextStyle(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Animation de succès en superposition
            if (_showSuccessAnimation)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12.w,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Connexion réussie !',
                        style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Redirection en cours...',
                        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
