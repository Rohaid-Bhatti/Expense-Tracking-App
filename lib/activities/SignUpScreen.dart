import 'package:demo/activities/DashboardScreen.dart';
import 'package:demo/activities/LoginScreen.dart';
import 'package:demo/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();

  //my code
  var controller = Get.put(AuthController());

  //text controller
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpassController = TextEditingController();

  bool agreeWithTeams = false;
  bool _securePassword = true;
  bool _secureConfirmPassword = true;

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool? checkBoxValue = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const SingleChildScrollView(
            child: ListBody(
                children: [Text('Please agree the terms and conditions')]),
          ),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20,),
              const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10,),
              Form(
                key: _signUpFormKey,
                child: Obx(
                      () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //user name
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("Name cannot be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid name(Min. 3 Character)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          nameController.text = value!;
                        },
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Username",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(width: 3, color: Colors.black),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //email
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        enableSuggestions: true,
                        autocorrect: true,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          hintText: "Email",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(width: 3, color: Colors.black),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //phone number
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          RegExp regex = new RegExp(r'^(?:[+0]9)?[0-9]{11}$');
                          if (value!.length == 0) {
                            return ("Please enter mobile number");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Please enter valid mobile number");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          phoneController.text = value!;
                        },
                        inputFormatters: [LengthLimitingTextInputFormatter(11)],
                        decoration: InputDecoration(
                          hintText: "Enter mobile number",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(width: 3, color: Colors.black),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //password
                      TextFormField(
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _securePassword,
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                        },
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          hintText: "Password",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(width: 3, color: Colors.black),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: IconButton(
                              icon: Icon(
                                  _securePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 18),
                              onPressed: () {
                                _securePassword = !_securePassword;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //confirm password
                      TextFormField(
                        controller: confirmpassController,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: _secureConfirmPassword,
                        validator: (value) {
                          if (confirmpassController.text !=
                              passwordController.text) {
                            return "Password don't match";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          confirmpassController.text = value!;
                        },
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          hintText: "Re-enter Password",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(width: 3, color: Colors.black),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: IconButton(
                              icon: Icon(
                                  _secureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 18),
                              onPressed: () {
                                _secureConfirmPassword =
                                !_secureConfirmPassword;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.black),
                        child: CheckboxListTile(
                          contentPadding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          activeColor: Colors.black,
                          title: const Text("I agree to the Terms and Conditions",
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          value: checkBoxValue,
                          dense: true,
                          onChanged: (newValue) {
                            setState(() {
                              checkBoxValue = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        )
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            textStyle: const TextStyle(fontSize: 25),
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            if (_signUpFormKey.currentState!.validate()) {
                              if (checkBoxValue != false) {
                                controller.isLoading(true);
                                try {
                                  await controller
                                      .signupMethod(
                                      email: emailController.text,
                                      password:
                                      passwordController.text)
                                      .then((value) {
                                    return controller.storeUserData(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phoneNumber: phoneController.text,
                                    );
                                  }).then((value) {
                                    Fluttertoast.showToast(
                                      msg: "Account created successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 14,
                                    );
                                    Get.offAll(const DashboardScreen());
                                    controller.isLoading(false);
                                  });
                                } catch (e) {
                                  FirebaseAuth.instance.signOut();
                                  Fluttertoast.showToast(
                                    msg: e.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 14,
                                  );
                                  controller.isLoading(false);
                                }
                              } else {
                                _showAlertDialog();
                              }
                            }
                          },
                          child: const Text("Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Have an account?",
                                style: TextStyle(fontSize: 16)),
                            SizedBox(height: 8),
                            Text('Sign In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
