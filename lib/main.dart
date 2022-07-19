import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_application/provider/cart_provider.dart';
import 'package:shop_application/provider/orders_provider.dart';
import 'package:shop_application/provider/product_provider.dart';
import 'package:shop_application/routes/routes.dart';
import 'package:shop_application/values/strings.dart';

void main() {
  runApp(const MyApp());
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey, // set property
        routes: Routes.getRoutes(),
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.orange,
          // canvasColor: const Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Lato',
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1:
                    const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                bodyText2:
                    const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                // titleLarge: const TextStyle(
                //   fontSize: 24,
                //   fontFamily: 'RobotoCondensed',
                // ),
                // titleMedium: const TextStyle(
                //   fontSize: 18,
                //   fontFamily: 'RobotoCondensed',
                // ),
                // titleSmall: const TextStyle(
                //   fontSize: 15,
                //   fontFamily: 'RobotoCondensed',
                // ),
              ),
        ),
        initialRoute: Routes.productOverviewScreen,
      ),
    );
  }
}
