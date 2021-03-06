import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/modules/home/menu/image_picker.dart';
import 'package:systemevents/modules/home/event_screens/video_picker.dart';
import 'package:systemevents/modules/home/home.dart';
import 'package:systemevents/widgets/checkInternet.dart';
import 'package:systemevents/widgets/customToast.dart';

import 'package:systemevents/provider/event_provider.dart';
import 'package:systemevents/singleton/singleton.dart';
import 'package:systemevents/widgets/dialog.dart';

class EventView extends StatefulWidget {
  int eventID;String eventName;

  EventView({this.eventID , this.eventName});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  var _response;
  String video = "none";
  List<String> imgList = List.filled(4, null);
  int count;

  final eventNameController = TextEditingController();
  final eventDescController = TextEditingController();

  @override
  initState() {
    super.initState();
    setDataInView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                '${widget.eventName}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  color: Colors.white,
                    iconSize: 24, onPressed: ()  async {
                checkInternetConnectivity(context).then((bool value) async {
                  if(value){
                    SharedPreferences prefs = await Singleton.getPrefInstance();
                    Map userData = Map();
                    userData = {
                      'user_id':prefs.getInt('user_id').toString(),
                      'addede_id': widget.eventID,
                      'description':
                      eventDescController.text.toString(),
                      'event_name':
                      eventNameController.text.toString()
                    };

                    bool result =
                    await Provider.of<EventProvider>(context, listen: false)
                        .updateEvent(userData );
                    if (result) {
                      showShortToast('??????  ?????????? ?????????????? ??????????', Colors.green);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                            (Route<dynamic> route) => false,
                      );
                    } else {
                      showShortToast('???? ?????? ?????????? ?????????????? ??????????', Colors.green);
                    }
                  }

                });}, tooltip: '?????? ??????????????',
                    icon: Icon(Icons.edit)),
                IconButton(
                    tooltip: '?????? ??????????',
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      checkInternetConnectivity(context).then((
                          bool value) async {
                        if (value) {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    content: Text("???? ?????? ?????????? ???? ?????? ????????????"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          "??????????",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "??????",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          int postId = widget.eventID;

                                          Singleton.getPrefInstance().then((
                                              value) {
                                            Provider.of<EventProvider>(
                                                context, listen: false)
                                                .deleteEvent(
                                                postId,
                                                value.getInt('user_id'));
                                          });
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }
                      });
                    })
              ],
              leading: IconButton(
                tooltip: '????????',
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Provider.of<EventProvider>(context, listen: false).event.nullAll() ;

                  Navigator.pop(context);
                },
              ),
            ),
            body: _response == null
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Stack(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Color(0xFF5a8f62),
                                boxShadow: [BoxShadow(blurRadius: 1.0)],
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30)),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 15,
                              left: 15,
                              //     bottom: MediaQuery.of(context).size.height * 0.10,
                              child: Center(
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.green.withOpacity(0.5),
                                          blurRadius: 7.0,
                                          offset: Offset(0.0, 0.50))
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                        bottomLeft: Radius.circular(50),
                                        bottomRight: Radius.circular(50)),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.width * 0.75,
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  child: Card(
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        count>0?
                                        MyCustomImage(
                                            count: count, updateList: imgList , eventID: widget.eventID)
                                            :MyCustomImage(),
                                         _response['data']['video'] != null
                                             ? VideoPicker(oldVideo: video , eventID: widget.eventID)
                                             : VideoPicker(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        //  height: 250,
                        height: MediaQuery.of(context).size.height * 0.3,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // ListTile(
                            //   title: Text(
                            //     '?????? ??????????',
                            //     style: TextStyle(fontWeight: FontWeight.bold),
                            //   ),
                            //   leading: Icon(Icons.title),
                            //   trailing: IconButton(
                            //     tooltip: "?????????? ?????? ??????????",
                            //     icon: Icon(
                            //       Icons.edit,
                            //       color: Colors.green,
                            //     ),
                            //     onPressed: () {
                            //       createDialog(context, '?????????? ?????? ??????????')
                            //           .then((value) {
                            //         eventNameController.text = value;
                            //       });
                            //     },
                            //   ),
                            //   subtitle: Text(eventNameController.text),
                            //
                            // ),
                            ListTile(
                              title: Text(
                                '??????????',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              leading: Icon(Icons.description),
                              trailing: IconButton(
                                tooltip: "?????????? ??????????",
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {

                                  createDialog(context, '?????????? ??????????' ,"??????" ,
                                  ({TextEditingController textEditingController}){
                                     Navigator.of(context).pop(textEditingController.text);
                                  })
                                      .then((value) {

                                    eventDescController.text = value;
                                  });
                                },
                              ),
                              subtitle: Text(
                                  eventDescController.text.isEmpty?"???? ???????? ??????":eventDescController.text
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
      ),
    );
  }

  // Future<String> createDialog(BuildContext context, String value) {
  //   TextEditingController textEditingController = TextEditingController();
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Directionality(
  //           textDirection: TextDirection.rtl,
  //           child: AlertDialog(
  //             title: Text(
  //               value,
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //             ),
  //             content: TextField(
  //               decoration: InputDecoration(hintText: '???????? ???? ????????'),
  //               controller: textEditingController,
  //             ),
  //             actions: [
  //               MaterialButton(
  //                   color: Colors.green,
  //                   child: Text("??????????"),
  //                   onPressed: () {
  //                     Navigator.of(context).pop(textEditingController.text);
  //                   })
  //             ],
  //           ),
  //         );
  //       });
  // }

  Future<void> setDataInView() async {
    await Provider.of<EventProvider>(context, listen: false)
        .fetchEventDataByEventId(widget.eventID)
        .then((value) {
      setState(() {
        _response = value;
        if (_response != null) {
          count = _response['count'];

          if (_response['data']['video'] != null)
            video = "http://192.168.1.3:8000" + _response['data']['video'];

          eventNameController.text = _response['data']['event_name'];
          eventDescController.text = _response['data']['description'];
            int index=0;
          for (int i = 1; i <= 4; i++) {
            if(_response['data']['image$i']!=null)
            {
              imgList[index]="http://192.168.1.3:8000" +_response['data']['image$i'];

            } index++;
          }
        }
      });
    });
  }
}

// Expanded(
// flex: 2,
// child: Container(
// ),
// ),
