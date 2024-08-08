import 'package:fiscal_validator/util/convertes.dart';
import 'package:xml/xml.dart';

class XMLModel {
  String status;
  String? chave;
  String numero;
  double valor;
  DateTime? dataEmissao;
  String modelo;
  String? numeroInutIni;
  String? numeroInutFin;
  bool cancelada;
  bool incorreta;
  bool inutilizada;
  bool autorizada;

  XMLModel({
    required this.status,
    required this.chave,
    required this.numero,
    required this.valor,
    required this.modelo,
    required this.autorizada,
    required this.cancelada,
    required this.incorreta,
    required this.inutilizada,
    required this.dataEmissao,
    this.numeroInutIni,
    this.numeroInutFin,
  });

  factory XMLModel.fromXml(XmlDocument doc) {
    try {
      bool canc = doc.findAllElements('cStat').isNotEmpty && doc.findAllElements('cStat').first.innerText == '135';
      bool inut = doc.findAllElements('cStat').isNotEmpty && doc.findAllElements('cStat').first.innerText == '102';
      bool auto = doc.findAllElements('cStat').isNotEmpty && doc.findAllElements('cStat').first.innerText == '100';
      bool inco = doc.findAllElements('cStat').isEmpty;
      String? chNFe = doc.findAllElements('chNFe').isNotEmpty ? doc.findAllElements('chNFe').first.innerText : null;
      String stat = auto
          ? 'AUTORIZADA'
          : canc
              ? 'CANCELADA'
              : inut
                  ? 'INUTILIZADA'
                  : 'NOTA INCORRETA';
      String nNF = doc.findAllElements('nNF').isNotEmpty
          ? doc.findAllElements('nNF').first.innerText
          : canc
              ? chNFe!.substring(25, 34).replaceFirst(RegExp(r'^0+'), '')
              : inut
                  ? ''
                  : '';
      double vNF = double.tryParse(doc.findAllElements('vNF').isNotEmpty ? doc.findAllElements('vNF').first.innerText : '0') ?? 0.0;
      String mod = doc.findAllElements('mod').isNotEmpty
          ? doc.findAllElements('mod').first.innerText
          : canc
              ? chNFe!.substring(20, 22)
              : '';
      DateTime? dhEmi = canc
          ? stringToDate(doc.findAllElements('dhRegEvento').first.innerText)
          : auto
              ? stringToDate(doc.findAllElements('dhEmi').first.innerText)
              : inut
                  ? stringToDate(doc.findAllElements('dhRecbto').first.innerText)
                  : inco
                      ? stringToDate(doc.findAllElements('dhEmi').first.innerText)
                      : null;

      String? nInIn = inut ? '${doc.findAllElements('nNFIni').first.innerText}' : null;
      String? nInFn = inut ? '${doc.findAllElements('nNFFin').first.innerText}' : null;

      return XMLModel(
        status: stat,
        chave: chNFe,
        numero: nNF,
        valor: vNF,
        modelo: mod,
        dataEmissao: dhEmi,
        cancelada: canc,
        inutilizada: inut,
        autorizada: auto,
        incorreta: inco,
        numeroInutIni: nInIn,
        numeroInutFin: nInFn,
      );
    } catch (e) {
      print('ERRO AO PASSAR XML PARA O MODEL $e');
      rethrow;
    }
  }
}
