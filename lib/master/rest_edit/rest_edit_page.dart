import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_vishu/common_widget/vishu_app_bar.dart';
import 'package:salon_vishu/domain/rest.dart';
import 'package:salon_vishu/master/rest_edit/rest_edit_model.dart';

class RestEditPage extends StatefulWidget {
  const RestEditPage({Key? key}) : super(key: key);

  @override
  State<RestEditPage> createState() => _RestEditPageState();
}

class _RestEditPageState extends State<RestEditPage> {
  List<bool> selectedList = [...List.generate(1000, (index) => false)];

  @override
  Widget build(BuildContext context) {
    return Consumer<RestEditModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: vishuAppBar(appBarTitle: '休憩情報', isJapanese: true),
        body: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: model.restTimeList.length,
                itemBuilder: ((context, index) {
                  Rest rest = model.restTimeList[index];

                  return Container(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide())),
                    child: CheckboxListTile(
                      selected: selectedList[index],
                      title: Text(
                        model.restFormatter.format(rest.startTime.toDate()),
                        style: TextStyle(
                            decoration: selectedList[index]
                                ? TextDecoration.lineThrough
                                : null,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      value: selectedList[index],
                      onChanged: (bool? value) {
                        setState(() {
                          print(selectedList[index]);
                          selectedList[index] = value!;
                          print(selectedList[index]);
                          model.addDeleteList(rest);
                          print(model.deleteRestList.length);
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                })),
            ElevatedButton(
                onPressed: () {
                  model.deleteRegister(context);
                },
                child: const Text('削除する')),
          ],
        ),
      );
    });
  }
}
