import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStoragehelper {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> upLoadImageToSupaStore(File filePath, String folder) async {
    
    try {
      if(filePath.path != ""){
      final filename =
          DateTime.now().millisecondsSinceEpoch.toString();
      final path = "$folder/$filename";

      await _client.storage
          .from('snaploop-user-images')
          .upload(path, filePath);

      final imageUrl =  _client.storage
          .from('snaploop-user-images')
          .getPublicUrl(path);
      return imageUrl;
      }else{
        return null;
      }
    } catch (e) {
      log("Error in supabase storage :-> ${e.toString()}");
      // throw Exception(e);
      return null;
    }
  }
}
