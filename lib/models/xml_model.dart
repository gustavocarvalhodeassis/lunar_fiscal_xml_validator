import 'package:xml/xml.dart';

class XMLModel {
  String chave;
  int numero;
  double valor;
  int modelo;

  XMLModel({
    required this.chave,
    required this.numero,
    required this.valor,
    required this.modelo,
  });

  factory XMLModel.fromXml(XmlDocument doc) {
    String chNFe = doc.findAllElements('chNFe').first.innerText;
    int nNF = int.tryParse(doc.findAllElements('nNF').first.innerText) ?? 0;
    double vNF =
        double.tryParse(doc.findAllElements('vNF').first.innerText) ?? 0.0;
    int mod = int.tryParse(doc.findAllElements('mod').first.innerText) ?? 0;

    return XMLModel(
      chave: chNFe,
      numero: nNF,
      valor: vNF,
      modelo: mod,
    );
  }
}
