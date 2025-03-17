import 'package:dio/dio.dart';
import 'package:ent_insight_app/configs/config.dart';
import 'package:ent_insight_app/models/models.dart';
import 'package:ent_insight_app/widgets/widgets.g.dart';
import 'package:flutter/cupertino.dart';

import '../objects/objects.dart';
import '../utils/custom_http.dart';

class SinusitisAnalyzeService {
  static Future<SinusitisResult?> analyzeXray(FormData formData) async {
    debugPrint(":::::::::::::::::::::::::::::::::::::: SinusitisAnalyzeService->analyzeXray(formData) ::::::::::::::::::::::::::::::::::::::");
    try {
      final response = await CustomHttp.getDio().post(
        '${GlobalData.baseUrl}/api/sinusitis/analyze',
        data: formData,
        options: Options(validateStatus: (_) => true),
      );

      debugPrint(":::::::::::::::::::::::::::::::::::::: Sinusitis Analyze Service $response");
      if (response is! String && response.data != null && response.data is! String) {
        final ResponseObject responseObject = ResponseObject.fromJson(response.data);
        if (response.statusCode == 200 && responseObject.success! && responseObject.data != null) {
          return SinusitisResult.fromJson(responseObject.data as Map<String, dynamic>);
        }
        AppToastWidget(responseObject.message ?? "Something went wrong");
        return null;
      }
    } on DioError catch (e) {
      CustomHttp.showTimeoutDioErrors(e);
      debugPrint(":::::::::::::::::::::::::::::::::::::: SinusitisAnalyzeService->analyzeXray(formData) => ${e.message} ");
      return null;
    } catch (e) {
      debugPrint(":::::::::::::::::::::::::::::::::::::: SinusitisAnalyzeService->analyzeXray(formData) => $e ");
      AppToastWidget("Something wrong with sending the network request!");
    }
    return null;
  }
}
