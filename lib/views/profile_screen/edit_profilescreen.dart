import 'dart:io';

import 'package:emart_seller/consts/const.dart';
import 'package:emart_seller/controllers/profile_controller.dart';
import 'package:emart_seller/views/widgets/custom_textfield.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import '../widgets/text_style.dart';
import 'package:get/get.dart';
class EditProfileScreen extends StatefulWidget {
  final String? username;
  const EditProfileScreen({super.key, this.username});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<ProfileController>();


  @override
  void initState() {
    controller.nameController.text = widget.username!;
    // TODO: implement initState
    super.initState();
    // nameController.addListener(() {
    //   final String text = nameController.text;
    //   nameController.value = nameController.value.copyWith(
    //     text: text,
    //   );
    // });
  }
  // void dispose() {
  //   super.dispose();
  //   nameController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false, // emart use
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      //if image is not selected
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImgLink =
                            controller.snapshotData['imageUrl'];
                      }
                      //old password match is data base
                      if (controller.snapshotData['password'] ==
                          controller.oldpasswordController.text) {
                        await controller.changeAuthPassword(
                            email: controller.snapshotData['email'],
                            password: controller.oldpasswordController.text,
                            newPassword: controller.newpasswordController.text);
                        await controller.updateProfile(
                          imgUrl: controller.profileImgLink,
                          name: controller.nameController.text,
                          password: controller.newpasswordController.text,
                        );
                        VxToast.show(context, msg: '1Updated');
                      } else if (controller
                              .oldpasswordController.text.isEmptyOrNull &&
                          controller.newpasswordController.text.isEmptyOrNull) {
                        await controller.updateProfile(
                          imgUrl: controller.profileImgLink,
                          name: controller.nameController.text,
                          password: controller.snapshotData['password'],
                        );
                        VxToast.show(context, msg: '2Updated');
                      } else {
                        VxToast.show(context, msg: 'Some error occured');
                        controller.isloading(false);
                      }
                    },
                    child: normalText(text: save)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              controller.snapshotData['imageUrl'] == '' &&
                      controller.profileImgPath.isEmpty
                  ? Image.asset(imgproduct, width: 100, fit: BoxFit.cover)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make()
                  : controller.snapshotData['imageUrl'] != '' &&
                          controller.profileImgPath.isEmpty
                      ? Image.network(
                          controller.snapshotData['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      : Image.file(
                          File(controller.profileImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: white),
                onPressed: () {
                  controller.changeImage(context);
                },
                child: normalText(text: changeImage, color: fontGrey),
              ),
              10.heightBox,
              const Divider(color: white),
              customTextField(
                  label: name,
                  hint: "eg. Jeel Patel",
                  controller: controller.nameController),
              30.heightBox,
              Align(
                  alignment: Alignment.centerLeft,
                  child: boldText(text: "Change your password")),
              20.heightBox,
              customTextField(
                  label: password,
                  hint: passwordHint,
                  controller: controller.oldpasswordController),
              10.heightBox,
              customTextField(
                  label: confirmPass,
                  hint: passwordHint,
                  controller: controller.newpasswordController),
            ],
          ),
        ),
      ),
    );
  }
}
