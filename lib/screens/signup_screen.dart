import 'dart:typed_data';
import 'package:connect_app/resources/auth_methods.dart';
import 'package:connect_app/responsiveness/mobile_screen_layout.dart';
import 'package:connect_app/responsiveness/responsive_layout.dart';
import 'package:connect_app/responsiveness/web_screen_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connect_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/FrostedGlassBox.dart';
import '../widgets/text_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void _selectedImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void _signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        username: _usernameController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });
    if (res == 'success') {
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout()),
      ));
    } else {
      showSnackBar(res, context);
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
              child: SingleChildScrollView(
                child: FrostedGlassBox(
                  theHeight: 600,
                  theWidth: 250,
                  theChild: Column(
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
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      'https://img.favpng.com/12/15/21/computer-icons-avatar-user-profile-recommender-system-png-favpng-HaMDUPFH1etkLCdiFjgTKHzAs.jpg'),
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: _selectedImage,
                              icon: const Icon(
                                Icons.camera_alt_rounded,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
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
                          hintText: 'Enter your username',
                          isPass: false,
                          textInputType: TextInputType.text,
                          textEditingController: _usernameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextInputField(
                          hintText: 'Enter your bio',
                          isPass: false,
                          textInputType: TextInputType.text,
                          textEditingController: _bioController,
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
                        onTap: _signUpUser,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)))),
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: const Text(
                              'Already have account ?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              child: const Text(
                                ' Log In',
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
