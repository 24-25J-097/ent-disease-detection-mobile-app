import 'dart:convert';
import 'dart:io';
import 'package:ent_insight_app/configs/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../models/foreign_body_prediction.dart';

class ForeignBodyService {
  static Future<bool> validateImage(File imageFile) async {
    try {
      String? mimeType = lookupMimeType(imageFile.path);
      mimeType = mimeType ?? 'image/jpeg';

      var validationUri = Uri.parse('${GlobalData.baseUrl3}/api/foreign/run-inference/');
      var validationRequest = http.MultipartRequest('POST', validationUri);
      validationRequest.headers.addAll({
        "Content-Type": "multipart/form-data",
      });

      validationRequest.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ));

      var validationResponse = await validationRequest.send();

      if (validationResponse.statusCode == 200) {
        final validationData =
            json.decode(await validationResponse.stream.bytesToString());
        final int? imageClass =
            validationData['images']?[0]?['results']?[0]?['class'];

        return imageClass == 1;
      }
      return false;
    } catch (error) {
      print("Error validating image: $error");
      return false;
    }
  }

  static Future<List<ForeignBodyPrediction>> analyzeImage(File imageFile) async {
    try {
      String? mimeType = lookupMimeType(imageFile.path);
      mimeType = mimeType ?? 'image/jpeg';

      var analysisUri = Uri.parse('${GlobalData.baseUrl3}/api/foreign/detect');
      var analysisRequest = http.MultipartRequest('POST', analysisUri);
      analysisRequest.headers.addAll({
        "Content-Type": "multipart/form-data",
      });

      analysisRequest.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ));

      var analysisResponse = await analysisRequest.send();

      if (analysisResponse.statusCode == 200) {
        final responseData =
            json.decode(await analysisResponse.stream.bytesToString());
        
        List<dynamic> rawPredictions = responseData['predictions'] ?? [];
        return rawPredictions
            .map((prediction) => ForeignBodyPrediction.fromJson(prediction))
            .toList();
      }
      return [];
    } catch (error) {
      print("Error analyzing image: $error");
      return [];
    }
  }
}