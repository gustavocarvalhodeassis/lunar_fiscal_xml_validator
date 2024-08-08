import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fiscal_validator/util/convertes.dart';
import 'package:flutter/material.dart';
import 'package:fiscal_validator/models/xml_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class HomeProvider extends ChangeNotifier {
  final List<XMLModel> _allXmlList = [];
  List<XMLModel> _nfXmlList = [];
  List<XMLModel> get nfXmlList => _nfXmlList;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  final TextEditingController _dateController = TextEditingController();
  TextEditingController get dateController => _dateController;

  DateTimeRange _dateRangeFilter = DateTimeRange(start: DateTime(1900), end: DateTime(2400));
  DateTimeRange get dateRangeFilter => _dateRangeFilter;

  final List<int> _missingNumber = [];
  List<int> get missingNumber => _missingNumber;

  final List<FileSystemEntity> _incorrectNumber = [];
  List<FileSystemEntity> get incorrectNumber => _incorrectNumber;

  bool _isFilterAutorizadas = true;
  bool get isFilterAutorizadas => _isFilterAutorizadas;

  bool _isFilterCanceladas = true;
  bool get isFilterCanceladas => _isFilterCanceladas;

  bool _isFilterInutilizadas = true;
  bool get isFilterInutilizadas => _isFilterInutilizadas;

  bool _isFilterIncorretas = true;
  bool get isFilterIncorretas => _isFilterIncorretas;

  bool _isFilterModelo55 = true;
  bool get isFilterModelo55 => _isFilterModelo55;

  bool _isFilterModelo65 = true;
  bool get isFilterModelo65 => _isFilterModelo65;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void handleFilters() {
    _nfXmlList.clear();
    _nfXmlList = List.from(_allXmlList);

    if (!_isFilterAutorizadas) {
      _nfXmlList.removeWhere((xml) => xml.autorizada == true);
    }
    if (!_isFilterCanceladas) {
      _nfXmlList.removeWhere((xml) => xml.cancelada == true);
    }
    if (!_isFilterInutilizadas) {
      _nfXmlList.removeWhere((xml) => xml.inutilizada == true);
    }
    if (!_isFilterIncorretas) {
      _nfXmlList.removeWhere((xml) => xml.incorreta == true);
    }
    if (!_isFilterModelo55) {
      _nfXmlList.removeWhere((xml) => xml.modelo == "55");
    }
    if (!_isFilterModelo65) {
      _nfXmlList.removeWhere((xml) => xml.modelo == "65");
    }

    _applySearchFilter();
    _applyDateFilter();
    _getMissingXmls();
    notifyListeners();
  }

  void handleFilterAutorizada(bool? value) {
    _isFilterAutorizadas = !_isFilterAutorizadas;
    handleFilters();
  }

  void handleFilterCancelada(bool? value) {
    _isFilterCanceladas = !_isFilterCanceladas;
    handleFilters();
  }

  void handleFilterInutilizada(bool? value) {
    _isFilterInutilizadas = !_isFilterInutilizadas;
    handleFilters();
  }

  void handleFilterIncorreta(bool? value) {
    _isFilterIncorretas = !_isFilterIncorretas;
    handleFilters();
  }

  void handleFilterModelo55(bool? value) {
    _isFilterModelo55 = !_isFilterModelo55;
    handleFilters();
  }

  void handleFilterModelo65(bool? value) {
    _isFilterModelo65 = !_isFilterModelo65;
    handleFilters();
  }

  void _applySearchFilter() {
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      _nfXmlList.retainWhere((xml) {
        bool isQueryInChaveOrNumero = xml.chave?.toLowerCase() == query || xml.numero.toLowerCase() == query;

        bool isQueryInIntervaloInutilizado = false;
        if (xml.numeroInutIni != null && xml.numeroInutFin != null) {
          int queryInt;
          try {
            queryInt = int.parse(query);
            int numeroInutIni = int.parse(xml.numeroInutIni!.replaceAll(RegExp(r'\D'), ''));
            int numeroInutFin = int.parse(xml.numeroInutFin!.replaceAll(RegExp(r'\D'), ''));
            isQueryInIntervaloInutilizado = queryInt >= numeroInutIni && queryInt <= numeroInutFin;
          } catch (e) {
            isQueryInIntervaloInutilizado = false;
          }
        }

        return isQueryInChaveOrNumero || isQueryInIntervaloInutilizado;
      });
    }
  }

  _applyDateFilter() {
    _nfXmlList.retainWhere((xml) {
      if (xml.dataEmissao == null) return false;
      return xml.dataEmissao!.isAfter(_dateRangeFilter.start.subtract(Duration(days: 1))) && xml.dataEmissao!.isBefore(_dateRangeFilter.end.add(Duration(days: 1)));
    });
  }

  Future setDateRange(BuildContext context) async {
    DateTimeRange? date = await showDateRangePicker(firstDate: DateTime(1900), lastDate: DateTime(2400), context: context);

    if (date != null) {
      _dateController.text = '${dateToString(date.start)} Até ${dateToString(date.end)}';
      _dateRangeFilter = date;
      handleFilters();
    }
  }

  handleDateOnChanged(String? value) {
    if (value != null) {
      if (value.length == 25) {
        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
        DateTime startDate = dateFormat.parse(value.substring(0, 10));
        DateTime endDate = dateFormat.parse(value.substring(15, 25));

        _dateRangeFilter = DateTimeRange(start: startDate, end: endDate);
        handleFilters();
      }
      if (value.isEmpty) {
        _dateRangeFilter = DateTimeRange(
          start: DateTime(1900),
          end: DateTime(2400),
        );
        handleFilters();
      }
    }
  }

  void _start(BuildContext context) async {
    reset();
    await _getAllXMLs();
    _getMissingXmls();
  }

  Future<void> _getAllXMLs() async {
    _isLoading = true;
    notifyListeners();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml'],
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      _allXmlList.clear();
      _nfXmlList.clear();

      await Future.forEach(
        result.files,
        (PlatformFile file) async {
          if (file.extension == 'xml') {
            if (file.path != null) {
              String fileContent = await File(file.path!).readAsString();
              final doc = XmlDocument.parse(fileContent);

              XMLModel xml = XMLModel.fromXml(doc);
              _allXmlList.add(xml);
              _nfXmlList = List.from(_allXmlList);
            }
          }
        },
      );
    } catch (e) {
      print("Error selecting files: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double calculateTotal(List<XMLModel> xmls) {
    double total = 0;

    for (var xml in xmls) {
      total += xml.valor;
    }

    return total;
  }

  void _getMissingXmls() {
    try {
      _missingNumber.clear();
      List<XMLModel> xmls = List.from(_nfXmlList);

      Set<int> numerosNFSet = <int>{};

      for (var xml in xmls) {
        if (xml.inutilizada) {
          int numeroInutIni = int.parse(xml.numeroInutIni!.replaceAll(RegExp(r'\D'), ''));
          int numeroInutFin = int.parse(xml.numeroInutFin!.replaceAll(RegExp(r'\D'), ''));

          for (int i = numeroInutIni; i <= numeroInutFin; i++) {
            numerosNFSet.add(i);
          }
        }

        int? numero = int.tryParse(xml.numero.replaceAll(RegExp(r'\D'), ''));
        if (numero != null) {
          numerosNFSet.add(numero);
        }
      }

      List<int> numerosNF = numerosNFSet.toList();
      numerosNF.sort();

      int firstNFNumero = numerosNF.first;
      int lastNFNumero = numerosNF.last;

      for (int numero = firstNFNumero; numero <= lastNFNumero; numero++) {
        if (!numerosNFSet.contains(numero)) {
          _missingNumber.add(numero);
        }
      }

      notifyListeners();
    } catch (e) {
      print('ERRO AO PEGAR NUMERACAO PERDIDA $e');
    }
  }

  void act(BuildContext context) {
    _start(context);
  }

  void reset() {
    _nfXmlList.clear();
    _allXmlList.clear();
    _missingNumber.clear();
    notifyListeners();
  }

  void copyText(BuildContext context, {String? text}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    Clipboard.setData(ClipboardData(text: text ?? ''));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Texto copiado com sucesso!')));
  }
}
