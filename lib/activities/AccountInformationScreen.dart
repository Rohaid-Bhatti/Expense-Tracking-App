import 'dart:io';

import 'package:demo/components/text_field_widget.dart';
import 'package:demo/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AccountInformation extends StatefulWidget {
  final dynamic data;

  const AccountInformation({Key? key, this.data}) : super(key: key);

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  var controller1 = Get.put(ProfileController());
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "My Profile",
          textAlign: TextAlign.center,
        ),
      ),
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 45),
                      shape: StadiumBorder(),
                    ),
                    child: Text("Save", style: TextStyle(fontSize: 16)),
                    onPressed: () async {
                      controller.isLoading(true);

                      //if image is not selected
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink = widget.data['image'];
                      }

                      await controller.updateProfile(
                        image: controller.profileImageLink,
                        name: controller.nameController.text,
                        email: controller.emailController.text,
                        phoneNumber: controller.phoneController.text,
                      );
                      Fluttertoast.showToast(msg: "Update successfully");
                    },
                  ),
                );
        },
        onClosing: () {},
      ),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            GestureDetector(
              onTap: () {
                controller.changeImage();
              },
              child: Center(
                child: Stack(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: widget.data['image'] == '' &&
                                controller.profileImgPath.isEmpty
                            ? const Image(
                                image: AssetImage('assets/images/user.png'),
                              )
                            : widget.data['image'] != '' &&
                                    controller.profileImgPath.isEmpty
                                ? Image.network(widget.data['image'])
                                : Image.file(
                                    File(controller.profileImgPath.value),
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -2,
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFieldWidget("Full Name", controller.nameController),
            SizedBox(height: 15),
            TextFieldWidget("Email", controller.emailController),
            SizedBox(height: 15),
            TextFieldWidget("Phone Number", controller.phoneController),
            SizedBox(height: 55),
          ],
        ),
      ),
    );
  }
}
