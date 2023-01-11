import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile> selectImages = await imagePicker.pickMultiImage();
    if (selectImages.isNotEmpty) {
      imageFileList!.addAll(selectImages);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Multiple image picker Example")),
      body: Column(
        children: [
          MaterialButton(
            color: Colors.amber,
            child: const Text("Pick Imeage from gallery"),
            onPressed: () {
              selectImages();
            },
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.8),
              child: GridView.builder(
                itemCount: imageFileList!.length,
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Image.file(
                    File(imageFileList![index].path),
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
