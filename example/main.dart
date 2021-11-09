import 'package:bitwarden/bitwarden.dart';
import 'package:dio/dio.dart';

final api = Bitwarden().getCollectionsApi();

void main(List<String> args) async {
  final response = await api.publicCollectionsGet();
  print(response);
}
