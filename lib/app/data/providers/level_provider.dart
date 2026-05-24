
import 'package:cncours_quiz/app/core/client/my_client.dart';


class LevelProvider extends MyClient
{
  String resource='levels';
  bool auth=false;

  Future<dynamic> toggle({ required int id}) async {
    return  await checkResponse(()=>clientGet(auth:auth,apiRoute: "$resource/$id/toggle"));
  }
}
