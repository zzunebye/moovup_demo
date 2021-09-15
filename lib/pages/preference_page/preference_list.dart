import 'package:flutter/material.dart';
import 'package:moovup_demo/widgets/preference_pill.dart';

import '../../preference.dart';

class PreferenceList extends StatelessWidget {
  final List<Preference> prefList;
  final String title;
  final Function onSelected;
  final int section;

  // final Function onTapNext;

  PreferenceList(this.title, this.prefList, this.onSelected, this.section);

  void onSelectPill() {
    onSelected(
      section,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Text('${title}: ' + prefList.length.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Container(
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 3.0,
                children: List.generate(prefList.length.toInt(), (index) {
                  return PreferencePill(
                    index,
                    section,
                    prefList[index].name,
                    prefList[index].checked,
                    onSelected,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
