import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/locale_provider.dart';
import 'core/localization/app_localizations.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/book_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/favorite_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // مزود اللغة - يجب أن يكون أولاً
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        // مزود المصادقة
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // مزود الكتب
        ChangeNotifierProvider(create: (_) => BookProvider()),
        // مزود السلة
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // مزود المفضلة
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            // اسم التطبيق
            title: localeProvider.isArabic ? 'متجر الكتب' : 'eBook Store',
            
            // إخفاء شريط Debug
            debugShowCheckedModeBanner: false,
            
            // ========== إعدادات اللغة والاتجاه ==========
            
            // اللغة الحالية
            locale: localeProvider.locale,
            
            // اللغات المدعومة
            supportedLocales: LocaleProvider.supportedLocales,
            
            // مندوب الترجمة المخصص
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              // Fallback delegates for Material and Widgets
              _MaterialLocalizationsDelegate(localeProvider.isArabic),
              _WidgetsLocalizationsDelegate(localeProvider.isArabic),
            ],
            
            // ========== الثيم ==========
            
            // الثيم الفاتح
            theme: AppTheme.lightTheme(isArabic: localeProvider.isArabic),
            
            // الثيم الداكن (للمستقبل)
            darkTheme: AppTheme.darkTheme(isArabic: localeProvider.isArabic),
            
            // وضع الثيم
            themeMode: ThemeMode.light,
            
            // ========== Builder للاتجاه ==========
            
            builder: (context, child) {
              return Directionality(
                // اتجاه النص حسب اللغة
                textDirection: localeProvider.textDirection,
                child: child!,
              );
            },
            
            // ========== الشاشة الرئيسية ==========
            
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                // إذا كان المستخدم مسجّل دخول
                if (authProvider.isAuthenticated) {
                  // إذا كان مدير -> لوحة التحكم
                  if (authProvider.isAdmin) {
                    return const AdminDashboard();
                  }
                  // مستخدم عادي -> الصفحة الرئيسية
                  return const HomeScreen();
                }
                // غير مسجّل -> شاشة تسجيل الدخول
                return const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}

// ========== Minimal Material Localizations ==========

class _MaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  final bool isArabic;
  _MaterialLocalizationsDelegate(this.isArabic);
  
  @override
  bool isSupported(Locale locale) => true;
  
  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return DefaultMaterialLocalizations();
  }
  
  @override
  bool shouldReload(_MaterialLocalizationsDelegate old) => old.isArabic != isArabic;
}

class _WidgetsLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  final bool isArabic;
  _WidgetsLocalizationsDelegate(this.isArabic);
  
  @override
  bool isSupported(Locale locale) => true;
  
  @override
  Future<WidgetsLocalizations> load(Locale locale) async {
    return DefaultWidgetsLocalizations();
  }
  
  @override
  bool shouldReload(_WidgetsLocalizationsDelegate old) => old.isArabic != isArabic;
}
