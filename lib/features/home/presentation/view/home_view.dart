import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sparexpress/features/auth/presentation/view/login_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/account_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/cart_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:sparexpress/features/home/presentation/view/bottom_view/order_view.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_view_model.dart';
import 'package:sparexpress/features/home/presentation/view_model/home_state.dart';
// import 'package:sparexpress/features/home/presentation/widgets/dashboard/dashboard_header/custom_dashboard_appbar.dart';
import 'package:sparexpress/features/home/presentation/widgets/dashboard_header/custom_dashboard_appbar.dart';
import 'package:sparexpress/features/home/presentation/widgets/searchBar/search_bar.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_state.dart';
import 'package:sparexpress/app/service_locator/service_locator.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/profile_view_model/profile_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_bloc.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_event.dart';
import 'package:sparexpress/features/home/presentation/view_model/cart/cart_view_model/cart_state.dart';
import 'package:sparexpress/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sparexpress/features/home/presentation/view_model/account/account_view_model/account_state.dart';
import 'package:sparexpress/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:sparexpress/features/splash/presentation/view/splash_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController? _searchController;
    StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final double _shakeThreshold = 105.0;
  bool _isDialogShowing = false;
  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _accelerometerSubscription = accelerometerEvents.listen(_onAccelerometerEvent);
  }

void _onAccelerometerEvent(AccelerometerEvent event) {
    final double acceleration = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    // print('Acceleration: $acceleration');
    if (acceleration > _shakeThreshold && !_isDialogShowing) {
      _showLogoutDialog();
    }
  }


  void _showLogoutDialog() {
    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout from your account?'),
        actions: [
         Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _isDialogShowing = false;
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: (){
                        context.read<AccountBloc>().add(LogoutRequested());
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BlocProvider(
                          create: (_) => serviceLocator<LoginViewModel>(),
                          child: LoginView(),
                        )));
                        _isDialogShowing = false;
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }



  @override
  void dispose() {
    _searchController?.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountBloc(),
      child: _HomeViewContent(),
    );
  }
}

class _HomeViewContent extends StatefulWidget {
  const _HomeViewContent({Key? key}) : super(key: key);
  @override
  State<_HomeViewContent> createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<_HomeViewContent> {
  TextEditingController? _searchController;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final double _shakeThreshold = 25.0; // Increased threshold for better detection
  bool _isDialogShowing = false;
  StreamSubscription<int>? _proximitySubscription;
  bool _isProximityDialogShowing = false;
  
  // Proximity sensor sensitivity settings
  bool _isNear = false;
  Timer? _proximityTimer;
  int _proximityDuration = 0;
  static const int _proximityThreshold = 0; // Immediate trigger - very sensitive
  static const int _proximityCheckInterval = 100; // Check every 100ms for maximum sensitivity
  
  // Shake detection improvements
  DateTime? _lastShakeTime;
  static const int _shakeCooldown = 2000; // 2 seconds cooldown between shakes

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEvents.listen(_onAccelerometerEvent);
    _initializeProximitySensor();
  }

  Future<void> _initializeProximitySensor() async {
    try {
      _proximitySubscription = ProximitySensor.events.listen(
        _onProximityEvent,
        onError: (error) {
          // Silent error handling
        },
        cancelOnError: false,
      );
    } catch (e) {
      // Silent error handling
    }
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    final double acceleration = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    
    final now = DateTime.now();
    if (acceleration > _shakeThreshold && 
        !_isDialogShowing && 
        (_lastShakeTime == null || 
         now.difference(_lastShakeTime!).inMilliseconds > _shakeCooldown)) {
      
      _lastShakeTime = now;
      _showLogoutDialog();
    }
  }

