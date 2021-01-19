import 'package:flutter/material.dart';

import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:app_plaga_enfermedades/src/utils/validaciones.dart' as utils;
import 'package:select_form_field/select_form_field.dart';
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:uuid/uuid.dart';

class AgregarFinca extends StatefulWidget {
    
  @override
  _AgregarFincaState createState() => _AgregarFincaState();
}

class _AgregarFincaState extends State<AgregarFinca> {
    
    
    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
 

    Finca finca = new Finca();
    final fincasBloc = new FincasBloc();

    bool _guardando = false;
    var uuid = Uuid();
        

    

    @override
    Widget build(BuildContext context) {

        final fincaData = ModalRoute.of(context).settings.arguments;    

        if (fincaData != null){
            finca = fincaData;
        }

        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: Text('Agregar Finca'),
            ),
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                            children: <Widget>[
                                _nombreFinca(),
                                SizedBox(height: 20.0,),
                                _nombreProductor(),
                                SizedBox(height: 20.0,),
                                Row(
                                    children: <Widget>[
                                        Flexible(
                                            child: _areaFinca(),
                                        ),
                                        SizedBox(width: 20.0,),
                                        Flexible(
                                            child: _medicionFinca(),
                                        ),
                                    ],
                                ),
                                SizedBox(height: 20.0,),
                                _botonsubmit()
                            ],
                        ),
                    ),
                ),
            ),
        );
    }

    Widget _nombreFinca(){
        return TextFormField(
            initialValue: finca.nombreFinca,
            autofocus: true,
            decoration: InputDecoration(
                labelText: 'Nombre de la finca'
            ),
            validator: (value){
                if(value.length < 3){
                    return 'Ingrese el nombre de la finca';
                }else{
                    return null;
                }
            },
            onSaved: (value) => finca.nombreFinca = value,
        );
        
    }

    Widget _nombreProductor(){
        return TextFormField(
            initialValue: finca.nombreProductor,
            autofocus: true,
            decoration: InputDecoration(
                labelText: 'Nombre del Productor'
            ),
            validator: (value){
                if(value.length < 3){
                    return 'Ingrese el nombre del Productor';
                }else{
                    return null;
                }
            },
            onSaved: (value) => finca.nombreProductor = value,
        );
        
    }

    Widget _areaFinca(){

        return TextFormField(
            initialValue: finca.areaFinca.toString(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Area de la finca'
            ),
            validator: (value) {

                if (utils.isNumeric(value)){
                    return null;
                }else{
                    return 'Solo números';
                }
            },
            onSaved: (value) => finca.areaFinca = double.parse(value),
        );

    }

    Widget _medicionFinca(){
        return SelectFormField(
            initialValue: finca.tipoMedida.toString(),
            labelText: 'Dimensión',
            items: selectMap.dimenciones(),
            validator: (value){
                if(value.length < 1){
                    return 'Selecione un elemento';
                }else{
                    return null;
                } 
            },

            //onChanged: (val) => print(val),
            onSaved: (value) => finca.tipoMedida = int.parse(value),
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


    


    void _submit(){

        if  ( !formKey.currentState.validate() ){
            //Cuendo el form no es valido
            return null;
        }

        formKey.currentState.save();

        setState(() {_guardando = true;});

        // print(finca.id);
        // print(finca.userid);
        // print(finca.nombreFinca);
        // print(finca.areaFinca);
        // print(finca.tipoMedida);
        if(finca.id == null){
            finca.id = uuid.v1();
            //print(finca.id);
            fincasBloc.addFinca(finca);
        }else{
            //print(finca.id);
            fincasBloc.actualizarFinca(finca);
        }

        setState(() {_guardando = false;});
        mostrarSnackbar('Registro Guardado');


        Navigator.pop(context, 'fincas');
       
        
    }

    
    void mostrarSnackbar(String mensaje){
        final snackbar = SnackBar(
            content: Text(mensaje),
            duration: Duration(microseconds: 1500),
        );

        scaffoldKey.currentState.showSnackBar(snackbar);
    }
}