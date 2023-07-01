import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import '../providers/cart_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/yellow_button.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;
  const CartScreen({Key? key, this.back}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: widget.back,
            title: const AppBarTitle(
              title: 'Cart',
            ),
            actions: [
              context.watch<Cart>().getItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                            context: context,
                            title: 'Clear Cart',
                            content: 'Are you sure to clear cart  ?',
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: () {
                              context.read<Cart>().clearCart();
                              Navigator.pop(context);
                            });
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
                    )
            ],
          ),
          body: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total: \$ ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      context.watch<Cart>().totalprice.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                YellowButton(
                  width: 0.45,
                  label: 'CHECK OUT',
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
            itemCount: cart.count,
            itemBuilder: (context, index) {
              final product = cart.getItems[index];
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: SizedBox(
                    height: 100,
                    width: 120,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 120,
                          child: Image.network(product.imagesUrl.first),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cart.getItems[index].name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product.price.toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        children: [
                                          product.qty == 1
                                              ? IconButton(
                                                  onPressed: () {
                                                    showCupertinoModalPopup<
                                                        void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          CupertinoActionSheet(
                                                        title: const Text(
                                                            'RemoveItem'),
                                                        message: const Text(
                                                            'Are you sure to remove this item ?'),
                                                        actions: <
                                                            CupertinoActionSheetAction>[
                                                          CupertinoActionSheetAction(
                                                            /// This parameter indicates the action would be a default
                                                            /// defualt behavior, turns the action's text to bold text.
                                                            isDefaultAction:
                                                                true,
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Default Action'),
                                                          ),
                                                          CupertinoActionSheetAction(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Move To Wishlist'),
                                                          ),
                                                          CupertinoActionSheetAction(
                                                            /// This parameter indicates the action would perform
                                                            /// a destructive action such as delete or exit and turns
                                                            /// the action's text color to red.
                                                            isDestructiveAction:
                                                                true,
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Delete Item'),
                                                          ),
                                                        ],
                                                        cancelButton:
                                                            TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_forever,
                                                    size: 18,
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    cart.reduceByOne(product);
                                                  },
                                                  icon: const Icon(
                                                    FontAwesomeIcons.minus,
                                                    size: 18,
                                                  )),
                                          Text(
                                            product.qty.toString(),
                                            style: product.qty == product.qntty
                                                ? const TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Acme',
                                                    color: Colors.red,
                                                  )
                                                : const TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Acme',
                                                  ),
                                          ),
                                          IconButton(
                                              onPressed: product.qty ==
                                                      product.qntty
                                                  ? null
                                                  : () {
                                                      cart.increment(product);
                                                    },
                                              icon: const Icon(
                                                FontAwesomeIcons.plus,
                                                size: 18,
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Cart Is Empty !',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 50,
          ),
          Material(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, '/customer_home');
              },
              minWidth: MediaQuery.of(context).size.width * 0.6,
              child: const Text(
                'continue shopping',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
