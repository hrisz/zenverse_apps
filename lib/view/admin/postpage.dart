import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zenverse_mobile_apps/services/api_services_games.dart';
import 'package:zenverse_mobile_apps/model/gamespost_admin.dart';
import 'package:zenverse_mobile_apps/view/admin/dashboard.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({super.key});

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gameNameController = TextEditingController();
  final TextEditingController _ratingController =TextEditingController();
  final TextEditingController _developerNameController =TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _gamePreviewController = TextEditingController();
  final TextEditingController _gameLinkController = TextEditingController();
  final TextEditingController _gameDescriptionController =
      TextEditingController();
  final TextEditingController _developerBioController = TextEditingController();
  final ApiServices _dataServices = ApiServices();

  File? _gameLogo;
  File? _gameBanner;
  String? _logoUrl;
  String? _bannerUrl;
  

  Future<void> _pickImage(bool isLogo) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      setState(() {
        if (isLogo) {
          _gameLogo = imageFile;
        } else {
          _gameBanner = imageFile;
        }
      });

      String? uploadedUrl = await _dataServices.uploadImage(imageFile);
      debugPrint("Response Upload: $uploadedUrl");

      setState(() {
        if (isLogo) {
          _logoUrl = uploadedUrl;
        } else {
          _bannerUrl = uploadedUrl;
        }
      });
      debugPrint("Gambar berhasil diunggah: $uploadedUrl");
        }
  }

  Future<void> _submitGame() async {
  if (_formKey.currentState!.validate()) {
    if (_logoUrl == null || _bannerUrl == null) {
      debugPrint("Harap unggah logo dan banner game.");
      return;
    }

    List<String> genreList = _genreController.text.split(',').map((e) => e.trim()).toList();

    GameModelPostAdmin game = GameModelPostAdmin(
      name: _gameNameController.text,
      rating: double.tryParse(_ratingController.text) ?? 0.0,
      desc: _gameDescriptionController.text,
      genre: genreList,
      devName: DeveloperModelPostAdmin(
        name: _developerNameController.text,
        bio: _developerBioController.text,
      ),
      gameBanner: _bannerUrl!, 
      preview: _gamePreviewController.text,
      linkGames: _gameLinkController.text,
      gameLogo: _logoUrl!,
    );

    bool success = await _dataServices.insertGameAdmin(game);
    if (success) {
      debugPrint("Game berhasil ditambahkan!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Game berhasil dipublish!")),
      );
      _clearFormGames();
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      debugPrint("Gagal menambahkan game.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambahkan game.")),
      );
    }
  }
}

@override
void dispose() {
  _gameNameController.dispose();
  _developerNameController.dispose();
  _genreController.dispose();
  _gamePreviewController.dispose();
  _gameLinkController.dispose();
  _gameDescriptionController.dispose();
  _developerBioController.dispose();
  _ratingController.dispose();
  super.dispose();
}

  void _clearFormGames(){
    _gameNameController.clear();
    _ratingController.clear();
    _developerNameController.clear();
    _genreController.clear();
    _gamePreviewController.clear();
    _gameLinkController.clear();
    _gameDescriptionController.clear();
    _developerBioController.clear();
    setState(() {
      _gameLogo = null;
      _gameBanner = null;

    });
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
                  _buildTextField(_ratingController, 'Rating'),
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
                              if (_logoUrl != null)
                              Text(
                                'Uploaded URL: $_logoUrl',
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 6, 10, 6)),
                                onPressed: () => _pickImage(true),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImagePicker('Game Banner', _gameBanner,
                            () => _pickImage(false)),
                        if (_bannerUrl != null)
                          Text("Uploaded: $_bannerUrl",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _submitGame();
                      if (_formKey.currentState!.validate()) {
                        print('Berhasil submit teu');
                      }
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
