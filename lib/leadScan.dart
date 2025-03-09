import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LeafScan extends StatefulWidget {
  final String modelName;

  const LeafScan({super.key, required this.modelName});

  @override
  State<LeafScan> createState() => _LeafScanState(modelName);
}

class _LeafScanState extends State<LeafScan> {
  String modelName;
  File? pickedImage;
  bool isButtonPressedCamera = false;
  bool isButtonPressedGallery = false;
  Color backgroundColor = const Color(0xffe9edf1);
  Color secondaryColor = const Color(0xffe1e6ec);
  Color accentColor = const Color(0xff2d5765);

  List? results;
  String confidence = "";
  String name = "";
  String cropName = "";
  String diseaseName = "";
  String diseaseUrl = "";
  bool resultVisibility = false;

  _LeafScanState(this.modelName);

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        pickedImage = imageTemporary;
        applyModelOnImage(pickedImage!);
        resultVisibility = true;
        isButtonPressedCamera = false;
        isButtonPressedGallery = false;
      });
    } on PlatformException {
      // Handle platform exception
    }
  }

  Future applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      results = res;
      if (results != null) {
        String str = results![0]["label"];
        name = str.substring(2);
        confidence =
            "${(results![0]["confidence"] * 100.0).toStringAsFixed(2)}%";
        splitModelResult();
      }
    });
  }

  void splitModelResult() {
    List temp = name.split(' ');
    cropName = temp[0];
    temp.removeAt(0);
    diseaseName = temp.join(' ');
  }

  String modelPathSelector() {
    switch (modelName.toLowerCase()) {
      case 'apple':
        return 'models/Apple';
      case 'corn':
        return 'models/Corn';
      case 'sugarcane':
        return 'models/Sugarcane';
      case 'potato':
        return 'models/Potato';
      case 'rice':
        return 'models/Rice';
      case 'tomato':
        return 'models/Tomato';
      default:
        return '';
    }
  }

  Future loadModel() async {
    String modelPath = modelPathSelector();
    await Tflite.loadModel(
      model: "$modelPath/model_unquant.tflite",
      labels: "$modelPath/labels.txt",
    );
  }

  Future closeModel() async {
    await Tflite.close();
  }

  void buttonPressedCamera() {
    setState(() {
      isButtonPressedCamera = !isButtonPressedCamera;
      getImage(ImageSource.camera);
    });
  }

  void buttonPressedGallery() {
    setState(() {
      isButtonPressedGallery = !isButtonPressedGallery;
      getImage(ImageSource.gallery);
    });
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    closeModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: pickedImage != null
                    ? Image.file(
                        pickedImage!,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      )
                    : LottieBuilder.asset(
                        'assets/39771-farm.json',
                        width: 300,
                        height: 300,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    elevation: 2,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                        onPressed: buttonPressedCamera,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt),
                            Text(
                              "Camera",
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'odibeeSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                        onPressed: buttonPressedGallery,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'odibeeSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !resultVisibility,
              child: Flexible(
                child: Column(
                  children: [
                    infoRow(
                      icon: Icons.camera_alt_rounded,
                      text:
                          "Select an image of the plant's leaf to view the results",
                    ),
                    infoRow(
                      icon: Icons.light_mode_rounded,
                      text: 'The image must be well lit and clear',
                    ),
                    infoRow(
                      icon: Icons.hide_image_rounded,
                      text:
                          "Images other than the specific plant's leaves may lead to inaccurate results",
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: resultVisibility,
              child: Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (diseaseName.toLowerCase() != "healthy" &&
                        diseaseName.toLowerCase() != "not_valid") {
                      diseaseUrl =
                          "https://www.google.com/search?q=$modelName+${name.replaceAll('_', '+')}";
                    } else {
                      diseaseUrl =
                          "https://www.google.com/search?q=$modelName+plant+care+tips";
                    }
                    Uri url = Uri.parse(diseaseUrl);
                    await launchUrl(url, mode: LaunchMode.inAppWebView);
                  },
                  child: resultCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.greenAccent.shade200),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent.shade200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget resultCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
              child: Text(
                name.replaceAll('_', " "),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                infoRow(
                  icon: Icons.info_rounded,
                  text: (diseaseName.toLowerCase() != "healthy" &&
                          diseaseName.toLowerCase() != "not_valid")
                      ? 'Tap on this card to read more about this disease'
                      : 'Tap on this card for $modelName plant care tips',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (diseaseName.toLowerCase() != "not_valid")
                      ? Text(
                          'Confidence : $confidence',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        )
                      : const Text(''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
