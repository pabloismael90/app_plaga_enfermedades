import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/existePlaga_model.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';

import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class AgregarPlanta extends StatefulWidget {
  @override
  _AgregarPlantaState createState() => _AgregarPlantaState();
}

class _AgregarPlantaState extends State<AgregarPlanta> {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final formKey = GlobalKey<FormState>();

    bool _guardando = false;
    int variableVacias = 0;
    var uuid = Uuid();

    Planta planta = Planta();
    ExistePlaga existePlaga = ExistePlaga();
    List<ExistePlaga> listaPlagas = [];

    final fincasBloc = new FincasBloc();
    
    final List<Map<String, dynamic>>  itemPlagas = selectMap.plagasCacao();
    final Map radios = {};
    void radioGroupKeys(){
        for(int i = 0 ; i < itemPlagas.length ; i ++){
            
        radios[itemPlagas[i]['value']] = '-1';
        }
    }

    @override
    void initState() {
        super.initState();
        radioGroupKeys();
    }

    @override
    Widget build(BuildContext context) {

        List data = ModalRoute.of(context).settings.arguments;
        
        planta.idTest = data[1];
        planta.estacion = data[0] ;
        
        

        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: Text('Formulario Planta'),
            ),
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                            children: <Widget>[
                                Container(child: Center(child: Text('Estacion número ${planta.estacion}'),),),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Expanded(child: Container(),),
                                        Container(
                                            width: 50.0,
                                            child: Text('Si', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold) ,),
                                            //color: Colors.deepPurple,
                                        ),
                                        Container(
                                            width: 50.0,
                                            child: Text('No', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                                            //color: Colors.deepPurple,
                                        ),
                                    ],
                                ),
                                _plagasList(),
                                Divider(),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Expanded(child: Container(),),
                                        Container(
                                            width: 50.0,
                                            child: Text('Alta', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold) ,),
                                            //color: Colors.deepPurple,
                                        ),
                                        Container(
                                            width: 50.0,
                                            child: Text('Media', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold) ,),
                                            //color: Colors.deepPurple,
                                        ),
                                        Container(
                                            width: 50.0,
                                            child: Text('Baja', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                                            //color: Colors.deepPurple,
                                        ),
                                    ],
                                ),
                                 _produccion(),
                                 Divider(),
                                 _botonsubmit()
                            ],
                        ),
                    ),
                ),
            )

        );
    }


    Widget _plagasList(){

        return ListView.builder(
            
            itemBuilder: (BuildContext context, int index) {
                
                String labelPlaga = itemPlagas.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                int idPlaga = int.parse(itemPlagas.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "100","label": "No data"})['value']);
                
                
                
                return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        Expanded(child: Text('$labelPlaga', style:TextStyle(fontWeight: FontWeight.bold))),
                        Radio(
                            value: '1',
                            groupValue: radios[itemPlagas[idPlaga]['value']],
                            onChanged: (value){
                                setState(() {
                                    radios[itemPlagas[idPlaga]['value']] = value;
                                    print(value);
                                    
                                });
                            },
                        ),
                        Radio(
                            value:'2',
                            groupValue: radios[itemPlagas[idPlaga]['value']],
                            onChanged: (value){
                                setState(() {
                                
                                    radios[itemPlagas[idPlaga]['value']] = value;
                                    print(value);
                                    
                                });
                            },
                        ),
                       

                    ],
                );
        
            },
            shrinkWrap: true,
            itemCount: itemPlagas.length,
        );
        
    }

    Widget _produccion(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Producción', style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.produccion,
                    onChanged: (value) {
                    setState(() {
                        planta.produccion = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.produccion,
                    onChanged: (value) {
                    setState(() {
                        planta.produccion = value;
                    });
                }),
                Radio(
                    value: 3,
                    groupValue: planta.produccion,
                    onChanged: (value) {
                    setState(() {
                        planta.produccion = value;
                    });
                }),   

            ],
        );
        
    }

    

    Widget  _botonsubmit(){
        return RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.deepPurple,
            
            icon:Icon(Icons.save),
            textColor: Colors.white,
            label: Text('Guardar'),
            onPressed:(_guardando) ? null : _submit,
        );
    }


    _listaPlagas(){

        radios.forEach((key, value) {
            final ExistePlaga hola = ExistePlaga();
            // print('id: ${uuid.v1()}');
            // print('idPlanta: ${planta.id}');
            // print('idPlaga: ${int.parse(key)}' );
            // print('existe: ${int.parse(value)}');
            hola.id = uuid.v1();
            hola.idPlanta = planta.id;
            hola.idPlaga = int.parse(key);
            hola.existe = int.parse(value);


            listaPlagas.add(hola);
        });

        //setState(() {_guardando = true;});
        
    }

    void _submit(){
        variableVacias = 0;
        radios.forEach((key, value) {
            //print('Esta es la key : $value');
            if (value == '-1') {
                variableVacias ++;
            } 
        });

        if  ( variableVacias !=  0){
            //print(variableVacias);
            mostrarSnackbar(variableVacias);
            //return null;
        }

        _listaPlagas();
        
        //variables Plagas
        for (var item in listaPlagas) {
            print('id :${item.id}');
            print('id Planta : ${item.idPlanta}');
            print('id Plaga: ${item.idPlaga}');
            print('id Plaga: ${item.existe}');
        }
        
        //Variables Planta
        //print('Id : ${planta.id}');
        //print('Id Test: ${planta.idTest}');
        //print('Estacion: ${planta.estacion}');
        //print('Produccion: ${planta.produccion}');


        // formKey.currentState.save();

        //setState(() {_guardando = true;});


        // if(planta.id == null){
        //     planta.id =  uuid.v1();
        //     fincasBloc.addPlata(planta, planta.idTest, planta.estacion);
        // }else{
        //     fincasBloc.actualizarFinca(finca);
        // }

       // setState(() {_guardando = false;});
        


        //Navigator.pop(context, 'estaciones');
       
        
    }


    void mostrarSnackbar(int variableVacias){
        final snackbar = SnackBar(
            content: Text('Hay $variableVacias Campos Vacios, Favor llene todo los campos'),
            duration: Duration(seconds: 2),
        );

        scaffoldKey.currentState.showSnackBar(snackbar);
    }


}