library crawler;

import 'dart:async';
import 'package:html/dom.dart';
export 'package:html/dom.dart';
import 'package:html/parser.dart' as HtmlParser;
import 'package:http/http.dart' as Http;

abstract class PageWorker {
    parse(Document document);
}

class Crawler {
  static Future crawl(String url, PageWorker worker, {Map postData, String referer, Map<String,String> cookies}) async {
    String content;
    Map headers = {};
    headers["Host"] = Uri.parse(url).host;
    headers["Cache-Control"] = "max-age=0";
    headers["Upgrade-Insecure-Requests"] = "1";
    headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36";
    headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
    if (referer != null) headers["Referer"] = referer;
    headers["Accept-Encoding"] = "gzip, deflate, sdch, br";
    headers["Accept-Language"] = "nl-NL,nl;q=0.8,en-US;q=0.6,en;q=0.4,de-DE;q=0.2";
    if (cookies != null) {
      String cookiesstr = "";
      for (String key in cookies.keys) {
        cookiesstr += "$key=\"${cookies[key]}\";";
      }
      headers["Cookie"] = cookiesstr;
    }
    headers["DNT"] = "1";

    if (postData == null) {
      content = await Http.read(url,headers: headers);
    } else {
      content = (await Http.post(url,body: postData,headers: headers)).body;
    }
    Document document = HtmlParser.parse(content);
    worker.parse(document);
  }
}
