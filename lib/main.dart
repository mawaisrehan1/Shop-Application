import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_application/provider/auth_provider.dart';
import 'package:shop_application/provider/cart_provider.dart';
import 'package:shop_application/provider/orders_provider.dart';
import 'package:shop_application/provider/product_provider.dart';
import 'package:shop_application/routes/custom_route_transition.dart';
import 'package:shop_application/routes/routes.dart';
import 'package:shop_application/screens/auth_screen.dart';
import 'package:shop_application/screens/products_overview_screen.dart';
import 'package:shop_application/values/strings.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: AuthProvider(),
            ),
            ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
              create: (ctx) => ProductsProvider('', '', []),
              update: (ctx, auth, previousProducts) => ProductsProvider(
                auth.token ?? '',
                auth.userId ?? '',
                previousProducts == null ? [] : previousProducts.items,
              ),
            ),
            ChangeNotifierProvider.value(
              value: CartProvider(),
            ),
            ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
              //    value: OrdersProvider(),
              create: (ctx) => OrdersProvider('', '', []),
              update: (ctx, auth, previousOrders) => OrdersProvider(
                auth.token as String,
                auth.userId as String,
                previousOrders == null ? [] : previousOrders.orders,
              ),
            ),
          ],
          child: const MyApp()));
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
  late SharedPreferences prefs;

  getPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    getPref();
    return Consumer<AuthProvider>(
      builder: (ctx, authProvider, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey, // set property
        routes: Routes.getRoutes(),
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.orange,
          // canvasColor: const Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }
          ),
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
        //  initialRoute: Routes.productOverviewScreen,
        // initialRoute:
        home: /*authProvider.tryAutoLogin()
          ? ProductOverviewScreen()
          :*/
            FutureBuilder<bool>(
                future: authProvider.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) {
                  if (authResultSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (authResultSnapshot.connectionState ==
                      ConnectionState.done) {
                    if (authResultSnapshot.hasData) {
                      print("AUTH RESULT");
                      print(authResultSnapshot.data);
                      if (authResultSnapshot.data!) {
                        final extractedUserData = json.decode(
                            prefs.getString('userData') as String) as Map;
                        Provider.of<ProductsProvider>(context,
                                listen: false)
                            .authToken = extractedUserData['token']!;
                        Provider.of<ProductsProvider>(context,
                                listen: false)
                            .userId = extractedUserData['userId']!;
                        return const ProductOverviewScreen();
                      } else {
                        return const AuthScreen();
                      }
                    } else {
                      return const AuthScreen();
                    }
                  } else {
                    return const Text("ERROR");
                  }
                }),
      ),
    );
  }
}

// ch 11 < video 13 < mint 6 ....
