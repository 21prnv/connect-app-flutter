import 'package:connect_app/resources/auth_methods.dart';
import 'package:connect_app/responsiveness/mobile_screen_layout.dart';
import 'package:connect_app/responsiveness/responsive_layout.dart';
import 'package:connect_app/responsiveness/web_screen_layout.dart';
import 'package:connect_app/screens/signup_screen.dart';
import 'package:connect_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/FrostedGlassBox.dart';
import '../widgets/text_input_field.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _logInUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().logInUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/blur-bg.jpg'),
                      fit: BoxFit.cover)),
              alignment: Alignment.center,
              child: FrostedGlassBox(
                theHeight: 400,
                theWidth: 250,
                theChild: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Connect',
                        style: GoogleFonts.satisfy(
                            color: Colors.white, fontSize: 40),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextInputField(
                          hintText: 'Enter your email',
                          isPass: false,
                          textInputType: TextInputType.emailAddress,
                          textEditingController: _emailController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextInputField(
                          hintText: 'Enter your password',
                          isPass: true,
                          textInputType: TextInputType.text,
                          textEditingController: _passwordController,
                        ),
                      ),
                      InkWell(
                        onTap: _logInUser,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            decoration: const ShapeDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 253, 69, 213),
                                      Color.fromARGB(255, 252, 174, 215)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text(
                                    'Log In',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(),
                        flex: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: const Text(
                              'Dont have an account ?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ));
                            },
                            child: Container(
                              child: const Text(
                                ' Sign up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ))),
    );
  }
}
