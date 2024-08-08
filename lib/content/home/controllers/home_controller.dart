import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fiscal_validator/global/models/xml_model.dart';
import 'package:fiscal_validator/util/convertes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class HomeController extends GetxController {
  //LISTAS
  final List<XMLModel> _allXmlList = <XMLModel>[];
  Rx<List<XMLModel>> currentXmlList = Rx<List<XMLModel>>([]);
  Rx<List<int>> missingNumbers = Rx<List<int>>([]);

  //INPUT CONTROLLERS
  Rx<TextEditingController> searchController = Rx<TextEditingController>(TextEditingController());
  Rx<TextEditingController> dateController = Rx<TextEditingController>(TextEditingController());

  //DATES
  Rx<DateTimeRange> _dateRangeFilter = Rx<DateTimeRange>(DateTimeRange(start: DateTime(1900), end: DateTime(2400)));

  //FILTERS
  RxBool mostrarAutorizadas = RxBool(true);
  RxBool mostrarCanceladas = RxBool(true);
  RxBool mostrarInutilizadas = RxBool(true);
  RxBool mostrarIncorretas = RxBool(true);
  RxBool mostrarModelo55 = RxBool(true);
  RxBool mostrarModelo65 = RxBool(true);

  //SCREEN STATES
  RxBool isLoading = RxBool(false);

  //RESET
  void reset() {
    _allXmlList.clear();
    currentXmlList.value.clear();
    searchController.value.clear();
    dateController.value.clear();
    _dateRangeFilter.value = DateTimeRange(start: DateTime(1900), end: DateTime(2400));
    mostrarAutorizadas.value = true;
    mostrarCanceladas.value = true;
    mostrarInutilizadas.value = true;
    mostrarIncorretas.value = true;
    mostrarModelo55.value = true;
    mostrarModelo65.value = true;
    isLoading.value = false;
  }

  Future<void> _getAllXMLs() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml'],
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      _allXmlList.clear();
      currentXmlList.value.clear();

      await Future.forEach(
        result.files,
        (PlatformFile file) async {
          if (file.extension == 'xml') {
            if (file.path != null) {
              String fileContent = await File(file.path!).readAsString();
              final doc = XmlDocument.parse(fileContent);

              XMLModel xml = XMLModel.fromXml(doc);
              _allXmlList.add(xml);
              currentXmlList.value = List.from(_allXmlList);
            }
          }
        },
      );
    } catch (e) {
      print("Error selecting files: $e");
      return;
    }
  }

  Future<void> _getMissingXmls() async {
    try {
      missingNumbers.value.clear();
      List<XMLModel> xmls = List.from(currentXmlList.value);

      Set<int> numerosNFSet = <int>{};

      await Future.forEach(
        xmls,
        (xml) {
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
        },
      );

      List<int> numerosNF = numerosNFSet.toList();
      numerosNF.sort();

      int firstNFNumero = numerosNF.first;
      int lastNFNumero = numerosNF.last;

      for (int numero = firstNFNumero; numero <= lastNFNumero; numero++) {
        if (!numerosNFSet.contains(numero)) {
          missingNumbers.value.add(numero);
        }
      }
    } catch (e) {
      print('ERRO AO PEGAR NUMERACAO PERDIDA $e');
    }
  }

  void handleFilterAutorizada(bool? value) {
    mostrarAutorizadas.value = !mostrarAutorizadas.value;
    handleFilters();
  }

  void handleFilterCancelada(bool? value) {
    mostrarCanceladas.value = !mostrarCanceladas.value;
    handleFilters();
  }

  void handleFilterInutilizada(bool? value) {
    mostrarInutilizadas.value = !mostrarInutilizadas.value;
    handleFilters();
  }

  void handleFilterIncorreta(bool? value) {
    mostrarIncorretas.value = !mostrarIncorretas.value;
    handleFilters();
  }

  void handleFilterModelo55(bool? value) {
    mostrarModelo55.value = !mostrarModelo55.value;
    handleFilters();
  }

  void handleFilterModelo65(bool? value) {
    mostrarModelo65.value = !mostrarModelo65.value;
    handleFilters();
  }

  Future handleDateRangePicker(BuildContext context) async {
    DateTimeRange? date = await showDateRangePicker(firstDate: DateTime(1900), lastDate: DateTime(2400), context: context);

    if (date != null) {
      dateController.value.text = '${dateToString(date.start)} Até ${dateToString(date.end)}';
      _dateRangeFilter.value = date;
      handleFilters();
    }
  }

  handleDateOnChanged(String? value) {
    if (value != null) {
      if (value.length == 25) {
        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
        DateTime startDate = dateFormat.parse(value.substring(0, 10));
        DateTime endDate = dateFormat.parse(value.substring(15, 25));

        _dateRangeFilter.value = DateTimeRange(start: startDate, end: endDate);
        handleFilters();
      }
      if (value.isEmpty) {
        _dateRangeFilter.value = DateTimeRange(
          start: DateTime(1900),
          end: DateTime(2400),
        );
        handleFilters();
      }
    }
  }

  _applyDateFilter() {
    currentXmlList.value.retainWhere((xml) {
      if (xml.dataEmissao == null) return false;
      return xml.dataEmissao!.isAfter(_dateRangeFilter.value.start.subtract(Duration(days: 1))) && xml.dataEmissao!.isBefore(_dateRangeFilter.value.end.add(Duration(days: 1)));
    });
  }

  handleSearchOnChanged(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        handleFilters();
      }
    }
  }

  void _applySearchFilter() {
    final query = searchController.value.text.toLowerCase();
    if (query.isNotEmpty) {
      currentXmlList.value.retainWhere((xml) {
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

  void handleFilters() {
    currentXmlList.value.clear();
    currentXmlList.value = List.from(_allXmlList);

    if (!mostrarAutorizadas.value) {
      currentXmlList.value.removeWhere((xml) => xml.autorizada == true);
    }
    if (!mostrarCanceladas.value) {
      currentXmlList.value.removeWhere((xml) => xml.cancelada == true);
    }
    if (!mostrarInutilizadas.value) {
      currentXmlList.value.removeWhere((xml) => xml.inutilizada == true);
    }
    if (!mostrarIncorretas.value) {
      currentXmlList.value.removeWhere((xml) => xml.incorreta == true);
    }
    if (!mostrarModelo55.value) {
      currentXmlList.value.removeWhere((xml) => xml.modelo == "55");
    }
    if (!mostrarModelo65.value) {
      currentXmlList.value.removeWhere((xml) => xml.modelo == "65");
    }

    _applySearchFilter();
    _applyDateFilter();
    _getMissingXmls();
  }

  double calculateTotal(List<XMLModel> xmls) {
    double total = 0;

    for (var xml in xmls) {
      total += xml.valor;
    }

    return total;
  }

  collectArchives() async {
    reset();
    isLoading.value = true;
    await _getAllXMLs();
    await _getMissingXmls();
    isLoading.value = false;
  }

  void copyText(text) {
    Get.closeAllSnackbars();
    Clipboard.setData(ClipboardData(text: text ?? ''));
    Get.snackbar('Texto copiado com sucesso!', text);
  }
}
