import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/orders.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/orders_screen.dart' as ordScreem;
import './screens/cart_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext ctx) => Products()
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => Cart()
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          ordScreem.OrdersScreen.routeName: (_) => ordScreem.OrdersScreen(),
        },
      ),
    );
  }
}