  void _onProximityEvent(int event) {
    final bool wasNear = _isNear;
    _isNear = (event > 0);
    
    // Show visual feedback only if context is mounted
    if (_isNear && !wasNear && mounted) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('📱 Proximity detected!'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange[700],
          ),
        );
      } catch (e) {
        // Silent error handling
      }
    }
    
    // Immediate trigger when device gets near
    if (_isNear && !wasNear && mounted) {
      _showProximityExitDialog();
    } else if (!_isNear && wasNear) {
      _resetProximityTimer();
    }
  }

  void _startProximityTimer() {
    _resetProximityTimer(); // Clear any existing timer
    _proximityDuration = 0;
    
    _proximityTimer = Timer.periodic(
      Duration(milliseconds: _proximityCheckInterval),
      (timer) {
        _proximityDuration++;
        
        // Check if threshold is met (more sensitive now)
        if (_proximityDuration >= _proximityThreshold && !_isProximityDialogShowing) {
          _showProximityExitDialog();
          timer.cancel();
        }
      },
    );
  }

  void _resetProximityTimer() {
    _proximityTimer?.cancel();
    _proximityTimer = null;
    _proximityDuration = 0;
  }

  void _showProximityExitDialog() {
    if (_isProximityDialogShowing) return; // Prevent multiple dialogs
    
    _isProximityDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.phone_android, color: Colors.orange),
            SizedBox(width: 8),
            Text('Device Too Close'),
          ],
        ),
        content: const Text(
          'Your device is very close to your face. This may cause eye strain. Do you want to exit the app?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _isProximityDialogShowing = false;
            },
            child: const Text('Continue Using'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _isProximityDialogShowing = false;
              Future.delayed(const Duration(milliseconds: 200), () {
                try {
                  SystemNavigator.pop();
                } catch (_) {
                  exit(0);
                }
              });
            },
            child: const Text('Exit App'),
          ),
        ],
      ),
    ).then((_) {
      _isProximityDialogShowing = false;
    });
  }

  void _showLogoutDialog() {
    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout from your account?'),
        actions: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      _isDialogShowing = false;
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      // Cancel accelerometer subscription before navigating away
                      _accelerometerSubscription?.cancel();
                      _accelerometerSubscription = null;
                      
                      // Trigger logout
                      dialogContext.read<AccountBloc>().add(LogoutRequested());
                      
                      // Close dialog
                      Navigator.of(dialogContext).pop();
                      _isDialogShowing = false;
                      
                      // Navigate to login screen
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: serviceLocator<LoginViewModel>(),
                              child: LoginView(),
                            ),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).then((_) {
      if (mounted) {
        setState(() => _isDialogShowing = false);
      }
    });
  }

  @override
  void dispose() {
    _searchController?.dispose();
    _accelerometerSubscription?.cancel();
    _proximitySubscription?.cancel();
    _proximityTimer?.cancel(); // Clean up the proximity timer
    _proximitySubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<CartBloc>()..add(LoadCart()),
      child: BlocProvider(
        create: (_) => serviceLocator<ProfileBloc>()..add(FetchCustomerProfile()),
        child: BlocProvider(
          create: (_) => serviceLocator<AccountBloc>(),
          child: BlocListener<AccountBloc, AccountState>(
            listener: (context, state) {
              if (state is LogoutConfirmed) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: serviceLocator<SplashViewModel>(),
                      child: SplashView(),
                    ),
                  ),
                  (route) => false,
                );
              }
            },
            child: BlocBuilder<HomeViewModel, HomeState>(
              builder: (context, state) {
                final fullname = state.fullname;

                // Initialize controller only for dashboard
                if (state.selectedIndex == 0 && _searchController == null) {
                  _searchController = TextEditingController();
                } else if (state.selectedIndex != 0 && _searchController != null) {
                  _searchController!.dispose();
                  _searchController = null;
                }

                Widget bodyWidget;
                switch (state.selectedIndex) {
                  case 0:
                    bodyWidget = const DashboardView();
                    break;
                  case 1:
                    bodyWidget = BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, profileState) {
                        if (profileState is ProfileLoaded) {
                          final userId = profileState.customer.customerId ?? '';
                          return OrderView(userId: userId);
                        } else if (profileState is ProfileLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (profileState is ProfileError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error, size: 48, color: Colors.red),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: ${profileState.message}',
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                    break;
                  case 2:
                    bodyWidget = const CartView();
                    break;
                  case 3:
                    bodyWidget = const AccountView();
                    break;
                  default:
                    bodyWidget = const DashboardView();
                }

                return Scaffold(
                  appBar: state.selectedIndex == 0
                      ? CustomDashboardAppBar()
                      : null,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      children: [
                        if (state.selectedIndex == 0 && _searchController != null) ...[
                          SearchBarWidget(
                            controller: _searchController!,
                            onSearch: (query) {
                              // print('Searching: $query');
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                        Expanded(child: bodyWidget),
                      ],
                    ),
                  ),
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 18,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        showSelectedLabels: true,
                        showUnselectedLabels: true,
                        selectedFontSize: 14,
                        unselectedFontSize: 13,
                        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2, color: Colors.white),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.1, color: Colors.black),
                        items: [
                          BottomNavigationBarItem(
                            icon: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: state.selectedIndex == 0 ? Theme.of(context).colorScheme.primary.withOpacity(0.25) : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.dashboard,
                                size: state.selectedIndex == 0 ? 32 : 26,
                                color: state.selectedIndex == 0 ? Colors.white : Colors.black,
                              ),
                            ),
                            label: 'Dashboard',
                          ),
                          BottomNavigationBarItem(
                            icon: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: state.selectedIndex == 1 ? Theme.of(context).colorScheme.primary.withOpacity(0.25) : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.receipt_long,
                                size: state.selectedIndex == 1 ? 32 : 26,
                                color: state.selectedIndex == 1 ? Colors.white : Colors.black,
                              ),
                            ),
                            label: 'Order',
                          ),
                          BottomNavigationBarItem(
                            icon: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: state.selectedIndex == 2 ? Theme.of(context).colorScheme.primary.withOpacity(0.25) : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: BlocBuilder<CartBloc, CartState>(
                                builder: (context, cartState) {
                                  int cartCount = 0;
                                  if (cartState is CartLoaded) {
                                    cartCount = cartState.items.length;
                                  }
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Icon(
                                        Icons.add_shopping_cart,
                                        size: state.selectedIndex == 2 ? 32 : 26,
                                        color: state.selectedIndex == 2 ? Colors.white : Colors.black,
                                      ),
                                      if (cartCount > 0)
                                        Positioned(
                                          right: -2,
                                          top: -2,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 18,
                                              minHeight: 18,
                                            ),
                                            child: Text(
                                              '$cartCount',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            label: 'Cart',
                          ),
                          BottomNavigationBarItem(
                            icon: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: state.selectedIndex == 3 ? Theme.of(context).colorScheme.primary.withOpacity(0.25) : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.account_circle,
                                size: state.selectedIndex == 3 ? 32 : 26,
                                color: state.selectedIndex == 3 ? Colors.white : Colors.black,
                              ),
                            ),
                            label: 'Account',
                          ),
                        ],
                        currentIndex: state.selectedIndex,
                        selectedItemColor: Colors.white,
                        unselectedItemColor: Colors.black,
                        onTap: (index) {
                          context.read<HomeViewModel>().onTapped(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
