

import 'package:cncours_quiz/app/core/helpers/storage_helper.dart';

class Token {
  static const TOKEN_KEY='token';

  final String value;

  Token({required this.value});

  // factory Token.initial()=>Token(value: '');

  static String get()=>Token(value:StorageHelper.get(TOKEN_KEY)).value;

  static String set(String value){
    StorageHelper.set(TOKEN_KEY, value);
    return Token(value:StorageHelper.get(TOKEN_KEY)).value;
  }

  static void delete(){
    StorageHelper.delete(TOKEN_KEY);
  }
}
