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
  dynamic _membersList;

  @override
  void initState() {
    super.initState();
    _itemCount = 0;
    _getMembers();
  }
  void _getMembers() async {
    var dataT = await ClashRoyaleService.getMembers(widget.clanData["tag"]);
    setState(() {
      _itemCount = dataT.length;
      _membersList = dataT;
    });
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
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Image.network(widget.clanData['badge']['image']),
              ),
            ),
            Text('Total de membros $_itemCount', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
            Expanded(
              child: _buildMembersResults(),
            ),
          ],
        )

    );
  }

  Widget _buildMembersResults() {
    if(_membersList != null){
      return ListView.builder(
        itemCount: _membersList?.length,
        itemBuilder: (context, index) {
          return Card(child: ListTile(title: Text(_membersList[index]['name'])));
        },
      );
    } else {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 5.0,
          ),
        ),
      );
    }


  }
}
