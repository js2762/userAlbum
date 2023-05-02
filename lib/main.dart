import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import './providers/auth.dart';
import './providers/user_data_provider.dart';
import './providers/album_data_provider.dart';
import './providers/picture_data_provider.dart';
import './screens/auth_screen.dart';
import './screens/user_page_screen.dart';
import './screens/album_page_screen.dart';
import './screens/picture_screen.dart';
import './screens/loading_screen.dart';
import './screens/photo_item_screen.dart';
import './screens/getx_demo_screen.dart';
import './services/local_notification.dart';

//import './widgets/slider_drawer.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();

  //FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(const MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    // gives you the message on which user taps
    // and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage();

    // forground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification?.body);
        print(message.notification?.title);
      }

      LocalNotificationService.display(message);
    });

    // when the app is in background but opened and user taps
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeName = message.data['route'];
      print(routeName);
      FirebaseAnalytics.instance.logEvent(
          name: 'notification_open',
          parameters: {'notification_id': message.notification?.title});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: AnimatedSplashScreen(
          splash: Image.asset('assets/images/sp.png'),
          nextScreen: const MyApp(),
          splashTransition: SplashTransition.scaleTransition,
          animationDuration: const Duration(milliseconds: 1000),
          splashIconSize: double.infinity,
          backgroundColor: Colors.black,
          duration: 200,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: UserDataProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AlbumDataProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PictureDataProvider(),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, Auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'User Album',
          theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange)
                      .copyWith(secondary: Colors.red),
              textTheme:
                  const TextTheme(subtitle1: TextStyle(color: Colors.white))),
          home: Auth.isAuth
              ? const UserPageScreen()
              : FutureBuilder(
                  future: Auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const LoadingScreen()
                          : const AuthScreen(),
                ),
          routes: {
            UserPageScreen.routeName: (context) => const UserPageScreen(),
            AlbumPageScreen.routeName: (context) => const AlbumPageScreen(),
            PictureScreen.routeName: (context) => const PictureScreen(),
            PhotoItem.routeName: (context) => const PhotoItem(),
            GetXScreen.routeName: (context) => const GetXScreen(),
          },
        ),
      ),
    );
  }
}
