# awesome_mm_nrc

awesome_mm_nrc is a customizable Flutter package for managing Myanmar NRC (National Registration
Card) data, featuring a flexible handling for state, township, and nationality selection

## Usage

```dart
AwesomeMMNRC.builder
(
locale: NRCLocale.mm,
onNRCDataUpdated: (nrcData) {
print(
"NRC Data is ${nrcData.formatNRCData()}"); // NRC Data is ၇/ညလပ(နိုင်)
},
nrcFormBuilder: (context, stateList, townshipList, nationalityList,
onSelectState, onSelectTownship, onSelectNationality) =>
Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
YourCustomStateWidget(stateList,
onStateChange: (state) => onSelectState.call(state)),
YourCustomTownshipWidget(townshipList,
onTownshipChange: (township) => onSelectTownship.call(township)),
YourCustomNationalityWidget(nationalityList,
onNationalityChange: (nationality) =>
onSelectNationality.call(nationality
)
)
]
,
)
,
);
```