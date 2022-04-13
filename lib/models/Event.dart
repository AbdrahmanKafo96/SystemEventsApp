import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:systemevents/models/Category.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  CategoryClass categoryClass = CategoryClass();
  EventType eventType = EventType();
  String _eventName;
  String _eventDate;

  //int _eventType;
  double _lat;
  double _lng;
  String  description;
  File _imageFile, _videoFile ;
  List<XFile>  _xfile  =[], _listSelected;

  List<XFile>  get getListSelected => _listSelected;

  set setListSelected(List<XFile> value) {
    _listSelected = value;
  }

  final String event_name;

  final addede_id;
  LatLng tappedPoint  =null ;

  Event({this.event_name, this.addede_id ,this.description});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      event_name: json['event_name'],
      addede_id: json['addede_id'],
      description: json['description'],
    );
  }

    get getVideoFile => _videoFile;
    set setVideoFile(value) {
      _videoFile = value;
    }

  List<XFile> get getXFile => _xfile;

  set setXFile(List<XFile>  value) {
    _xfile=value;
  }
  void dropValue(int index){
    if(index>-1)
      _xfile.removeAt(index);
  }
  void dropAll( ){
    _videoFile=null;
     if(_xfile !=null) _xfile.clear();
     if(_listSelected !=null) _listSelected.clear();
  }
  void nullAll( ){
    _videoFile=null;
    if(_xfile !=null) _xfile=null;
    if(_listSelected !=null) _listSelected=null;
  }

  // File get getImageFile => _imageFile;
  //
  // set setImageFile(File value) {
  //   _imageFile = value;
  // }

  String get getEventName => _eventName;

  set setEventName(String value) {
    _eventName = value;
  }

  String get getEventDate => _eventDate;

  set setEventDate(String value) {
    _eventDate = value;
  }

  double get getLat => _lat;

  set setLat(double value) {
    _lat = value;
  }

  double get getLng => _lng;

  set setLng(double value) {
    _lng = value;
  }

  String get getDescription =>  description;

  set setDescription(String value) {
     description = value;
  }
}
