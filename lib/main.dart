import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

void main() => runApp(MyWidget());

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: AnimatedSplashScreen(
          splash: Image.asset('assets/images/sp.png'),
          nextScreen: MyApp(),
          splashTransition: SplashTransition.scaleTransition,
          animationDuration: Duration(milliseconds: 1000),
          splashIconSize: double.infinity,
          backgroundColor: Colors.black,
          duration: 200,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
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
              textTheme: TextTheme(subtitle1: TextStyle(color: Colors.white))),
          home: Auth.isAuth
              ? UserPageScreen()
              : FutureBuilder(
                  future: Auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? LoadingScreen()
                          : AuthScreen(),
                ),
          routes: {
            UserPageScreen.routeName: (context) => UserPageScreen(),
            AlbumPageScreen.routeName: (context) => AlbumPageScreen(),
            PictureScreen.routeName: (context) => PictureScreen(),
          },
        ),
      ),
    );
  }
}
