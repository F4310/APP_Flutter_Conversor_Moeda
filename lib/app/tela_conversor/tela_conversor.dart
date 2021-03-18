import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const request = "https://api.hgbrasil.com/finance";

class Home  extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Home> {
  @override
  Widget build(BuildContext context)  {

    final realController = TextEditingController();
    final dolarController = TextEditingController();
    final euroController = TextEditingController();

    double dolar;
    double euro;
    double real;
//    print(getDados());

    void _realChanged(String text){

      real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsPrecision(3);

    }

    void _dolarChanged(String text){

      double valor = double.parse(text);
      realController.text = (valor * dolar).toStringAsPrecision(3);
      euroController.text = ((dolar/euro)*valor).toStringAsPrecision(3);

        // 1 dolar - 0.84 euro
       // 1 dolar - real 5.55
      // 1 real - euro 0.15
      
      //1d r5.55
      //1r e0.15

    }

    void _euroChanged(String text){

      double valor = double.parse(text);
      realController.text = (valor*euro).toStringAsPrecision(3);
      dolarController.text = ((euro/dolar)*valor).toStringAsPrecision(3);


    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Conversor Moeda",
          style: TextStyle(color: Colors.black,fontSize: 25.0 ),),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getDados(),
        builder: (context, snapshot){

          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados...",
                style: TextStyle(color: Colors.white),),
              );

              default:
                if(snapshot.hasError){
                  return Center(
                      child: Text("Erro colega...",
                    style: TextStyle(color: Colors.white)),
                  );
                }else{

                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                              size: 150.0,
                              color: Colors.amber
                          ),
                          TextField(
                            controller: realController,
                            decoration: InputDecoration(
                              labelText: "Reais",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "R\$",

                            ),
                            style: TextStyle(color: Colors.black,fontSize: 25.0),
                            onChanged: _realChanged,
                          ),

                          Divider(),

                          TextField(
                            controller: dolarController,
                            decoration: InputDecoration(
                              labelText: "Dolar",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "R\$",

                            ),
                            style: TextStyle(color: Colors.amber,fontSize: 25.0),
                            onChanged: _dolarChanged,
                          ),

                          Divider(),

                          TextField(
                            controller: euroController,
                            decoration: InputDecoration(
                              labelText: "Euro",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "R\$",

                            ),
                            style: TextStyle(color: Colors.amber,fontSize: 25.0),
                            onChanged: _euroChanged,
                          )



                        ],
                      )
                    );
                }
          }

        },
      ),
    );

  }
    Future<Map> getDados() async{

    http.Response response = await http.get(request);
    return jsonDecode(response.body);
  }
}
