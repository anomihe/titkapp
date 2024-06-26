import 'package:dio/dio.dart';
//import 'package:extractor/extractor.dart';
import 'package:direct_link/direct_link.dart';
import 'package:path/path.dart' as path;

class DioServices {
  final Dio dio = Dio();
  var directLink = DirectLink();

  Future<void> downloadVideo(
      String url, String savedDir, String fileName) async {
    String filePath = path.join(savedDir, fileName);
    try {
      await dio.download(url, filePath, onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
      });
      print('downloaded');
    } catch (e) {
      print(e);
    }
  }

//   void getData(String url) async {
// //  var results =  Extractor.getDirectLink(link: 'https://www.youtube.com/watch?v=Ne7y9_AbBsY');
//     //VideoData? results =await Extractor.getDirectLink(link: 'https://www.youtube.com/watch?v=Ne7y9_AbBsY', timeout: 10);
//     print('this is url $url');
//     var results = await directLink.check(url, timeout: Duration(seconds: 10));
//    var links = results?.links
//           ?.map((link) => {
//                 'quality': link.quality,
//                 'type': link.type,
//                 'link': link.link,
//               })
//           .toList();
//     print(' this is my result $results ${links}');
//   }
}
