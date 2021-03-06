import 'dart:io';
import 'dart:math';
import 'package:country_picker/country_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:systemevents/widgets/checkInternet.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemevents/models/witness.dart';
import 'package:systemevents/provider/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  File _image;
  final picker = ImagePicker();
  String _uri ;
  var result;
  var firstNameCon = TextEditingController();
  var fatherNameCon = TextEditingController();
  var lastNameCon = TextEditingController();
  var dateCon = TextEditingController(text: "1960-01-01 00:00:00.000");
  String country1="";
  bool state = false;
  Witness witness;

  Future<void> getUID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String uid = pref.getInt('user_id').toString();
    setState(() {
      result = uid;
    });
  }

  @override
  void initState() {
    super.initState();
  getUID().then((value) => checkState(result).then((Witness value){
    setState(() {
        witness=value;
        if(value !=null)
          {
            state=true;
              _image=null;
              _uri=witness.image!=null?"http://192.168.1.3:8000${witness.image}":null;
              print(_uri);
            setDataForm();
          }
    });
   }));
  }
  @override
  void dispose() {
    super.dispose();
     firstNameCon.dispose();
      fatherNameCon.dispose();
     lastNameCon.dispose();
     dateCon.dispose();
      _uri =null;
     country1=null;
     witness=null;
     _image=null;
  }
  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              ' ???????????? ????????????????',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
                tooltip: '????????',
              onPressed: () {
                  Navigator.of(context).pop();

              }
            ),
            actions: [
              IconButton(
                tooltip: '??????????',
                onPressed: () {
                  checkInternetConnectivity(context).then((
                      bool value) async {
                    if (value) { var form = _formKey.currentState;
                    if (form.validate()) {
                      state==true?updateForm(context): saveData(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          '???? ???????? ?????????? ???????? ????????????????',
                          //textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: Colors.red,
                      ));
                    }}});

                },
                icon: Icon(
                  state == true ? Icons.edit : Icons.save,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.grey,
                                    spreadRadius: 5)
                              ],
                            ),
                            child: CircleAvatar(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: state != true?"?????? ???????????? ??????????????":"",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12)),
                                    WidgetSpan(
                                      child: state != true?Icon(Icons.perm_media_sharp):SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,

                              backgroundImage: _image == null ?
                                      _uri != null?
                                        NetworkImage(_uri)
                                      :   null
                                  :
                              FileImage(_image),
                              radius: 80,
                              key: ValueKey(new Random().nextInt(100)),
                            ),
                          ),
                        ),

                      ],
                    ),

                    SizedBox(
                      height: 12,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: firstNameCon,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.singleLineFormatter
                            ],

                            validator: (value) =>
                                value.isEmpty ? '?????????? ?????????? ??????????' : null,
                            decoration: InputDecoration(
                                prefixIcon: Icon(

                                  Icons.drive_file_rename_outline,
                                  color: Colors.teal,
                                ),
                                labelText: "?????????? ??????????",
                                hintText: "???????? ?????? ??????????"),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: fatherNameCon,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.singleLineFormatter
                            ],

                            validator: (value) =>
                                value.isEmpty ? '?????? ???????? ??????????' : null,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.teal,
                                ),
                                labelText: "?????? ????????",
                                hintText: "???????? ?????? ????????"),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: lastNameCon,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.singleLineFormatter
                            ],

                            validator: (value) =>
                                value.isEmpty ? '?????? ?????????????? ??????????' : null,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.teal,
                                ),
                                labelText: "?????? ??????????????",
                                hintText: "???????? ?????? ??????????????"),
                          ),
                          SizedBox(height: 24,),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: DateTimePicker(
                                    validator: (value){
                                      if(value.isEmpty || value ==null)
                                        return "?????? ?????????? ?????????? ??????????????";
                                      else
                                        return null;
                                    },
                                    onChanged: (value){

                                      Provider.of<UserAuthProvider>(context,listen: false).user.setDate_of_birth=value;
                                    },
                                    controller: dateCon,
                                    // controller: date_of_birthController,
                                    type: DateTimePickerType.date,
                                    cancelText: "????",
                                    confirmText: '??????',
                                    dateMask: 'd MMM, yyyy',
                                  //  initialValue:dateCon.text  ,
                                    firstDate: DateTime(1930),
                                    lastDate: DateTime(DateTime.now().year-12),
                                    calendarTitle: '???????? ?????????? ????????????',
                                    icon: Icon(Icons.event),
                                    dateLabelText: '?????????? ??????????????',
                                    timeLabelText: "????????",
                                    textAlign: TextAlign.left ,
                                    autovalidate:true ,
                                    errorFormatText: "???????? ?????????? ????????",
                                    errorInvalidText: '???????? ???? ?????????? ?????????? ????????',


                                    // validator: (val) {
                                    //   print('the date on validation $val ');
                                    //   return null;
                                    // },
                                    onSaved: (val) => print('the date on save $val'),
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   flex: 1,
                              //   child: TextButton.icon(
                              //
                              //     onPressed: () {
                              //       showCountryPicker(
                              //
                              //         context: context,
                              //         //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                              //         exclude: <String>['KN', 'MF'],
                              //         //Optional. Shows phone code before the country name.
                              //         showPhoneCode: true,
                              //
                              //         onSelect: (Country country) {
                              //           // countryController=country.displayName;
                              //           Provider.of<UserAuthProvider>(context,listen: false).user.setCountry=country.displayNameNoCountryCode;
                              //           setState(() {
                              //             country1=country.displayNameNoCountryCode.toString();
                              //           });
                              //         },
                              //       );
                              //     },
                              //     icon: Icon(Icons.language),
                              //     label: Text(country1!=""?country1:'???????????? ????????????' ),
                              //   ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void pickImage() async {

    var image = await picker.getImage(source: ImageSource.gallery, imageQuality: 50 );
   if(image!=null)
    if(image.path!="")
    setState(() {
      _image = File(image.path);

      Provider.of<UserAuthProvider>(context,listen: false).user.profilePicture=_image;
      _uri=null;
    });

  }



  Future<void> saveData(BuildContext context) async {
    try{
      //await uploadImage(context);

      if (result != null  ) {

        Map data={
          'user_id':result.toString(),
          'first_name':firstNameCon.text ,
          'father_name': fatherNameCon.text,
          'family_name':lastNameCon.text,
          'country': Provider.of<UserAuthProvider>(context,listen: false).user.getCountry.toString(),
          'date_of_birth': Provider.of<UserAuthProvider>(context,listen: false).user.getDate_of_birth.toString(),
        };

        bool res =await Provider.of<UserAuthProvider>(context,listen: false).saveProfileData(data);
        if(res==true)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('?????? ?????????? ?????????? ??????????', textDirection: TextDirection.rtl,),backgroundColor: Colors.green,
        ));
        else{
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text('???????? ??????????', textDirection: TextDirection.rtl,),backgroundColor: Colors.orange,
          ));
        }

      }// end if stm
    }catch(ex){
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text('???????? ??????????', textDirection: TextDirection.rtl,),backgroundColor: Colors.orange,
      ));
    }
  }

  void setDataForm( ) {
    firstNameCon.text=witness!=null?witness.first_name:"";
    fatherNameCon.text=witness!=null?witness.father_name:"";
    lastNameCon.text=witness!=null?witness.family_name:"";
    dateCon.text=witness!=null?(witness.date_of_birth ):"1960-01-01 00:00:00.000";
     witness!=null?Provider.of<UserAuthProvider>(context,listen: false).user.setDate_of_birth=dateCon.text
    :Provider.of<UserAuthProvider>(context,listen: false).
     user.setDate_of_birth="1960-01-01 00:00:00.000";

    country1=witness!=null?witness.country:"";
    witness!=null?
    Provider.of<UserAuthProvider>(context,listen: false).user.setCountry=witness.country:
    Provider.of<UserAuthProvider>(context,listen: false).user.setCountry="";
    _image=null;

  }

  Future<void> updateForm(BuildContext context) async {
    try{
      //await uploadImage(context);

      if (result != null  ) {

        Map data={
          'user_id':result.toString(),
          'first_name':firstNameCon.text ,
          'father_name': fatherNameCon.text,
          'family_name':lastNameCon.text,
          'country': Provider.of<UserAuthProvider>(context,listen: false).user.getCountry.toString(),
          'date_of_birth': Provider.of<UserAuthProvider>(context,listen: false).user.getDate_of_birth.toString(),
        };

         bool res = await Provider.of<UserAuthProvider>(context,listen: false)
             .updateProfileData(data);
        if(res==true)

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('?????? ?????????? ?????????????? ??????????', textDirection: TextDirection.rtl,),backgroundColor: Colors.green,
          ));
        else{
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: Text('???????? ??????????1', textDirection: TextDirection.rtl,),backgroundColor: Colors.orange,
          ));
        }

      }// end if stm
    }catch(ex){
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text('???????? ??????????2', textDirection: TextDirection.rtl,),backgroundColor: Colors.orange,
      ));
    }

  }

  Future<Witness> checkState(result) async{
    Witness res= await  Provider.of<UserAuthProvider>(context,listen: false).checkState(result);
     return res;
  }
}
