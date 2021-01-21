import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/parcela_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



import 'package:app_plaga_enfermedades/src/utils/validaciones.dart' as utils;
import 'package:select_form_field/select_form_field.dart';
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:uuid/uuid.dart';


class AgregarParcela extends StatefulWidget {
  AgregarParcela({Key key}) : super(key: key);

  @override
  _AgregarParcelaState createState() => _AgregarParcelaState();
}

class _AgregarParcelaState extends State<AgregarParcela> {

    final formKey = GlobalKey<FormState>();

    Parcela parcela = new Parcela();
    final fincasBloc = new FincasBloc();

    bool _guardando = false;
    var uuid = Uuid();

    @override
    Widget build(BuildContext context) {


        String fincaid ;
        var dataRoute = ModalRoute.of(context).settings.arguments;

        //print(dataRoute);

        if (dataRoute.runtimeType == String) {
            fincaid = dataRoute;
        } else {
            if (dataRoute != null){
                parcela = dataRoute;
                fincaid = parcela.idFinca;
            }
            
        }

        //print(fincaid);
        
        return Scaffold(
            appBar: AppBar(
                title: Text('Agregar Parcela'),
            ),
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                            children: <Widget>[
                                _nombreParcela(fincaid),
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
                                Row(
                                    children: <Widget>[
                                        Flexible(
                                            child: _variedadCacao(),
                                        ),
                                        SizedBox(width: 20.0,),
                                        Flexible(
                                            child: _numeroPlanta(),
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
    Widget _nombreParcela( String fincaid ){
        //print('id de finca: $fincaid');
        return TextFormField(
            initialValue: parcela.nombreLote,
            //autofocus: true,
            decoration: InputDecoration(
                labelText: 'Nombre de la parcela'
            ),
            validator: (value){
                if(value.length < 3){
                    return 'Ingrese el nombre de la Parcela';
                }else{
                    return null;
                }
            },
            onSaved: (value){
                parcela.idFinca = fincaid;
                parcela.nombreLote = value;
            } 
        );
        
    }
    
    Widget _areaFinca(){

        return TextFormField(
            initialValue: parcela.areaLote.toString(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelText: 'Área de la parcela'
            ),
            validator: (value) {

                if (utils.isNumeric(value)){
                    return null;
                }else{
                    return 'Solo números';
                }
            },
            onSaved: (value) => parcela.areaLote = double.parse(value),
        );

    }

    Widget _medicionFinca(){
        return SelectFormField(
            initialValue: parcela.tipoMedida.toString(),
            labelText: 'Unidad',
            items: selectMap.dimenciones(),
            validator: (value){
                if(value.length < 1){
                    return 'Dimensión';
                }else{
                    return null;
                } 
            },

            //onChanged: (val) => print(val),
            onSaved: (value) => parcela.tipoMedida = int.parse(value),
        );
    }

    Widget _variedadCacao(){
        return SelectFormField(
            initialValue: parcela.variedadCacao.toString(),
            labelText: 'Variedad',
            items: selectMap.variedadCacao(),
            validator: (value){
                if(value.length < 1){
                    return 'Selecione variedad';
                }else{
                    return null;
                } 
            },

            //onChanged: (val) => print(val),
            onSaved: (value) => parcela.variedadCacao = int.parse(value),
        );
    }

    Widget _numeroPlanta(){

        return TextFormField(
            initialValue: parcela.numeroPlanta.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
            ], 
            decoration: InputDecoration(
                labelText: 'Número de plantas'
            ),
            validator: (value) {

                final isDigitsOnly = int.tryParse(value);
                return isDigitsOnly == null
                    ? 'Solo números enteros'
                    : null;

            },
            onSaved: (value) => parcela.numeroPlanta = int.parse(value),
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
            //onPressed: null,
            onPressed:(_guardando) ? null : _submit,
           // onPressed: _submit,
        );
    }
    

    void _submit( ){

        

        if  ( !formKey.currentState.validate() ){
            
            //Cuendo el form no es valido
            return null;
        }
        

        formKey.currentState.save();

        setState(() {_guardando = true;});

        // print(parcela.id);
        // print(parcela.idFinca);
        //print(parcela.nombreLote);
        //print(parcela.areaLote);
        //print(parcela.tipoMedida);
        if(parcela.id == null){
            parcela.id = uuid.v1();
            fincasBloc.addParcela(parcela, parcela.idFinca);
        }else{
            fincasBloc.actualizarParcela(parcela, parcela.idFinca);
        }
        //fincasBloc.addParcela(parcela);
        //DBProvider.db.nuevoParcela(parcela);

        setState(() {_guardando = false;});
        


        Navigator.pop(context, 'fincas');
       
        
    }
}