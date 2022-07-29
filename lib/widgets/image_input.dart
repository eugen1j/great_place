import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  void Function(File pickedImage) onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (imageFile != null) {
      setState(() {
        _storedImage = File(imageFile.path);
      });


      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final imageName = path.basename(_storedImage!.path);
      final savedImage =
          await _storedImage!.copy(path.join(appDir.path, imageName));
      widget.onSelectImage(savedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage == null
              ? Text("No Image")
              : Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(width: 10),
        Spacer(),
        TextButton.icon(
          onPressed: _takePicture,
          label: Text('Take Picture'),
          icon: Icon(Icons.camera),
          style: Theme.of(context).textButtonTheme.style,
        ),
        Spacer(),
      ],
    );
  }
}
