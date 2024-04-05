import 'package:emart_seller/consts/const.dart';
// import 'package:emart_seller/views/widgets/text_style.dart';

Widget productImages({required lable,onPress}) {
  return "$lable"
      .text
      .bold
      .size(16.0)
      .color(fontGrey)
      .makeCentered()
      .box
      .color(lightGrey)
      .size(100, 100)
      .roundedSM
      .make();


}
