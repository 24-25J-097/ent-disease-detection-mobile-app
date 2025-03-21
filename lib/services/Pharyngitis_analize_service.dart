import 'package:dio/dio.dart';
import 'package:ent_insight_app/configs/config.dart';
import 'package:ent_insight_app/models/models.dart';
import 'package:ent_insight_app/widgets/widgets.g.dart';
import 'package:flutter/cupertino.dart';

import '../objects/objects.dart';
import '../utils/custom_http.dart';

class PharyngitisAnalyzeService {
  static Future<Pharyngitis?> analyzeImage(FormData formData) async {
    debugPrint(":::::::::::::::::::::::::::::::::::::: PharyngitisAnalyzeService->analyzeXray(formData) ::::::::::::::::::::::::::::::::::::::");
    try {
      final response = await CustomHttp.getDio().post(
        '${GlobalData.publicUrl}diagnosis/pharyngitis',
        data: formData,
        options: Options(validateStatus: (_) => true),
      );

      debugPrint(":::::::::::::::::::::::::::::::::::::: Pharyngitis Analyze Service $response");
      if (response is! String && response.data != null && response.data is! String) {
        final ResponseObject responseObject = ResponseObject.fromJson(response.data);
        if (response.statusCode == 200 && responseObject.success! && responseObject.data != null) {
          return Pharyngitis.fromJson(responseObject.data as Map<String, dynamic>);
        }
        AppToastWidget(responseObject.message ?? "Something went wrong");
        return null;
      }
    } on DioError catch (e) {
      CustomHttp.showTimeoutDioErrors(e);
      debugPrint(":::::::::::::::::::::::::::::::::::::: PharyngitisAnalyzeService->analyzeXray(formData) => ${e.message} ");
      return null;
    } catch (e) {
      debugPrint(":::::::::::::::::::::::::::::::::::::: PharyngitisAnalyzeService->analyzeXray(formData) => $e ");
      AppToastWidget("Something wrong with sending the network request!");
    }
    return null;
  }

  static Future<String?> pharyngitisDiagnosisAccept(var diagnosisAcceptance) async {
    debugPrint(":::::::::::::::::::::::::::::::::::::: PharyngitisDiagnosisService->diagnosis(formData) ::::::::::::::::::::::::::::::::::::::");
    try {
      final response = await CustomHttp.getDio().post(
        // '${GlobalData.doctorUrl}diagnosis/pharyngitis/accept',
        '${GlobalData.publicUrl}diagnosis/pharyngitis/accept',
        data: diagnosisAcceptance,
        options: Options(validateStatus: (_) => true),
      );

      debugPrint(":::::::::::::::::::::::::::::::::::::: Pharyngitis Diagnosis Service $response");
      if (response is! String && response.data != null && response.data is! String) {
        final ResponseObject responseObject = ResponseObject.fromJson(response.data);
        if (response.statusCode == 200 && responseObject.success! && responseObject.data != null) {
          // return Pharyngitis.fromJson(responseObject.data as Map<String, dynamic>);
          return responseObject.message;
        }
        AppToastWidget(responseObject.message ?? "Something went wrong");
        return null;
      }
    } on DioError catch (e) {
      CustomHttp.showTimeoutDioErrors(e);
      debugPrint(":::::::::::::::::::::::::::::::::::::: PharyngitisDiagnosisService->diagnosis(formData) => ${e.message} ");
      return null;
    } catch (e) {
      debugPrint(":::::::::::::::::::::::::::::::::::::: PharyngitisDiagnosisService->diagnosis(formData) => $e ");
      AppToastWidget("Something wrong with sending the network request!");
    }
    return null;
  }
}
