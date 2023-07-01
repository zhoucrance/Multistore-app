import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/minor_screens/full_screen_view.dart';
import 'package:multi_store_app/minor_screens/visit_store.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../providers/wish_provider.dart';
import '../widgets/models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailsScreen({Key? key, required this.proList})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late List<dynamic> imagesList = widget.proList['proimages'];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.proList['maincateg'])
        .where('subcateg', isEqualTo: widget.proList['subcateg'])
        .snapshots();
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenView(
                                    imagesList: imagesList,
                                  )));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            pagination: const SwiperPagination(
                              builder: SwiperPagination.fraction,
                            ),
                            itemBuilder: (context, index) {
                              return Image(
                                image: NetworkImage(
                                  imagesList[index],
                                ),
                              );
                            },
                            itemCount: imagesList.length,
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.proList['proname'],
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'USD ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.proList['price'].toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  context
                                              .read<Wish>()
                                              .getWishItems
                                              .firstWhereOrNull((product) =>
                                                  product.documentId ==
                                                  widget.proList['proid']) !=
                                          null
                                      ? context.read<Wish>().removeThis(widget.proList['proid'])

                                      : context.read<Wish>().addWishItem(
                                            widget.proList['proname'],
                                            widget.proList['price'],
                                            1,
                                            widget.proList['instock'],
                                            widget.proList['proimages'],
                                            widget.proList['proid'],
                                            widget.proList['sid'],
                                          );
                                },
                                icon:  context
                                    .watch<Wish>()
                                    .getWishItems
                                    .firstWhereOrNull((product) =>
                                product.documentId ==
                                    widget.proList['proid']) !=
                                    null
                                    ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 30,
                                ): const Icon(
                                  Icons.favorite_outline,
                                  color: Colors.red,
                                  size: 30,
                                )),
                          ],
                        ),
                        Text(
                          (widget.proList['instock'].toString()) +
                              (' pieces available in stock'),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueGrey),
                        ),
                        const ProDetailsHeader(
                          label: '  Item Description  ',
                        ),
                        Text(
                          widget.proList['prodesc'],
                          textScaleFactor: 1.1,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade800),
                        ),
                        const ProDetailsHeader(label: ' Similar items '),
                        SizedBox(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _productsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text(
                                  'This category \n\n has no items yet !',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 26,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Acme',
                                      letterSpacing: 1.5),
                                ));
                              }

                              return SingleChildScrollView(
                                child: StaggeredGridView.countBuilder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    crossAxisCount: 2,
                                    itemBuilder: (context, index) {
                                      return ProductModel(
                                        products: snapshot.data!.docs[index],
                                      );
                                    },
                                    staggeredTileBuilder: (context) =>
                                        const StaggeredTile.fit(1)),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisitStore(
                                        suppId: widget.proList['sid'])));
                          },
                          icon: const Icon(Icons.store)),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartScreen(
                                          back: AppBarBackButton(),
                                        )));
                          },
                          icon: const Icon(Icons.shopping_cart)),
                    ],
                  ),
                  YellowButton(
                      width: 0.55,
                      label: 'ADD TO CART',
                      onPressed: () {
                        context.read<Cart>().getItems.firstWhereOrNull(
                                    (product) =>
                                        product.documentId ==
                                        widget.proList['proid']) !=
                                null
                            ? MyMessageHandler.showSnackBar(
                                _scaffoldKey, 'this item already in cart')
                            : context.read<Cart>().addItem(
                                  widget.proList['proname'],
                                  widget.proList['price'],
                                  1,
                                  widget.proList['instock'],
                                  widget.proList['proimages'],
                                  widget.proList['proid'],
                                  widget.proList['sid'],
                                );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailsHeader extends StatelessWidget {
  final String label;
  const ProDetailsHeader({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade300,
              thickness: 1,
            ),
          ),
          Text(label,
              style: TextStyle(
                  color: Colors.yellow.shade700,
                  fontSize: 24,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade300,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
