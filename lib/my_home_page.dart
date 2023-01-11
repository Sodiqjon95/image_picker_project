import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_project/custom_diolog.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

final List<File> _photos = [];
  final List<String> _photosUrls = [];
  final List<PhotoSource> _photosSources = [];

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


_onAddPhotoClicked(context) async {
    Permission permission;

    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }

    PermissionStatus permissionStatus = await permission.status;
    var galleryWritePermission = Permission.storage;

    log("Status is :$permissionStatus");
    if (permissionStatus == PermissionStatus.granted) {
      print('Permission grantedd');
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image != null) {
        String fileExtension = (image.path);
        setState(() {
          _photos.add(File(image.path));
          _photosSources.add(PhotoSource.FILE);
        });
      }
    }
    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context);
        log("message");
      } else {
        permissionStatus = await permission.request();
      }
    }
    if (permissionStatus == PermissionStatus.limited) {
      if (Platform.isIOS) {
        permissionStatus = await permission.request();
        _showOpenAppSettingsDialog(context);
        print('${await openAppSettings()}'); //
      } else {
        permissionStatus = await permission.request();
      }
    }

    if (permissionStatus == PermissionStatus.restricted) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }
  }

  _showOpenAppSettingsDialog(context) {
    return CustomDialog.show(
      context,
      'Permission needed',
      'Photos permission is needed to select photos',
      'Open settings',
      openAppSettings,
    );
  }
}

enum PhotoSource { FILE, NETWORK }

class GalleryItem {
  GalleryItem({required this.id, required this.resource, this.isSvg = false});
  final String id;
  String resource;
  final bool isSvg;
}