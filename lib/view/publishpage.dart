import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zenverse_mobile_apps/services/api_services_games.dart';
import 'package:zenverse_mobile_apps/model/publish_model.dart';

class MyPublishpage extends StatefulWidget {
  const MyPublishpage({super.key});

  @override
  State<MyPublishpage> createState() => _MyPublishpageState();
}

class _MyPublishpageState extends State<MyPublishpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gameNameController = TextEditingController();
  final TextEditingController _developerNameController =
      TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _gamePreviewController = TextEditingController();
  final TextEditingController _gameLinkController = TextEditingController();
  final TextEditingController _gameDescriptionController =
      TextEditingController();
  final TextEditingController _developerBioController = TextEditingController();
  final ApiServices _dataServices = ApiServices();

  String? _gameLogoUrl;
  String? _gameBannerUrl;

  File? _gameLogo;
  File? _gameBanner;

  Future<void> _pickImage(ImageSource source, bool isLogo) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);

      String? imageUrl = await _dataServices.uploadImage(selectedImage);

      if (imageUrl != null) {
        setState(() {
          if (isLogo) {
            _gameLogo = selectedImage;
            _gameLogoUrl = imageUrl;
            print("Game Logo URL: $imageUrl");
          } else {
            _gameBanner = selectedImage;
            _gameBannerUrl = imageUrl;
            print("Game Banner URL: $imageUrl");
          }
        });
      } else {
        print("Upload gagal");
      }
    }
  }

  Future<void> _submitGame() async {
    if (_formKey.currentState!.validate()) {
      List<String> genreList =
          _genreController.text.split(",").map((e) => e.trim()).toList();

      GamesModelPost game = GamesModelPost(
        name: _gameNameController.text,
        desc: _gameDescriptionController.text,
        genre: genreList,
        devName: DeveloperModelPost(
          name: _developerNameController.text,
          bio: _developerBioController.text,
        ),
        gameBanner: _gameBannerUrl ?? "",
        preview: _gamePreviewController.text,
        linkGames: _gameLinkController.text,
        gameLogo: _gameLogoUrl ?? "",
      );

      bool success = await _dataServices.insertGame(game);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Game berhasil ditambahkan!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menambahkan game.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/icon/blue-logo.png',
          height: 30,
        ),
        backgroundColor: const Color.fromARGB(255, 54, 57, 62),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/submitbg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 114, 137, 218),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Submit Your Game',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Warna teks tetap kontras
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(_gameNameController, 'Game Name'),
                  _buildTextField(_developerNameController, 'Developer Name'),
                  _buildTextField(_genreController, 'Genre'),
                  _buildTextField(_gamePreviewController, 'Game Preview'),
                  _buildTextField(_gameLinkController, 'Game Link'),
                  _buildTextField(
                      _gameDescriptionController, 'Game Description',
                      maxLines: 2),
                  _buildTextField(
                      _developerBioController, 'Developer Biography',
                      maxLines: 2),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 162, 162, 162),
                          ),
                          child: _gameLogo == null
                              ? Center(
                                  child: Image.asset(
                                    'assets/img/default-logo.png',
                                    height: 80,
                                  ),
                                )
                              : Image.file(_gameLogo!, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 114, 137, 218),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'Game Logo',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                  _gameLogo != null
                                      ? 'Name: ${_gameLogo!.path.split('/').last}'
                                      : 'No file selected',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                              Text(
                                  _gameLogo != null
                                      ? 'Path: ${_gameLogo!.path}'
                                      : '',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 9)),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 6, 10, 6)),
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery, true),
                                child: const Text('Pick Image'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: _buildImagePicker('Game Banner', _gameBanner,
                        () => _pickImage(ImageSource.gallery, false)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Berhasil submit teu');
                      _submitGame();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildImagePicker(String label, File? image, VoidCallback onPick) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onPick,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromARGB(255, 162, 162, 162),
            ),
            child: image == null
                ? const Center(
                    child: Text('Tap to pick image',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)))
                : Image.file(image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
