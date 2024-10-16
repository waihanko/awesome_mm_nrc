// Main app widget
import 'package:awesome_mm_nrc/awesome_mm_nrc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('State, Township, and Nationality Selector'),
        ),
        body: StateTownshipSelector(),
      ),
    );
  }
}

class StateTownshipSelector extends StatefulWidget {
  const StateTownshipSelector({super.key});

  @override
  _StateTownshipSelectorState createState() => _StateTownshipSelectorState();
}

class _StateTownshipSelectorState extends State<StateTownshipSelector> {
  NRCLocale currentLocale = NRCLocale.mm; // Default locale
  NRCData selectedNRCData = NRCData();

  void toggleLocale() {
    setState(() {
      currentLocale = (currentLocale == NRCLocale.eng) ? NRCLocale.mm : NRCLocale.eng; // Toggle locale
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Switch to toggle between locales
        SwitchListTile(
          title: Text('Current Language: ${currentLocale.name}'),
          value: currentLocale == NRCLocale.mm,
          onChanged: (bool value) {
            toggleLocale();
          },
        ),
        const SizedBox(height: 20,),
        AwesomeMMNRC.builder(
          locale: currentLocale,
          onNRCDataUpdated: (nrcData) {
            setState(() {
              selectedNRCData = nrcData;
            });
            print("NRC Data is ${selectedNRCData.formatNRCData()}");
            // Update selected NRC info
          },
          nrcFormBuilder: (context,
                  stateList,
                  townshipList,
                  nationalityList,
                  onStateChange,
                  onTownshipChange,
                  onNationalityChange) =>
              Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dropdown for State Code
              DropdownButton<String>(
                hint: const Text('Select State'),
                value: selectedNRCData.selectedStateCode,
                onChanged: (String? newStateCode) {
                  if (newStateCode != null) {
                    onStateChange.call(newStateCode);
                  }
                },
                items: stateList.map<DropdownMenuItem<String>>((stateCode) {
                  return DropdownMenuItem<String>(
                    value: stateCode,
                    child: Text(stateCode),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Dropdown for Township Code
              DropdownButton<String>(
                hint: const Text('Select Township'),
                value: selectedNRCData.selectedTownshipCode,
                onChanged: (String? newTownshipCode) {
                  if (newTownshipCode != null) {
                    onTownshipChange.call(newTownshipCode);
                  }
                },
                items:
                    townshipList.map<DropdownMenuItem<String>>((townshipCode) {
                  return DropdownMenuItem<String>(
                    value: townshipCode,
                    child: Text(townshipCode),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Dropdown for Nationality
              DropdownButton<String>(
                hint: Text('Select Nationality'),
                value: selectedNRCData.selectedNationalityCode,
                onChanged: (String? newNationality) {
                  if (newNationality != null) {
                    onNationalityChange.call(newNationality);
                  }
                },
                items: nationalityList
                    .map<DropdownMenuItem<String>>((nationality) {
                  return DropdownMenuItem<String>(
                    value: nationality,
                    child: Text(nationality),
                  );
                }).toList(),
              ),

            ],
          ),
        ),
        const SizedBox(height: 40,),

        // Display selected codes
        Text('Selected State Code: ${selectedNRCData.selectedStateCode}'),
        Text('Selected Township Code: ${selectedNRCData.selectedTownshipCode}'),
        Text('Selected Nationality: ${selectedNRCData.selectedNationalityCode}'),
        const SizedBox(height: 8,),
        Text('Formatted Data: ${selectedNRCData.formatNRCData()}', style: TextStyle(color: Colors.red),),
      ],
    );
  }
}


class NRCExample extends StatelessWidget {
  const NRCExample({super.key});

  @override
  Widget build(BuildContext context) {
    return  AwesomeMMNRC.builder(
      locale: NRCLocale.mm,
      onNRCDataUpdated: (nrcData) {
        print("NRC Data is ${nrcData.formatNRCData()}"); // NRC Data is ၇/ညလပ(နိုင်)
      },
      nrcFormBuilder: (context,
          stateList,
          townshipList,
          nationalityList,
          onSelectState,
          onSelectTownship,
          onSelectNationality) =>
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              YourCustomStateWidget(stateList, onStateChange:(state)=> onSelectState.call(state)),

              YourCustomTownshipWidget(townshipList, onTownshipChange:(township)=> onSelectTownship.call(township)),

              YourCustomNationalityWidget(nationalityList, onNationalityChange: (nationality) => onSelectNationality.call(nationality))
            ],
          ),
    );
  }

}

class YourCustomStateWidget extends StatelessWidget {
  const YourCustomStateWidget(List<String> stateList, {super.key, required Function(dynamic state) onStateChange});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class YourCustomTownshipWidget extends StatelessWidget {
  const YourCustomTownshipWidget(List<String> stateList, {super.key, required Function(dynamic state) onTownshipChange});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class YourCustomNationalityWidget extends StatelessWidget {
  const YourCustomNationalityWidget(List<String> stateList, {super.key, required Function(dynamic state) onNationalityChange});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
