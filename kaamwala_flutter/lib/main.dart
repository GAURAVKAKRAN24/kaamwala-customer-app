import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/address_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/home_screen.dart';
import 'screens/language_screen.dart';
import 'screens/login_screen.dart';
import 'screens/mobile_auth_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'services/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const KaamWalaApp());
}

class KaamWalaApp extends StatefulWidget {
  const KaamWalaApp({super.key});

  @override
  State<KaamWalaApp> createState() => _KaamWalaAppState();
}

class _KaamWalaAppState extends State<KaamWalaApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'KaamWala - Trusted Home Services',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F766E),
              primary: const Color(0xFF0F766E),
              secondary: const Color(0xFF115E59),
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xFF18181B)),
              titleTextStyle: TextStyle(
                color: Color(0xFF18181B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: _buildCurrentScreen(),
        );
      },
    );
  }

  Widget _buildCurrentScreen() {
    switch (_appState.currentRoute) {
      case 'splash':
        return SplashScreen(appState: _appState);
      case 'lang':
        return LanguageScreen(appState: _appState);
      case 'address':
        return AddressScreen(appState: _appState);
      case 'otp':
        return MobileAuthScreen(appState: _appState);
      case 'login':
        return LoginScreen(appState: _appState);
      case 'app':
      default:
        if (!_appState.isLoggedIn) {
          return LoginScreen(appState: _appState);
        }
        return MainNavigationContainer(appState: _appState);
    }
  }
}

class MainNavigationContainer extends StatefulWidget {
  final AppState appState;

  const MainNavigationContainer({
    super.key,
    required this.appState,
  });

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        appState: widget.appState,
        onNavigateTab: (index) => setState(() => _currentIndex = index),
      ),
      BookingsScreen(appState: widget.appState),
      ChatScreen(appState: widget.appState),
      NotificationsScreen(appState: widget.appState),
      ProfileScreen(appState: widget.appState),
    ];

    final isHindi = widget.appState.language == 'hi';

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF0F766E),
          unselectedItemColor: const Color(0xFF71717A),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: isHindi ? 'होम' : 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_outlined),
              activeIcon: const Icon(Icons.assignment),
              label: isHindi ? 'बुकिंग्स' : 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.chat_bubble_outline),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F766E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              activeIcon: const Icon(Icons.chat_bubble),
              label: isHindi ? 'चैट' : 'Messages',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_none),
              activeIcon: const Icon(Icons.notifications),
              label: isHindi ? 'अलर्ट' : 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: isHindi ? 'प्रोफाइल' : 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
