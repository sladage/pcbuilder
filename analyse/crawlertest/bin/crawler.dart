import 'package:crawlertest/crawler.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

List _moederborden = [];

class Motherboard {
  String name;
  String formFactor;
  String socket;
  double price;
  List<String> keywords = [];
  Map toJson() => {
        "name": name,
        "formFactor": formFactor,
        "socket": socket,
        "price": price,
        "keywords": keywords
      };
}

//euro prijs naar double
double prijsje(String prijs) {
  List<int> temp = [];
  for (int codeUnit in prijs.codeUnits) {
    if (codeUnit >= 48 && codeUnit <= 57) {
      temp.add(codeUnit);
    } else if (codeUnit == 44) {
      temp.add(46);
    } else if (codeUnit == 45) {
      temp.add(48);
    }
  }
  return double.parse(new String.fromCharCodes(temp));
}

class Moederborden implements PageWorker {
  parse(Document document) {
    var rows = document.querySelectorAll("div.listRow");
    for (Element listRow in rows) {
      Motherboard bord = new Motherboard();
      bord.name = listRow.querySelector("span.name").text.trim();
      var fields = listRow.querySelectorAll("span.info");
      bord.formFactor = fields[0].text.trim();
      bord.keywords.addAll(fields[1].text.split(","));
      bord.socket = fields[2].text.trim();
      bord.price = prijsje(listRow.querySelector("span.price").text);
      bord.keywords
          .addAll(listRow.querySelector("span.additional").text.split(","));
      for (int i=0;i<bord.keywords.length;i++) {
        bord.keywords[i] = bord.keywords[i].trim();
      }
      _moederborden.add(bord);
    }

    // meerdere pagina's?
  }
}

main(List<String> args) async {
  Moederborden worker = new Moederborden();

  try {
    await Crawler.crawl(
        "https://www.alternate.nl/Hardware-Componenten-Moederborden-Intel/html/listings/11626?lk=9435&size=500&showFilter=true#listingResult",
        worker,referer: "https://www.alternate.nl/Moederborden/Intel",/*cookies:cookies*/);
    String json = new JsonEncoder.withIndent("  ").convert(_moederborden);
    print("We hebben ${_moederborden.length} moederborden gevonden.");
    File uit = new File("moederborden.json");
    uit.writeAsStringSync(json);
  } catch (e) {
    print(e);
  }
}
