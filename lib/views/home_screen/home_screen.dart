import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/products_screen/product_details.dart';
import 'package:emart_seller/views/widgets/appbar_widget.dart';
import 'package:emart_seller/views/widgets/dashboard_button.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart' as intl;

import '../../consts/const.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbarWidget(dashboard),
        body: StreamBuilder(
          stream: StoreServices.getProduct(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else {
              var data = snapshot.data!.docs;
              data = data.sortedBy((a, b) =>
                  a['p_wishlist'].length.compareTo(b['p_wishlist'].length));

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          dashboardButton(context,
                              title: products, count: "${data.length}", icon: icproducts),
                          dashboardButton(context,
                              title: orders, count: "${orders.length}", icon: icorders),
                        ],
                      ),
                      10.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          dashboardButton(context,
                              title: rating, count: "60", icon: icstar),
                          dashboardButton(context,
                              title: totalSales, count: "15", icon: icorders),
                        ],
                      ),
                      10.heightBox,
                      const Divider(),
                      10.heightBox,
                      boldText(text: popular, color: fontGrey, size: 16.0),
                      20.heightBox,
                      ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                            data.length,
                            (index) => data[index]['p_wishlist'].length == 0
                                ? const SizedBox()
                                : ListTile(
                                    onTap: () {
                                      Get.to(() =>
                                          ProductDetails(data: data[index]));
                                    },
                                    leading: Image.network(
                                        data[index]['p_imgs'][0],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover),
                                    title: boldText(
                                        text: "${data[index]['p_name']}",
                                        color: fontGrey),
                                    subtitle: normalText(
                                        text: "\$${data[index]['p_price']}",
                                        color: darkGrey),
                                  )),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        )
        // body: SingleChildScrollView(
        //   physics: const BouncingScrollPhysics(),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             dashboardButton(context,
        //                 title: products, count: "60", icon: icproducts),
        //             dashboardButton(context,
        //                 title: orders, count: "15", icon: icorders),
        //           ],
        //         ),
        //         10.heightBox,
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             dashboardButton(context,
        //                 title: rating, count: "60", icon: icstar),
        //             dashboardButton(context,
        //                 title: totalSales, count: "15", icon: icorders),
        //           ],
        //         ),
        //         10.heightBox,
        //         const Divider(),
        //         10.heightBox,
        //         boldText(text: popular, color: fontGrey, size: 16.0),
        //         20.heightBox,
        //         ListView(
        //           physics: const BouncingScrollPhysics(),
        //           shrinkWrap: true,
        //           children: List.generate(
        //               30,
        //               (index) => ListTile(
        //                 onTap: (){},
        //                     leading: Image.asset(imgproduct,
        //                         width: 100, height: 100, fit: BoxFit.cover),
        //                 title: boldText(text: "Product title",color: fontGrey),
        //                 subtitle: normalText(text: "\$40.0",color: darkGrey),
        //                   )),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
