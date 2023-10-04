import 'package:demo/activities/DashboardScreen.dart';
import 'package:demo/activities/SignUpScreen.dart';
import 'package:demo/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  //my code
  var controller = Get.put(AuthController());
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool _securePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text("Welcome back!",
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Text("Please Login to your account",
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                const SizedBox(
                  height: 15,
                ),
                Image.asset('assets/images/management.png',
                    width: 100, height: 100, fit: BoxFit.cover),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: _loginFormKey,
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enableSuggestions: true,
                      autocorrect: true,

                      //my code
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

                      decoration: InputDecoration(
                        hintText: "Email",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          //<-- SEE HERE
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          size: 18,
                        ),
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _securePassword,

                      //my code
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

                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: "Password",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          //<-- SEE HERE
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        prefixIcon: Icon(Icons.lock_outline, size: 18),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 5.0),
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
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.blue),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(16),
                                textStyle: TextStyle(fontSize: 16),
                                shape: StadiumBorder(),
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () async {
                                if (_loginFormKey.currentState!.validate()) {
                                  controller.isLoading(true);
                                  await controller
                                      .loginMethod(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  )
                                      .then((value) async {
                                    if (value != null) {
                                      Fluttertoast.showToast(
                                        msg: "Logged in successfully",
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 14,
                                      );
                                      Get.offAll(DashboardScreen());
                                      //checking
                                      controller.isLoading(false);
                                    } else {
                                      controller.isLoading(false);
                                    }
                                  });
                                }
                              },
                              child: const Text("Log In",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white)),
                            ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account?", style: TextStyle(fontSize: 16)),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Sign Up',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
