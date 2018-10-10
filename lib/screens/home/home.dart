import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();

}

class _HomeScreen extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shuttle Status", style: TextStyle(color: Colors.black),),
        elevation: 2.0,
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.blue,
      ),
      bottomSheet: bottomMenu(),
    );
    
  }

  Widget bottomMenu() {
    return Container(
      height: 100.0,
      color: Colors.white,
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          nextStopButton(),
          etcButton()
        ],
      ),
    );
  }

  Widget nextStopButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      width: 150.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Next Stop",
            style: TextStyle(
              fontFamily: "CircularStd-Book",
              fontWeight: FontWeight.bold, 
              color: Color(0xFFF2014B)
            ), 
          ),
          Icon(Icons.drive_eta),
          Text("Target",
            style: TextStyle(
              fontFamily: "CircularStd-Book",
              fontWeight: FontWeight.bold, 
              color: Color(0xFFF2014B)
            ), 
          )
        ],
      )
    );
  }

  Widget etcButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      width: 150.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Estimated Time",
            style: TextStyle(
              fontFamily: "CircularStd-Book",
              fontWeight: FontWeight.bold, 
              color: Color(0xFFF2014B)
            ), 
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text("6 mins", 
              style: TextStyle(
                fontSize: 25.0, 
                fontFamily: "CircularStd-Book",
                fontWeight: FontWeight.bold, 
                color: Color(0xFFF2014B)
              ), 
            ),
          )
        ],
      )
    );
  }

}
