import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;


class OrderItem extends StatefulWidget {

  final ord.OrderItem order;

  OrderItem(this.order); 

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with TickerProviderStateMixin {

  var _expanded = false;
  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _controller
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.0),
      end: Offset(0, 0)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                if (_expanded) {
                  setState(() {
                  _expanded = false;
                  });
                  _controller.reverse();
                  return;
                }
                setState(() {
                  _expanded = true;
                });
                _controller.forward();
              }
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            height: widget.order.products.length * 20.0 + 20,
            constraints: BoxConstraints(
              minHeight: _expanded ? widget.order.products.length * 20.0 + 20 : 0,
              maxHeight: _expanded ? 100 : 0,
            ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  height: min(
                    widget.order.products.length * 20.0 + 20,
                    100
                  ),
                  child: ListView.builder(
                    itemCount: widget.order.products.length,
                    itemBuilder: (BuildContext _, int i) {
                      final product = widget.order.products[i];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${product.quantity}x \$${product.price}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
