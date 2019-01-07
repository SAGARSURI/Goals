import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class MLkitProvider {
  FirebaseVision _firebaseVision = FirebaseVision.instance;

  Future<String> getImage(var image) async {
    File _image = image;
    final FirebaseVisionImage _visionImage = FirebaseVisionImage.fromFile(
        _image);
    final TextRecognizer _textRecognizer = _firebaseVision.textRecognizer();
    final VisionText _visionText = await _textRecognizer.processImage(_visionImage);
    String _detectedText = _visionText.text;
    return _detectedText;
  }

}