import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:flutter/material.dart';


final fincasBloc = new FincasBloc();

class TestPage extends StatefulWidget {

    
    

  @override
  _TestPageState createState() => _TestPageState();
}


class _TestPageState extends State<TestPage> {



    @override
    Widget build(BuildContext context) {
        fincasBloc.obtenerPlagas();
        return StreamBuilder<List<Testplaga>>(
            stream: fincasBloc.plagaStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());

                }

                final fincas = snapshot.data;
                if (fincas.length == 0) {
                    return Scaffold(
                        appBar: AppBar(
                            title: Text('Registro Test'),
                        ),
                        body: Center(child: Text('No hay datos'),),
                        floatingActionButton: _addtest(context),
                    );
                  
                }
                
                return Scaffold(
                    appBar: AppBar(
                        title: Text("Lista de Test"),
                    
                    ),
                    body: _listaDePlagas(snapshot.data, context),
                    floatingActionButton: _addtest(context),
                );
            },
        );
    }

    Widget _addtest(BuildContext context){
        return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed:() => Navigator.pushNamed(context, 'addTest'),
        );
    }

    Widget  _listaDePlagas(List textPlaga, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return GestureDetector(
                    child: ListTile(
                        title: Text(textPlaga[index].fechaTest),
                        subtitle: Column(
                            children: [
                                Text('id: ${textPlaga[index].idFinca}'),
                                Text('estaciones: ${textPlaga[index].estaciones}'),
                            ],
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.deepPurple,),
                    ),
                    onTap: () => Navigator.pushNamed(context, 'estaciones', arguments: textPlaga[index]),
                );
               
            },
            shrinkWrap: true,
            itemCount: textPlaga.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }
}