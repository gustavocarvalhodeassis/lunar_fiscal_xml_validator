import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fiscal_validator/models/xml_model.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class HomeProvider extends ChangeNotifier {
  String _folderPath = '';
  String get folderPath => _folderPath;

  final List<XMLModel> _nfcXmlList = [];
  List<XMLModel> get nfcXmlList => _nfcXmlList;

  final List<XMLModel> _nfXmlList = [];
  List<XMLModel> get nfXmlList => _nfXmlList;

  double _totalNFCE = 0;
  double get totalNFCE => _totalNFCE;

  double _totalNFE = 0;
  double get totalNFE => _totalNFE;

  final List<int> _missingNumberNFC = [];
  List<int> get missingNumberNFC => _missingNumberNFC;

  final List<int> _missingNumberNF = [];
  List<int> get missingNumberNF => _missingNumberNF;

  final List<FileSystemEntity> _incorrectNumberNFC = [];
  List<FileSystemEntity> get incorrectNumberNFC => _incorrectNumberNFC;

  final List<FileSystemEntity> _incorrectNumberNF = [];
  List<FileSystemEntity> get incorrectNumberNF => _incorrectNumberNF;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _start(BuildContext context) async {
    reset();
    await _setFolder();
    if (_folderPath.isNotEmpty) {
      _getAllXMLs();
      _calculateTotal();
      _getMissingXmls();
    }
  }

  Future _setFolder() async {
    _isLoading = true;
    notifyListeners();
    final selectedFolder = await FilePicker.platform.getDirectoryPath();
    if (selectedFolder != null) {
      _folderPath = selectedFolder;
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
      return;
    }
  }

  void _getAllXMLs() {
    if (_folderPath.isEmpty) {
      return;
    }

    Directory folderNFC = Directory('$_folderPath\\XML\\NFC\\EMITIDAS');
    Directory folderNF = Directory('$_folderPath\\XML\\NF\\EMITIDAS');

    List<FileSystemEntity> nfcFiles = [];
    List<FileSystemEntity> nfFiles = [];

    if (folderNFC.existsSync()) {
      nfcFiles = folderNFC.listSync();
    }

    if (folderNF.existsSync()) {
      nfFiles = folderNF.listSync();
    }

    if (nfcFiles.isNotEmpty) {
      for (var file in nfcFiles) {
        if (file is File && file.path.toLowerCase().endsWith('.xml')) {
          String fileContent = File(file.path).readAsStringSync();
          final doc = XmlDocument.parse(fileContent);

          var infInut = doc.findAllElements('infInut');

          if (infInut.isEmpty) {
            XMLModel xml = XMLModel.fromXml(doc);
            if (xml.modelo == 65) {
              _nfcXmlList.add(xml);
            }
          }
        }
      }
    }

    if (nfFiles.isNotEmpty) {
      for (var file in nfFiles) {
        if (file is File && file.path.toLowerCase().endsWith('.xml')) {
          String fileContent = File(file.path).readAsStringSync();
          final doc = XmlDocument.parse(fileContent);

          var cStatElements = doc.findAllElements('cStat');

          if (cStatElements.isNotEmpty) {
            XMLModel xml = XMLModel.fromXml(doc);
            if (xml.modelo == 55) {
              _nfXmlList.add(xml);
            }
          }
        }
      }
    }

    notifyListeners();
  }

  void _calculateTotal() {
    _totalNFE = 0;
    _totalNFCE = 0;
    notifyListeners();

    for (var xml in _nfcXmlList) {
      _totalNFCE += xml.valor;
    }

    for (var xml in _nfXmlList) {
      _totalNFE += xml.valor;
    }

    notifyListeners();
  }

  void _getMissingXmls() {
    List<XMLModel> nfc = _nfcXmlList;
    nfc.sort((a, b) => a.numero.compareTo(b.numero));

    List<XMLModel> nf = nfXmlList;
    nf.sort((a, b) => a.numero.compareTo(b.numero));

    //NFC

    int firstNFCNumero = nfc.first.numero;
    int lastNFCNumero = nfc.last.numero;

    List<int> numerosNFC = [];

    for (var xml in _nfcXmlList) {
      numerosNFC.add(xml.numero);
    }

    Set<int> numerosNFCSet = Set<int>.from(numerosNFC);

    for (int numero = firstNFCNumero; numero <= lastNFCNumero; numero++) {
      if (!numerosNFCSet.contains(numero)) {
        _missingNumberNFC.add(numero);
      }
    }

    //NF

    int firstNFNumero = nf.first.numero;
    int lastNFNumero = nf.last.numero;

    List<int> numerosNF = [];

    for (var xml in _nfXmlList) {
      numerosNF.add(xml.numero);
    }

    Set<int> numerosNFSet = Set<int>.from(numerosNF);

    for (int numero = firstNFNumero; numero <= lastNFNumero; numero++) {
      if (!numerosNFSet.contains(numero)) {
        _missingNumberNF.add(numero);
      }
    }

    notifyListeners();
  }

  void act(BuildContext context) {
    _start(context);
  }

  void reset() {
    _folderPath = '';
    _totalNFCE = 0;
    _totalNFE = 0;
    _nfcXmlList.clear();
    _nfXmlList.clear();
    _missingNumberNFC.clear();
    _missingNumberNF.clear();
    notifyListeners();
  }

  void copyText(BuildContext context, {String? text}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    Clipboard.setData(ClipboardData(text: text ?? ''));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Texto copiado com sucesso!')));
  }
}
