import 'package:dio/dio.dart';
import 'package:ent_insight_app/configs/config.dart';
import 'package:ent_insight_app/models/models.dart';
import 'package:ent_insight_app/widgets/widgets.g.dart';
import 'package:flutter/cupertino.dart';

import '../objects/objects.dart';
import '../utils/custom_http.dart';

class CholesteatomaDiagnosisService {
  static Future<Cholesteatoma?> cholesteatomaDiagnosis(FormData formData) async {
    debugPrint(":::::::::::::::::::::::::::::::::::::: CholesteatomaDiagnosisService->diagnosis(formData) ::::::::::::::::::::::::::::::::::::::");
    try {
      final response = await CustomHttp.getDio().post(
        // '${GlobalData.doctorUrl}diagnosis/cholesteatoma',
        '${GlobalData.publicUrl}diagnosis/cholesteatoma',
        data: formData,
        options: Options(validateStatus: (_) => true),
      );

      debugPrint(":::::::::::::::::::::::::::::::::::::: Cholesteatoma Diagnosis Service $response");
      if (response is! String && response.data != null && response.data is! String) {
        final ResponseObject responseObject = ResponseObject.fromJson(response.data);
        if (response.statusCode == 200 && responseObject.success! && responseObject.data != null) {
          return Cholesteatoma.fromJson(responseObject.data as Map<String, dynamic>);
        }
        AppToastWidget(responseObject.message ?? "Something went wrong");
        return null;
      }
    } on DioError catch (e) {
      CustomHttp.showTimeoutDioErrors(e);
      debugPrint(":::::::::::::::::::::::::::::::::::::: CholesteatomaDiagnosisService->diagnosis(formData) => ${e.message} ");
      return null;
    } catch (e) {
      debugPrint(":::::::::::::::::::::::::::::::::::::: CholesteatomaDiagnosisService->diagnosis(formData) => $e ");
      AppToastWidget("Something wrong with sending the network request!");
    }
    return null;
  }

  static Future<String?> cholesteatomaDiagnosisAccept(var diagnosisAcceptance) async {
    debugPrint(":::::::::::::::::::::::::::::::::::::: CholesteatomaDiagnosisService->diagnosis(formData) ::::::::::::::::::::::::::::::::::::::");
    try {
      final response = await CustomHttp.getDio().post(
        // '${GlobalData.doctorUrl}diagnosis/cholesteatoma/accept',
        '${GlobalData.publicUrl}diagnosis/cholesteatoma/accept',
        data: diagnosisAcceptance,
        options: Options(validateStatus: (_) => true),
      );

      debugPrint(":::::::::::::::::::::::::::::::::::::: Cholesteatoma Diagnosis Service $response");
      if (response is! String && response.data != null && response.data is! String) {
        final ResponseObject responseObject = ResponseObject.fromJson(response.data);
        if (response.statusCode == 200 && responseObject.success! && responseObject.data != null) {
          // return Cholesteatoma.fromJson(responseObject.data as Map<String, dynamic>);
          return responseObject.message;
        }
        AppToastWidget(responseObject.message ?? "Something went wrong");
        return null;
      }
    } on DioError catch (e) {
      CustomHttp.showTimeoutDioErrors(e);
      debugPrint(":::::::::::::::::::::::::::::::::::::: CholesteatomaDiagnosisService->diagnosis(formData) => ${e.message} ");
      return null;
    } catch (e) {
      debugPrint(":::::::::::::::::::::::::::::::::::::: CholesteatomaDiagnosisService->diagnosis(formData) => $e ");
      AppToastWidget("Something wrong with sending the network request!");
    }
    return null;
  }
}
