import 'package:bloc_demo/model/covid_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _url = 'https://api.covid19api.com/summary';

  Future<CovidModel> fetchCovidList() async {
    try {
      Response response = await _dio.get(_url);

      return CovidModel.fromJson(response.data);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('Exception occured error ::$error : stacktrace :: $stackTrace');
      }
      return CovidModel.withError('Data not found / Connection issue');
    }
  }
}
