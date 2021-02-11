import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/finca_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:flutter/material.dart';


class ParcelaPage extends StatefulWidget {
    ParcelaPage({Key key}) : super(key: key);

    @override
    _ParcelaPageState createState() => _ParcelaPageState();
}


final fincasBloc = new FincasBloc();
class _ParcelaPageState extends State<ParcelaPage> {

    @override
    Widget build(BuildContext context) {

        final Finca fincaData = ModalRoute.of(context).settings.arguments;
        fincasBloc.obtenerParcelasIdFinca(fincaData.id);



        return StreamBuilder(
            stream: fincasBloc.parcelaStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {

                if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                }

                final parcela = snapshot.data;

                if (parcela.length == 0) {
                    return Scaffold(
                        appBar: AppBar(
                            title: Text('Registro de parcelas'),
                        ),
                        body: Column(
                            children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(20.0),
                                    child: Text(
                                        fincaData.nombreFinca, 
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0
                                        ),
                                    ),
                                ),
                                Divider()
                            ],
                        ),
                        bottomNavigationBar: BottomAppBar(
                            child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    Expanded(
                                        child: _editarFinca(fincaData),
                                    ),
                                    Expanded(child: _addParcela(fincaData),),
                                ],
                            ),
                        ),
                    );
                  
                }

                return Scaffold(
                    appBar: AppBar(
                        title: Text('Registro de parcelas'),
                    ),
                    body: Column(
                        children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple
                                ),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                    fincaData.nombreFinca, 
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0
                                    ),
                                ),
                            ),
                            Divider(),
                            Expanded(child: _listaDeParcelas(snapshot.data, fincaData, context),)
                            
                        ],
                    ),
                    bottomNavigationBar: BottomAppBar(
                        child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Expanded(
                                    child: _editarFinca(fincaData),
                                ),
                                Expanded(child: _addParcela(fincaData),),
                            ],
                        ),
                    ),
                );
            },
        );
    }

    Widget  _editarFinca(Finca finca){
        return RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.deepPurple,
            
            icon:Icon(Icons.save),
            textColor: Colors.white,
            label: Text('Editar finca'),
            //onPressed:(_guardando) ? null : _submit,
            onPressed: () => Navigator.pushNamed(context, 'addFinca', arguments: finca),
        );
    }

    Widget  _addParcela( Finca finca ){
        return RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.deepPurple,
            
            icon:Icon(Icons.save),
            textColor: Colors.white,
            label: Text('Agregar parcela'),
            //onPressed:(_guardando) ? null : _submit,
            onPressed:() => Navigator.pushNamed(context, 'addParcela', arguments: finca),
        );
    }


    Widget  _listaDeParcelas(List parcelas, Finca finca, BuildContext context){
        return ListView.builder(
            itemBuilder: (context, index) {
                return GestureDetector(
                    child: ListTile(
                        title: Text(parcelas[index].nombreLote),
                        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.deepPurple,),
                        subtitle: Text(' id ${parcelas[index].id} -- idfinca ${parcelas[index].idFinca} '),
                        
                    ),
                    onTap: () => Navigator.pushNamed(context, 'addParcela', arguments: parcelas[index]),
                );
               
            },
            shrinkWrap: true,
            itemCount: parcelas.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }
   
}