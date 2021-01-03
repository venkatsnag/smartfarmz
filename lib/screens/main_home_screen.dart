import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {

    final orientation = MediaQuery.of(context).orientation;

    /* return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
          body: GridView.builder(
  itemCount: 1,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    
      crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
  itemBuilder: (BuildContext context, int index) {
    return new Card(
      
      child: new GridTile(
       
        child: new Text('My Crops'), //just for testing, will fill with image later
      
      ),
      
    );
   
   
    Container();  
  },
  
),
                
                                              
                      ); */
        
   

   return MaterialApp(
      title: "Twitter Layout",
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(21, 32, 43, 1.0),
        accentColor: Colors.blueAccent[200],
      ),
      home: new Scaffold(
          appBar: new AppBar(
            title: Row(
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                    child: new Text("L"),
                    radius: 15.0,
                  ),
                  margin: EdgeInsets.only(right: 30.0),
                ),
                new Text("Home")
              ],
            ),
            elevation: 4.0,
          ),
          body: _buildBody(context)
      ),
    );
  }

  Widget _buildBody(dynamic context){
    return new Container(
      child: new Column(
        children: <Widget>[
          new Flexible(
              child: Scaffold(
                body: new ListView.builder(
                  /* itemBuilder: (_, int index) => _tweets[index],
                  itemCount: _tweets.length, */
                  reverse: false,
                ),
                floatingActionButton: FloatingActionButton(
                    onPressed: null, child: Icon(Icons.edit)),
              )),
          new Container(
            decoration:
            new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTabsBar(context),
          ),
        ],
      ),
    );
  }
  Widget _buildTabsBar(dynamic context) {
    return Container(
      height: 60,
      color: Color.fromRGBO(21, 32, 43, 1.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(Icons.home, color: Theme.of(context).accentColor),
          Icon(Icons.search, color: Colors.grey[100]),
          Icon(Icons.notifications_none, color: Colors.grey[100]),
          Icon(Icons.mail_outline, color: Colors.grey[100])
        ],
      ),
    );
  }
}