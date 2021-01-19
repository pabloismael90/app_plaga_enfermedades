import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/finca_model.dart';
import 'package:flutter/material.dart';



class FincasPage extends StatefulWidget {

    
    

  @override
  _FincasPageState createState() => _FincasPageState();
}

final fincasBloc = new FincasBloc();

class _FincasPageState extends State<FincasPage> {



    @override
    Widget build(BuildContext context) {
        
        fincasBloc.obtenerFincas();

        return StreamBuilder<List<Finca>>(
            stream: fincasBloc.fincaStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());

                }

                final fincas = snapshot.data;
                if (fincas.length == 0) {
                    return Scaffold(
                        appBar: AppBar(
                            title: Text('Registro Finca'),
                        ),
                        body: Center(child: Text('No hay datos'),),
                        floatingActionButton: _addFinca(context),
                    );
                  
                }
                
                return Scaffold(
                    appBar: AppBar(
                        title: Text("Lista de fincas"),
                    
                    ),
                    body: _listaDeFincas(snapshot.data, context),
                    floatingActionButton: _addFinca(context),
                );

                



               
                    
                

                    
                
            },
        );

    }

    Widget _addFinca(BuildContext context){
        return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed:() => Navigator.pushNamed(context, 'addFinca'),
        );
    }

    Widget  _listaDeFincas(List fincas, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return GestureDetector(
                    child: ListTile(
                        title:Column(
                            children: [
                                Text(fincas[index].nombreFinca),
                                Text(fincas[index].nombreProductor),
                            ],
                        ), 
                        subtitle: Text(fincas[index].id),
                        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.deepPurple,),
                    ),
                    onTap: () => Navigator.pushNamed(context, 'parcelas', arguments: fincas[index]),
                );
               
            },
            shrinkWrap: true,
            itemCount: fincas.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }
}