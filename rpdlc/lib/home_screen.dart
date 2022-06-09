import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rpdlc/media_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  File? _image;
  String? _disease;

  Future<String> upload() async {
    var request = http.MultipartRequest('POST', Uri.parse("https://rpdlc.onrender.com/analyze"));
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    http.Response response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: const Center(child: Text('Rice Disease Classification')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              File? temp = await showDialog(
                  context: context,
                  builder: (context) {
                    return const MediaPicker();
                  });
              if (temp != null) {
                _image = temp;
                _disease = null;
              }
              setState(() {});
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                  image: _image != null
                      ? DecorationImage(fit: BoxFit.fill, image: FileImage(_image!))
                      : null),
              child: _image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          color: Colors.blue.shade50,
                          size: 200,
                        ),
                        Text(
                          "  Upload Photo",
                          style: TextStyle(
                              color: Colors.blue.shade50,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              letterSpacing: 2),
                        )
                      ],
                    )
                  : null,
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Disease: " + (_disease ?? "......."),
                style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              )),
          Container(
            padding: const EdgeInsets.all(25),
            width: 200,
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
              onPressed: () async {
                if (_image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.blueGrey,
                      content: Text(
                        "First upload photo",
                        style: TextStyle(color: Colors.blue.shade50, letterSpacing: 2),
                        textAlign: TextAlign.center,
                      )));
                }
                if (!_isLoading && _image != null) {
                  _isLoading = true;
                  setState(() {});
                  _disease = await upload();
                  _isLoading = false;
                  setState(() {});
                }
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                child: _isLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.5),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.blueGrey,
                          color: Colors.blue.shade50,
                        ),
                      )
                    : Text(
                        'Analyze',
                        style: TextStyle(
                          color: Colors.blue.shade50,
                          fontSize: 25,
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
