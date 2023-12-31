import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens/product_details.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../../providers/wish_provider.dart';



class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({Key? key, required this.products}) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        Navigator.push(
            context, MaterialPageRoute(builder: (context)=>  ProductDetailsScreen(proList: widget.products,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Container(
                  constraints: const BoxConstraints(
                      minHeight: 100, maxHeight: 250),
                  child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          widget.products
                      ['proimages'][0],
                      ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      widget.products['proname'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.products['price']
                              .toStringAsFixed(2) +
                              (' \$'),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                       widget.products['sid'] == FirebaseAuth.instance.currentUser!.uid? IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                        ) :IconButton(
                           onPressed: () {
                             context
                                 .read<Wish>()
                                 .getWishItems
                                 .firstWhereOrNull((product) =>
                             product.documentId ==
                                 widget.products['proid']) !=
                                 null
                                 ? context.read<Wish>().removeThis(widget.products['proid'])

                                 : context.read<Wish>().addWishItem(
                               widget.products['proname'],
                               widget.products['price'],
                               1,
                               widget.products['instock'],
                               widget.products['proimages'],
                               widget.products['proid'],
                               widget.products['sid'],
                             );
                           },
                           icon:  context
                               .watch<Wish>()
                               .getWishItems
                               .firstWhereOrNull((product) =>
                           product.documentId ==
                               widget.products['proid']) !=
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
