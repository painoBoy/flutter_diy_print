import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/ScreenAdapter.dart';

class MessageListPage extends StatefulWidget {
  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left,
                      color: Colors.white, size: ScreenAdapter.size(80)),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              brightness: Brightness.light,
              title: Text(
                "Model Collection",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  ExpansionPanelList(
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    children: <ExpansionPanel>[
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text('消息1'),
                          );
                        },
                        body: Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: ListBody(
                            children: <Widget>[
                              Card(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text('我是内容'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isExpanded: _isExpanded,
                        canTapOnHeader: true,
                      ),
                    ],
                    animationDuration: kThemeAnimationDuration,
                  ),
                ],
              ),
            ])));
  }
}
