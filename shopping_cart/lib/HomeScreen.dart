import 'package:badges/badges.dart' as badge;
// import 'package:cartapp/helper/db_helper.dart';
// import 'package:cartapp/model/cart_model.dart';
// import 'package:cartapp/provider/cartprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';
import 'db_helper.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<String> productName=['Orange','Mango','Grape','Strawberry','Lemon','Pomegranate',
    'Apple','Guava','Blackberry','Watermelon','Peach','Max Fruit'];
  List<String> productUnit=['Dozen','KG','KG','KG','KG','KG','KG','KG','KG','KG','KG','KG'];
  List<int> productPrice=[10,20,30,40,50,60,30,40,50,80,70,100];
  List<String> productImage=[
    'https://freepngimg.com/thumb/orange/19-orange-png-image-download.png',
    'https://freepngimg.com/thumb/mango/9-2-mango-transparent.png',
    'https://freepngimg.com/thumb/grape/4-grape-png-image-download-picture.png',
    'https://freepngimg.com/thumb/strawberry/14-2-strawberry-png-images.png',
    'https://freepngimg.com/thumb/lemon/6-2-lemon-png-image.png',
    'https://freepngimg.com/thumb/pomegranate/5-pomegranate-png-image.png',
    'https://freepngimg.com/thumb/apple/7-2-apple-fruit-png.png',
    'https://freepngimg.com/thumb/guava/2-2-guava-transparent.png',
    'https://freepngimg.com/thumb/blackberry/4-2-blackberry-fruit-png-image.png',
    'https://freepngimg.com/thumb/watermelon/3-watermelon-png-image.png',
    'https://freepngimg.com/thumb/peach/6-peach-png-image.png',
    'https://freepngimg.com/thumb/fruit/4-2-fruit-png-image.png',

  ];

  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: badge.Badge(
                showBadge: true,
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(value.getCounter().toString(),
                        style: TextStyle(color: Colors.white));
                  },
                ),
                // animationType: BadgeAnimationType.fade,
                // animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20.0)
        ],
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20),
                  itemCount: productName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ClipOval(
                              child: Image(
                                image: NetworkImage(
                                    productImage[index].toString()),
                                width: 120,
                                height: 120,
                                fit: BoxFit.fill,
                              ),
                              // )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(productName[index].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                  Text(productUnit[index].toString() + " " + r"$" + productPrice[index].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        print(index);
                                        print(index);
                                        print(productName[index].toString());
                                        print(productPrice[index].toString());
                                        print(productPrice[index]);
                                        print('1');
                                        print(productUnit[index].toString());
                                        print(productImage[index].toString());

                                        dbHelper!
                                            .insert(Cart(
                                            id: index,
                                            productId: index.toString(),
                                            productName: productName[index].toString(),
                                            initialPrice: productPrice[index],
                                            productPrice: productPrice[index],
                                            quantity: 1,
                                            unitTag: productUnit[index].toString(),
                                            image: productImage[index].toString(),
                                        )).then((value) {
                                          cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                          cart.addCounter();

                                          final snackBar = SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                'Product is added to cart'),
                                            duration: Duration(seconds: 1),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }).onError((error, stackTrace) {
                                          print("error" + error.toString());
                                          final snackBar = SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  'Product is already added in cart'),
                                              duration: Duration(seconds: 1));

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                            BorderRadius.circular(5)),
                                        child: const Center(
                                          child: Text(
                                            'Add to cart',
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          )
                          // );
                        ]));
                  }),
            ),

            //  ListView.builder(
            //     itemCount: productName.length,
            //     itemBuilder: (context, index) {
            //       return Card(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 mainAxisSize: MainAxisSize.max,
            //                 children: [
            //                   Image(
            //                     height: 100,
            //                     width: 100,
            //                     image: NetworkImage(
            //                         productImage[index].toString()),
            //                   ),
            //                   SizedBox(
            //                     width: 10,
            //                   ),
            //                   Expanded(
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           productName[index].toString(),
            //                           style: TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w500),
            //                         ),
            //                         SizedBox(
            //                           height: 5,
            //                         ),
            //                         Text(
            //                           productUnit[index].toString() +
            //                               " " +
            //                               r"$" +
            //                               productPrice[index].toString(),
            //                           style: TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w500),
            //                         ),
            //                         SizedBox(
            //                           height: 5,
            //                         ),
            //                         Align(
            //                           alignment: Alignment.centerRight,
            //                           child: InkWell(
            //                             onTap: () {
            //                               print(index);
            //                               print(index);
            //                               print(productName[index].toString());
            //                               print(productPrice[index].toString());
            //                               print(productPrice[index]);
            //                               print('1');
            //                               print(productUnit[index].toString());
            //                               print(productImage[index].toString());

            //                               dbHelper!
            //                                   .insert(Cart(
            //                                       id: index,
            //                                       productId: index.toString(),
            //                                       productName:
            //                                           productName[index]
            //                                               .toString(),
            //                                       initialPrice:
            //                                           productPrice[index],
            //                                       productPrice:
            //                                           productPrice[index],
            //                                       quantity: 1,
            //                                       unitTag: productUnit[index]
            //                                           .toString(),
            //                                       image: productImage[index]
            //                                           .toString()))
            //                                   .then((value) {
            //                                 cart.addTotalPrice(double.parse(
            //                                     productPrice[index]
            //                                         .toString()));
            //                                 cart.addCounter();

            //                                 final snackBar = SnackBar(
            //                                   backgroundColor: Colors.green,
            //                                   content: Text(
            //                                       'Product is added to cart'),
            //                                   duration: Duration(seconds: 1),
            //                                 );

            //                                 ScaffoldMessenger.of(context)
            //                                     .showSnackBar(snackBar);
            //                               }).onError((error, stackTrace) {
            //                                 print("error" + error.toString());
            //                                 final snackBar = SnackBar(
            //                                     backgroundColor: Colors.red,
            //                                     content: Text(
            //                                         'Product is already added in cart'),
            //                                     duration: Duration(seconds: 1));

            //                                 ScaffoldMessenger.of(context)
            //                                     .showSnackBar(snackBar);
            //                               });
            //                             },
            //                             child: Container(
            //                               height: 35,
            //                               width: 100,
            //                               decoration: BoxDecoration(
            //                                   color: Colors.green,
            //                                   borderRadius:
            //                                       BorderRadius.circular(5)),
            //                               child: const Center(
            //                                 child: Text(
            //                                   'Add to cart',
            //                                   style: TextStyle(
            //                                       color: Colors.white),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         )
          )
        ],
      ),
    );
  }
}