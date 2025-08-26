import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'API_KEY')
  static String apiKey = _Env.apiKey;

  @EnviedField(varName: 'ACCESS_TOKEN')
  static String accessToken = _Env.accessToken;
}
