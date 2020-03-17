import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './screens/splash_screen.dart';

import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/orders_screen.dart' as ordScreem;
import './screens/cart_screen.dart';

import './providers/auth.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './providers/cart.dart';

import './helpers/custom_route.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (BuildContext ctx) => Products(null, null, []),
          update: (_, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => Cart()
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (BuildContext ctx) => Orders(null, null, []),
          update: (_, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) =>  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
          ),
          home: auth.isAuth
          ? ProductsOverviewScreen()
          : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultsSnapshot) => authResultsSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
          ),
          routes: {
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            ordScreem.OrdersScreen.routeName: (_) => ordScreem.OrdersScreen(),
            UserProductsScreen.routeName: (_) => UserProductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
            AuthScreen.routeName: (_) => AuthScreen(),
            ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
          },
        ),
      ),
    );
  }
}
