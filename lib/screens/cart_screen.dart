import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart' show Orders;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<Cart>(
                builder: (BuildContext _, Cart cart, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Chip(
                        label: Text(
                          cart.totalAmount.toStringAsFixed(2),
                          style: TextStyle(
                            color: Theme.of(context).primaryTextTheme.title.color,
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text('Order Now'),
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount
                        );
                        cart.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: Consumer<Cart>(
              builder: (BuildContext _, Cart cart, Widget ch) => ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (BuildContext _, int index) => CartItem(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  price: cart.items.values.toList()[index].price,
                  title: cart.items.values.toList()[index].title,
                  quantity: cart.items.values.toList()[index].quantity
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}