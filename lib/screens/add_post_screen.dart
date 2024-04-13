import 'dart:typed_data';

import 'package:connect_app/providers/user_provider.dart';
import 'package:connect_app/resources/auth_methods.dart';
import 'package:connect_app/resources/firestore_methods.dart';
import 'package:connect_app/resources/storage_method.dart';
import 'package:connect_app/utils/utils.dart';
import 'package:connect_app/widgets/text_input_field.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:connect_app/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final AuthMethods _authMethods = AuthMethods();

  TextEditingController _captionCtroller = TextEditingController();
  bool _isLoading = false;
  Uint8List? _file;
  late User _user;

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  showDialogeBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void postImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
        _captionCtroller.text,
        _file!,
        _user.uid,
        _user.username,
        _user.profileUrl,
      );

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted successfully!', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    User userDetails = await _authMethods
        .getUserDetails(); // Replace this with your method to fetch user details
    setState(() {
      _user = userDetails;
    });
  }

  @override
  void dispose() {
    _captionCtroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () => showDialogeBox(context),
                icon: const Icon(Icons.file_upload_outlined)),
          )
        : Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Colors.red, Colors.blue])),
              ),
              leading: IconButton(
                  onPressed: clearImage,
                  icon: const Icon(Icons.arrow_back_ios)),
              centerTitle: true,
              title: Text('Add Post'),
            ),
            body: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 242, 144, 245),
                  Color.fromARGB(255, 236, 103, 21)
                ],
              )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _isLoading
                        ? const LinearProgressIndicator()
                        : const Padding(padding: EdgeInsets.only(top: 0)),
                    const Divider(),
                    Container(
                        margin: const EdgeInsets.all(8),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            image: _file != null
                                ? DecorationImage(image: MemoryImage(_file!))
                                : null)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _captionCtroller,
                        style: TextStyle(color: Colors.white.withOpacity(1)),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'Write a caption',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(1)),
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        postImage();
                      },
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
                                  'Post',
                                  style: TextStyle(color: Colors.white),
                                ),
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
