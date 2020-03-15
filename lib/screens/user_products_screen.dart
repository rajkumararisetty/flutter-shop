import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext ctx) async {
    Provider.of<Products>(ctx, listen: false).fetchAndSetProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName)
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Products>(context, listen: false).fetchAndSetProducts(filterByUser: true),
        builder: (ctx, dataSnapShot) => dataSnapShot.connectionState == ConnectionState.waiting ? Center(
          child: CircularProgressIndicator(),
        ) : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<Products>(
              builder: (ctx,productsData, _) => ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, i) => Column(
                  children: <Widget>[
                    UserProductItem(
                      id: productsData.items[i].id,
                      title: productsData.items[i].title,
                      imageUrl: productsData.items[i].imageUrl,
                    ),
                    const Divider(thickness: 1,)
                  ],
                )
              ),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}