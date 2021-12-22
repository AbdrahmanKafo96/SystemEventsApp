import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/CustomWidget/customToast.dart';
import 'package:systemevents/model/Category.dart';
import 'package:systemevents/model/Event.dart';
import 'package:systemevents/singleton/singleton.dart';

class EventProvider extends ChangeNotifier{

      Event event= Event();
      addEvent(Map  userData , BuildContext context) async {
        var _count=1;
            var request =   http.MultipartRequest("POST",
                Uri.parse("${Singleton.apiPath}/save_event") ) ;
            request.fields['description'] = userData['description'];
            request.fields['event_name'] = userData['event_name'];
            request.fields['sender_id'] = userData['sender_id'].toString();
            request.fields['senddate'] = userData['senddate'];
            request.fields['eventtype'] = userData['eventtype'];
            request.fields['lat'] = userData['lat'];
            request.fields['lng'] = userData['lng'];
            // code below for camera image ...
        for(int i=0 ; i<event.getXFile.length; i++){
          print(event.getXFile[i].path);
        }
        print("the len = ${event.getXFile.length}");
            if(event.getXFile!=null){
              if(event.getXFile.length>=1 && event.getXFile.length<=4)
                {
                  event.setListSelected=event.getXFile;

                  for(int i=0 ; i<event.getListSelected.length; i++){
                    request.files.add(
                        http.MultipartFile('image${_count++}',
                            File(event.getListSelected[i].path).readAsBytes().asStream(),
                            File(event.getListSelected[i].path).lengthSync(),
                            filename: event.getListSelected[i].path.split("/").last
                        ));
                  }
                }

            }


             // if( event.getImageFile!=null){
             //   request.files.add(
             //       http.MultipartFile('image1',
             //           File(event.getImageFile.path).readAsBytes().asStream(),
             //           File(event.getImageFile.path).lengthSync(),
             //           filename: event.getImageFile.path.split("/").last
             //       ));
             // }

            if(event.getVideoFile!=null)
            request.files.add(
                http.MultipartFile('video',
                    File(event.getVideoFile.path ).readAsBytes().asStream(), File(event.getVideoFile.path).lengthSync(),
                    filename: event.getVideoFile.path.split("/").last
                ));

            var response =await  request.send();
            print(response.statusCode);
            if(response.statusCode==200 ){
              final respStr = await response.stream.bytesToString();
               var s= jsonDecode(respStr);
               print(s['error']);
               if(s['status']=='success'){
                 event=null;
                 event=Event();
                 return true;
               }else{
                 return false;
               }
            }else{
              return false;

            }
      }
      // finally {
      // client.close();
      // }
      //  we need to close connection after call these methods
      deleteEvent( int addede_id , int sender_id ) async {
            Map data={
                  'sender_id':sender_id.toString(),
                  'addede_id':addede_id.toString(),
            };
            final  response = await http.delete(
                  Uri.parse('${Singleton.apiPath}/deleteEvent'),
                body: data
            );

            if (response.statusCode == 200) {
                return Event.fromJson(jsonDecode(response.body));
            } else {
                  throw Exception('Failed to delete album.');
            }
      }//  we need to close connection after call these methods
      updateEvent(Map myData){


      }//  we need to close connection after call these methods
         Future<dynamic>  fetchEventDataByEventId( int addede_id)async {
        Map data={
          'addede_id':addede_id.toString(),
        };
        final response = await http
            .post(Uri.parse('${Singleton.apiPath}/getEvent'),body: data);

        if (response.statusCode == 200) {
          var parsed = json.decode(response.body) ;

          return parsed ;
         // return parsed.map<Event>((json) => Event.fromJson(json)).toList();
        }
      }
//  we need to close connection after call these methods
     Future<List<CategoryClass>>   fetchEventCategories()async{
            final response = await http
                .get(Uri.parse('${Singleton.apiPath}/fetchEventCategories'));

            if (response.statusCode == 200) {
                  final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

                 // return json.decode(response.body);
                  return parsed.map<CategoryClass>((json) => CategoryClass.fromJson(json)).toList();
                // return  CategoryClass.fromJson(jsonDecode(response.body));
            } else {
                  // If the server did not return a 200 OK response,
                  // then throw an exception.
                  throw Exception('Failed to load album');
            }
      }//  we need to close connection after call these methods
      Future<List<EventType>>  fetchEventTypes()async{
        final response = await http
            .get(Uri.parse('${Singleton.apiPath}/fetchEventTypes'));

        if (response.statusCode == 200) {
          final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

          // return json.decode(response.body);
          return parsed.map<EventType>((json) => EventType.fromJson(json)).toList();
          // return  CategoryClass.fromJson(jsonDecode(response.body));
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          throw Exception('Failed to load album');
        }
      }
      Future<List<Event>> fetchAllListByUserId( int sender_id  ) async {
        Map data={
                  'sender_id':sender_id.toString(),
            };
            final response = await http
                .post(Uri.parse('${Singleton.apiPath}/fetchAllListByUserId'), body: data);

    if (response.statusCode == 200) {

                  final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

                  return parsed.map<Event>((json) => Event.fromJson(json)).toList();
            } else {
                  throw Exception('Failed to load List');
            }
      }
  Future<List<Event>> fetchSearchedEvent( int addede_id  ) async {
    Map data={
      'int addede_id': addede_id.toString(),
    };
    final response = await http
        .post(Uri.parse('${Singleton.apiPath}/getEvent'),body: data);

    if (response.statusCode == 200) {

      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed.map<Event>((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load List');
    }
  }

  Future  searchByName( int sender_id  ) async {
    Map data={
      'sender_id':sender_id.toString(),
    };
    final response = await http
        .post(Uri.parse('${Singleton.apiPath}/fetchAllListByUserId'), body: data);

    if (response.statusCode == 200) {

      final parsed = json.decode(response.body) ;

      return parsed ;
    } else {
      throw Exception('Failed to load List');
    }
  }


}