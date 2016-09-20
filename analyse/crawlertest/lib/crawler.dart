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
  static Future crawl(String url, PageWorker worker, {Map postData}) async {
    String content;
    if (postData == null) {
      content = await Http.read(url);
    } else {
      content = (await Http.post(url,body: postData)).body;
    }

    Document document = HtmlParser.parse(content);
    worker.parse(document);
  }
}
