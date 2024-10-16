import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum NRCLocale{
  mm,
  eng
}

class NRCData {
  final String? selectedStateCode;
  final String? selectedTownshipCode;
  final String? selectedNationalityCode;

  NRCData({
    this.selectedStateCode,
    this.selectedTownshipCode,
    this.selectedNationalityCode,
  });

  NRCData copyWith({
    String? selectedStateCode,
    String? selectedTownshipCode,
    String? selectedNationalityCode,
  }) {
    return NRCData(
      selectedStateCode: selectedStateCode ?? this.selectedStateCode,
      selectedTownshipCode: selectedTownshipCode ?? this.selectedTownshipCode,
      selectedNationalityCode: selectedNationalityCode ?? this.selectedNationalityCode,
    );


  }

  @override
  String toString() {
    return 'NRCInfo{selectedStateCode: $selectedStateCode, selectedTownshipCode: $selectedTownshipCode, selectedNationalityCode: $selectedNationalityCode}';
  }

  String formatNRCData() {
    return [
      if (selectedStateCode != null) '$selectedStateCode/',
      selectedTownshipCode ?? '',
      selectedNationalityCode ?? '',
    ].join();
  }

}

// Model class to parse township data
class TownshipData {
  final Map<String, Map<String, List<String>>> stateTownshipData;

  TownshipData({required this.stateTownshipData});

  factory TownshipData.fromJson(Map<String, dynamic> json, String locale) {
    Map<String, Map<String, List<String>>> stateTownshipData = {};

    for (var state in json[locale]) {
      String stateCode = state['code'];
      List<String> townshipCodes = List<String>.from(state['township_codes']);
      stateTownshipData[stateCode] = {
        'township_codes': townshipCodes,
      };
    }

    return TownshipData(stateTownshipData: stateTownshipData);
  }
}

// Model class to parse state codes
class StateCodeData {
  final List<String> stateCodes;

  StateCodeData({required this.stateCodes});

  factory StateCodeData.fromJson(Map<String, dynamic> json, String locale) {
    return StateCodeData(
      stateCodes: List<String>.from(json[locale]),
    );
  }
}

// Model class to Nationality codes
class NationalityData {
  final List<String> nationalities;

  NationalityData({required this.nationalities});

  factory NationalityData.fromJson(Map<String, dynamic> json, String locale) {
    return NationalityData(
      nationalities: List<String>.from(json[locale]),
    );
  }
}

// Function to load the JSON data from assets for township codes
Future<TownshipData> loadTownshipData(NRCLocale locale) async {
  final String response = await rootBundle
      .loadString('packages/awesome_mm_nrc/assets/township_code.json');
  final Map<String, dynamic> data = jsonDecode(response);
  return TownshipData.fromJson(data, locale.name);
}

// Function to load the JSON data from assets for state codes
Future<StateCodeData> loadStateCodeData(NRCLocale locale) async {
  final String response = await rootBundle
      .loadString('packages/awesome_mm_nrc/assets/state_code.json');
  final Map<String, dynamic> data = jsonDecode(response);
  return StateCodeData.fromJson(data, locale.name);
}

// Function to load the JSON data from assets for nationality
Future<NationalityData> loadNationalityData(NRCLocale locale) async {
  final String response = await rootBundle
      .loadString('packages/awesome_mm_nrc/assets/nationality.json');
  final Map<String, dynamic> data = jsonDecode(response);
  return NationalityData.fromJson(data, locale.name);
}

class AwesomeMMNRC extends StatefulWidget {
  final NRCLocale locale;
  final Function(NRCData) nrcInfo; // Accept nrcInfo
  final Widget Function(
    BuildContext,
    List<String>, // State List
    List<String>, // Township List
    List<String>, // Nationality List
    Function(String), // onSelectState
    Function(String), // onSelectTownship
    Function(String), // onSelectNationality
  ) widgetBuilder;

  const AwesomeMMNRC({
    Key? key,
    required this.locale,
    required this.nrcInfo,
    required this.widgetBuilder,
  }) : super(key: key);

  static Widget builder({
    NRCLocale? locale = NRCLocale.eng,
    required Function(NRCData) onNRCDataUpdated,
    required Widget Function(
      BuildContext,
      List<String>,
      List<String>,
      List<String>, // Nationality List// Selected Nationality
      Function(String), // onSelectState
      Function(String), // onSelectTownship
      Function(String), // onSelectNationality
    ) nrcFormBuilder,
  }) {
    return AwesomeMMNRC(
      locale: locale!,
      nrcInfo: onNRCDataUpdated,
      widgetBuilder: nrcFormBuilder,
    );
  }

  @override
  _AwesomeMMNRCState createState() => _AwesomeMMNRCState();
}

class _AwesomeMMNRCState extends State<AwesomeMMNRC> {
  NRCData nrcInfo = NRCData(); // Default NRCInfo
  List<String> stateList = [];
  List<String> townshipList = [];
  List<String> nationalityList = [];
  Map<String, Map<String, List<String>>> stateTownshipData = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    TownshipData townshipData = await loadTownshipData(widget.locale);
    StateCodeData stateCodeData = await loadStateCodeData(widget.locale);
    NationalityData nationalityData = await loadNationalityData(widget.locale);

    setState(() {
      stateTownshipData = townshipData.stateTownshipData;
      stateList = stateCodeData.stateCodes; // Initialize state list
      townshipList = []; // Reset township list
      nationalityList =
          nationalityData.nationalities; // Initialize nationality list
    });
  }

  void updateStateCode(String stateCode) {
    setState(() {
      nrcInfo = NRCData();


      // Update the filtered township list based on the selected state code
      townshipList =
          stateTownshipData[stateCode]?['township_codes'] ?? [];
      nrcInfo = nrcInfo.copyWith(selectedStateCode: stateCode);
      widget.nrcInfo.call(nrcInfo);
    });
  }

  void updateTownshipCode(String townshipCode) {
    setState(() {
      nrcInfo = nrcInfo.copyWith(selectedTownshipCode: townshipCode);
      widget.nrcInfo.call(nrcInfo);

    });
  }

  void updateNationality(String nationality) {
    setState(() {
      nrcInfo = nrcInfo.copyWith(selectedNationalityCode: nationality);
      widget.nrcInfo.call(nrcInfo);
    });
  }

  @override
  void didUpdateWidget(AwesomeMMNRC oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reload data when the locale changes
    if (oldWidget.locale != widget.locale) {
      widget.nrcInfo.call(NRCData());
      loadData().then((_) {
        // Reset selected values after loading new data
        if (stateList.isNotEmpty) {
          // Update the township list based on the newly loaded state list
          if (nrcInfo.selectedStateCode != null) {
            townshipList = stateTownshipData[nrcInfo.selectedStateCode]?['township_codes'] ?? [];
          }
        } else {
          townshipList = []; // Reset if state list is empty
        }

        // Update selectedTownship if it is not in the new township list
        if (!townshipList.contains(nrcInfo.selectedTownshipCode)) {
          nrcInfo = nrcInfo.copyWith(selectedTownshipCode: null);
        }

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.widgetBuilder(
      context,
      stateList,
      townshipList,
      nationalityList,
      updateStateCode,
      // Pass the state update callback
      updateTownshipCode,
      // Pass the township update callback
      updateNationality,
      // Pass the nationality update callback
    );
  }
}
