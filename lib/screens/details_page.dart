import 'package:clash_royale_search_v1/services/clash_royale_service.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class DetailsPage extends StatefulWidget {

  dynamic clanData;

  DetailsPage({Key key,
    @required this.clanData});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  int _itemCount;

  @override
  void initState() {
    _itemCount = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Membros do clã ${widget.clanData["name"]}'),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: (){
                Share.share(widget.clanData['badge']['image']);
              },
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                  future: ClashRoyaleService.getMembers(widget.clanData["tag"]),
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
                        else return _buildSearchResults(snapshot.data);
                    }
                  }
              ),
            ),
          ],
        )

    );
  }

  Widget _buildSearchResults(results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Card(child: ListTile(title: Text(results[index]['name'])));
      },
    );
  }
}
