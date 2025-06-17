   
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutribite/firebase_options.dart';
import 'package:nutribite/login/signup/forget_password.dart';
import 'package:nutribite/login/signup/log_in.dart';
import 'package:nutribite/login/signup/sign_up.dart';
import 'package:nutribite/main_screens/guest_dashboard.dart';
import 'package:nutribite/main_screens/nutrition_dashboard.dart';
import 'package:nutribite/main_screens/recipe_detail.dart';
import 'package:nutribite/main_screens/recipe_explorer.dart';
import 'package:nutribite/personalizing-screens/cooking_time.dart';
import 'package:nutribite/personalizing-screens/guest_screen.dart';
import 'package:nutribite/personalizing-screens/meal_preference_screen.dart';
import 'package:nutribite/personalizing-screens/personalize_age_etc.dart';
import 'package:nutribite/personalizing-screens/personalize_health_goal.dart';
import 'package:nutribite/welcome_screens/splash_screen.dart';
import 'package:nutribite/welcome_screens/guide_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const NutriBite());
}

class NutriBite extends StatelessWidget {
  const NutriBite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
     
      onGenerateRoute: (settings) {
        if (settings.name == '/detailRecipe') {
          final recipeId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => DetailScreen(recipeId: recipeId),
          );
        }

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashWrapper());

          case '/GuidePage':
            return MaterialPageRoute(builder: (_) => OnboardingScreen());

          case '/authHandler':
            return MaterialPageRoute(builder: (_) => const AuthHandler());

          case '/signup':
            return MaterialPageRoute(builder: (_) => SignUpScreen());

          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());

          case '/forgotpassword':
            return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());

          case '/guestscreen':
            return MaterialPageRoute(builder: (_) => GuestScreen());

          case '/personalize':
            return MaterialPageRoute(builder: (_) => PersonalizeJourneyPage());

          case '/personalizehealth':
            return MaterialPageRoute(builder: (_) => CustomizeMealScreen());

          case '/foodpreference':
            return MaterialPageRoute(builder: (_) => MealPreferenceScreen());

          case '/cookingtimescreen':
            return MaterialPageRoute(builder: (_) => CookingTimeScreen());

          case '/homescreen':
            return MaterialPageRoute(
              builder: (_) => NutritionDashboard(initialTabIndex: 0),
            );

          case '/mealplanner':
            return MaterialPageRoute(
              builder: (_) => NutritionDashboard(initialTabIndex: 3),
            );

          case '/guestdashboard':
            return MaterialPageRoute(builder: (_) => GuestDashboard());

          case '/recipeExplorer':
            return MaterialPageRoute(builder: (_) => RecipeExplorerScreen());

          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('No route defined for ${settings.name}')),
              ),
            );
        }
      },
    );
  }
}

// ✅ Fixed: Shows Splash & Onboarding only once
class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}


class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 5)); // Delay to show splash

    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (!seenOnboarding) {
      await prefs.setBool('seenOnboarding', true);
      Navigator.pushReplacementNamed(context, '/GuidePage');
    } else {
      Navigator.pushReplacementNamed(context, '/authHandler');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

// Handles post-auth login flow
class AuthHandler extends StatefulWidget {
  const AuthHandler({super.key});

  @override
  State<AuthHandler> createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/guestdashboard');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final justSignedIn = prefs.getBool('justSignedIn') ?? false;
    final showMealPlannerAfterPersonalize = prefs.getBool('showMealPlannerAfterPersonalize') ?? false;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data() ?? {};

    final hasGoal = data['goal'] != null && data['goal'].toString().isNotEmpty;
    final hasPlan = data['planDuration'] != null && data['planDuration'].toString().isNotEmpty;

    if (!hasGoal || !hasPlan) {
      if (justSignedIn) {
        await prefs.setBool('showMealPlannerAfterPersonalize', true);
      }
      Navigator.pushReplacementNamed(context, '/personalize');
    } else if (showMealPlannerAfterPersonalize) {
      await prefs.setBool('justSignedIn', false);
      await prefs.remove('showMealPlannerAfterPersonalize');
      Navigator.pushReplacementNamed(context, '/mealplanner');
    } else if (justSignedIn) {
      await prefs.setBool('justSignedIn', false);
      Navigator.pushReplacementNamed(context, '/mealplanner');
    } else {
      Navigator.pushReplacementNamed(context, '/homescreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
