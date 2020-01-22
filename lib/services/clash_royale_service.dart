import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:clash_royale_search_v1/config/environment.dart';

class ClashRoyaleService {

  static String authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTc2MywiaWRlbiI6IjQ5NTYwMzg4Njc0NTE5MDQzMiIsIm1kIjp7InVzZXJuYW1lIjoibHVjYXNjaGlvcXVldGkiLCJkaXNjcmltaW5hdG9yIjoiNTYwNiIsImtleVZlcnNpb24iOjN9LCJ0cyI6MTU3OTAwMzc0MzgxOX0.pATgWATRRqQm-fA1rlmMPwJO_hhy_Nf5Lg9OJvgtGq4";

  static Future<List<dynamic>> getClans(String search) async {
    http.Response response;

    response = await http.get(
        EnvironmentsConfig.clashRoyaleApiBaseUrl + "clan/search?name=$search",
        headers: {HttpHeaders.authorizationHeader: authToken}
    );
    return json.decode(response.body);
  }
}