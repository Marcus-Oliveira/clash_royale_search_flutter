import 'package:clash_royale_search_v1/screens/details_page.dart';
import 'package:clash_royale_search_v1/services/clash_royale_service.dart';
import 'package:flutter/material.dart';

import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _offset = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      _search = 'teste';
    });

    ClashRoyaleService.getClans(_search).then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Encontre seu clã no clash royale'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui!",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: ClashRoyaleService.getClans(_search),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if(snapshot.hasError) return Container(
                        child: Center(child: Center(child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Ocorreu um erro :(', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
                          ),
                        ))),
                      );
                      else return _createClanTable(context, snapshot);
                  }
                }
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data){
    if(_search == null){
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createClanTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
        ),
        itemCount: _getCount(snapshot.data),
        itemBuilder: (context, index){
          if(index < snapshot.data.length) {
            return GestureDetector(
              child: Column(
                children: <Widget>[
                  Text(snapshot.data[index]['name'], style: TextStyle(color: Colors.white),),
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: snapshot.data[index]['badge']['image'],
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  Text(snapshot.data[index]['description'], style: TextStyle(color: Colors.white),),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        DetailsPage(clanData: snapshot.data[index]))
                );
              },
              onLongPress: () {
                Share.share(snapshot.data[index]['badge']['image']);
              },
            );
          } else {
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70.0,),
                    Text("Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),)
                  ],
                ),
                onTap: (){
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
          }
        }
    );
  }

}
