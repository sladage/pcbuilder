import 'package:crawlertest/crawler.dart';

class Test implements PageWorker {
  parse(Document document) {
    var pp = document.querySelectorAll("p");
    print("We have ${pp.length} P's");
  }
}

void main(List<String> args) {
  Test worker = new Test();
  try{
    Crawler.crawl("https://tweakers.net/", worker);
  } catch (e) {
    print(e);
  }
}
