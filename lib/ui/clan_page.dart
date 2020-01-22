import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class ClanPage extends StatelessWidget {

  final Map _clanData;

  ClanPage(this._clanData);

  Future<dynamic> _getMembers() async {
    http.Response response;

    response = await http.get(
        "https://api.royaleapi.com/clan/${this._clanData['tag']}",
        headers: {HttpHeaders.authorizationHeader: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTc2MywiaWRlbiI6IjQ5NTYwMzg4Njc0NTE5MDQzMiIsIm1kIjp7InVzZXJuYW1lIjoibHVjYXNjaGlvcXVldGkiLCJkaXNjcmltaW5hdG9yIjoiNTYwNiIsImtleVZlcnNpb24iOjN9LCJ0cyI6MTU3OTAwMzc0MzgxOX0.pATgWATRRqQm-fA1rlmMPwJO_hhy_Nf5Lg9OJvgtGq4"}
    );
    return json.decode(response.body)['members'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do ${_clanData["name"]}'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.share(_clanData['badge']['image']);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          ListView.builder(
              itemCount: 3,
              itemBuilder: (content, index) {
                return FutureBuilder(
                    future: _getMembers(),
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
                          else return Card(child: ListTile(title: Text(snapshot.data[index]['name'])));
                      }
                    }
                );
              }
          ),
        ],
      )

    );
  }
}

