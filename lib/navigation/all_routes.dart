import 'package:flutter/material.dart';
import 'package:ncare/authentication/login_screen.dart';
import 'package:ncare/authentication/onboading_Screen1.dart';
import 'package:ncare/authentication/otp_screen.dart';
import 'package:ncare/authentication/resgister_screen.dart';
import 'package:ncare/authentication/splash_screen.dart';
import 'package:ncare/screen/categories_screen.dart';
import 'package:ncare/screen/edit_profile_screen.dart';
import 'package:ncare/screen/help_support.dart';
import 'package:ncare/screen/home_screen.dart';
import 'package:ncare/screen/my_address.dart';
import 'package:ncare/screen/notification_screen.dart';
import 'package:ncare/screen/order/Result_found_screen.dart';
import 'package:ncare/screen/order/cart_screen.dart';
import 'package:ncare/screen/order/order_detail_screen.dart';
import 'package:ncare/screen/order/order_screen.dart';
import 'package:ncare/screen/order/order_tracking_screen.dart';
import 'package:ncare/screen/payment/payment_method_screen.dart';
import 'package:ncare/screen/profile_screen.dart';
import 'package:ncare/screen/search_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding1 = '/onboarding1';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit_profile';
  static const String search = '/search';
  static const String searchResult = '/search_result';
  static const String order = '/order';
  static const String orderDetail = '/order_detail';
  static const String orderTracking = '/order_tracking';
  static const String notification = '/notification';
  static const String cart = '/cart';
  static const String helpSupport = '/help_support';
  static const String myAddress = '/my_address';
  static const String paymentMethod = '/payment_method';
  static const String categories = '/categories';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding1: (context) => const OnboardingScreen1(),
        login: (context) => const LoginScreen(),
        otp: (context) => const OtpVerificationScreen(),
        register: (context) => const RegisterScreen(),
        home: (context) => const HomeScreen(),
        profile: (context) => const ProfileScreen(),
        editProfile: (context) => const EditProfileScreen(),
        search: (context) => const SearchCategoriesScreen(),
        searchResult: (context) => const SearchResultScreen(),
        order: (context) => const MyOrdersScreen(),
        orderDetail: (context) => const OrderDetailScreen(),
        orderTracking: (context) => const OrderTrackingScreen(),
        notification: (context) => const NotificationsScreen(),
        cart: (context) => const CartScreen(),
        helpSupport: (context) => const HelpSupportScreen(),
        myAddress: (context) => const MyAddressScreen(),
        paymentMethod: (context) => const PaymentMethodScreen(),
        categories: (context) => const CategoriesScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildAnimatedRoute(const SplashScreen(), settings);
      case onboarding1:
        return _buildAnimatedRoute(const OnboardingScreen1(), settings);
      case login:
        return _buildAnimatedRoute(const LoginScreen(), settings);
      case otp:
        return _buildAnimatedRoute(const OtpVerificationScreen(), settings);
      case register:
        return _buildAnimatedRoute(const RegisterScreen(), settings);
      case home:
        return _buildAnimatedRoute(const HomeScreen(), settings);
      case profile:
        return _buildAnimatedRoute(const ProfileScreen(), settings);
      case editProfile:
        return _buildAnimatedRoute(const EditProfileScreen(), settings);
      case search:
        return _buildAnimatedRoute(const SearchCategoriesScreen(), settings);
      case searchResult:
        return _buildAnimatedRoute(const SearchResultScreen(), settings);
      case order:
        return _buildAnimatedRoute(const MyOrdersScreen(), settings);
      case orderDetail:
        return _buildAnimatedRoute(const OrderDetailScreen(), settings);
      case orderTracking:
        return _buildAnimatedRoute(const OrderTrackingScreen(), settings);
      case notification:
        return _buildAnimatedRoute(const NotificationsScreen(), settings);
      case cart:
        return _buildAnimatedRoute(const CartScreen(), settings);
      case helpSupport:
        return _buildAnimatedRoute(const HelpSupportScreen(), settings);
      case myAddress:
        return _buildAnimatedRoute(const MyAddressScreen(), settings);
      case paymentMethod:
        return _buildAnimatedRoute(const PaymentMethodScreen(), settings);
      case categories:
        return _buildAnimatedRoute(const CategoriesScreen(), settings);
      default:
        return _buildAnimatedRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  static Route<T> _buildAnimatedRoute<T>(Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideTween = Tween<Offset>(
          begin: const Offset(0.08, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        final fadeTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }
}
