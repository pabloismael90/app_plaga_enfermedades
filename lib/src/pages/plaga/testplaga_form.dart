//import 'dart:html';

import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:flutter/material.dart';

import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
//import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
//import 'package:app_plaga_enfermedades/src/utils/validaciones.dart' as utils;
import 'package:select_form_field/select_form_field.dart';
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AgregarTest extends StatefulWidget {
    
  @override
  _AgregarTestState createState() => _AgregarTestState();
}

class _AgregarTestState extends State<AgregarTest> {
    
    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
 


    Testplaga plaga = new Testplaga();
    final fincasBloc = new FincasBloc();

    bool _guardando = false;
    var uuid = Uuid();
    String idFinca ='';

    //Configuracion de FEcha
    DateTime _dateNow = new DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    String _fecha = '';
    TextEditingController _inputfecha = new TextEditingController();


    @mustCallSuper
    // ignore: must_call_super
    void initState(){
        _fecha = formatter.format(_dateNow);
        _inputfecha.text = _fecha;
        //plaga.estaciones = plaga.estaciones;
    }
    
   
    @override
    Widget build(BuildContext context) {

        fincasBloc.selectFinca();
        fincasBloc.selectParcela(idFinca);
        
       
        return StreamBuilder(
            stream: fincasBloc.fincaSelect,
            //future: DBProvider.db.getSelectFinca(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                //print(snapshot.data);
                if (!snapshot.hasData) {
                    return Scaffold(body: CircularProgressIndicator(),);
                } else {
                    
                    List<Map<String, dynamic>> _listitem = snapshot.data;
                    return Scaffold(
                        key: scaffoldKey,
                        appBar: AppBar(
                            title: Text('Agregar Prueba'),
                        ),
                        body: SingleChildScrollView(
                            child: Container(
                                padding: EdgeInsets.all(15.0),
                                child: Form(
                                    key: formKey,
                                    child: Column(
                                        children: <Widget>[
                                            
                                            _selectfinca(_listitem),
                                            SizedBox(height: 20.0,),
                                            _selectParcela(),
                                            SizedBox(height: 20.0,),
                                            _date(context),
                                            SizedBox(height: 20.0,),
                                            _medicionFinca(),
                                            SizedBox(height: 20.0,),
                                            Text('Estaciones: 3 estaciones'),
                                            Text('Plantas por estaciones: 10 plantas'),
                                            SizedBox(height: 20.0,),

                                            _botonsubmit()
                                        ],
                                    ),
                                ),
                            ),
                        ),
                    );
                }
            },
        );        
    }

    Widget _selectfinca(List<Map<String, dynamic>> _listitem){

        bool _enableFinca = _listitem.isNotEmpty ? true : false;
    
        return SelectFormField(
            labelText: 'Seleccione la finca',
            items: _listitem,
            enabled: _enableFinca,
            validator: (value){
                if(value.length < 1){
                    return 'No se selecciono una finca';
                }else{
                    return null;
                } 
            },

            onChanged: (val){
                fincasBloc.selectParcela(val);
                
            },
            onSaved: (value) => plaga.idFinca = value,
        );
    }

    Widget _selectParcela(){
        
        return StreamBuilder(
            stream: fincasBloc.parcelaSelect,
            builder: (BuildContext context, AsyncSnapshot snapshot){
                if (!snapshot.hasData) {
                    return SelectFormField(
                        initialValue: '',
                        enabled: false,
                        labelText: 'Seleccione la parcela',
                        items: [],
                    );
                }

                //print(snapshot.data);
                
                return SelectFormField(
                    initialValue: '',
                    labelText: 'Seleccione la parcela',
                    items: snapshot.data,
                    validator: (value){
                        if(value.length < 1){
                            return 'Selecione un elemento';
                        }else{
                            return null;
                        } 
                    },
                    
                    onChanged: (val) => print(val),
                    onSaved: (value) => plaga.idLote = value,
                );
            },
        );
    
    }


    Widget _date(BuildContext context){
        return TextFormField(
           
            //autofocus: true,
            controller: _inputfecha,
            enableInteractiveSelection: false,
            decoration: InputDecoration(
                labelText: 'Fecha'
            ),
            onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDate(context);
            },
            //onChanged: (value) => print('hola: $value'),
            //validator: (value){},
            onSaved: (value){
                plaga.fechaTest = value;
            } 
        );
    }

    _selectDate(BuildContext context) async{
        DateTime picked = await showDatePicker(
            context: context,

            initialDate: new DateTime.now(), 
            firstDate: new DateTime.now().subtract(Duration(days: 0)), 
            lastDate:  new DateTime(2025),
            locale: Locale('es', 'ES')
        );
        if (picked != null){
            setState(() {
                //_fecha = picked.toString();
                _fecha = formatter.format(picked);
                _inputfecha.text = _fecha;
            });
        }
        
    }

    Widget _medicionFinca(){
        return SelectFormField(
            initialValue: plaga.tipoMedida.toString(),
            labelText: 'Area de muestreo',
            items: selectMap.dimenciones(),
            validator: (value){
                if(value.length < 1){
                    return 'Dimensión';
                }else{
                    return null;
                } 
            },
            onSaved: (value) => plaga.tipoMedida = int.parse(value),
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
            //onPressed: clearTextInput,
        );
    }


    


    void _submit(){

        plaga.estaciones = 3;

        if  ( !formKey.currentState.validate() ){
            //Cuendo el form no es valido
            return null;
        }

        formKey.currentState.save();

        setState(() {_guardando = true;});

        //print(plaga.id);
        // print(plaga.idFinca);
        // print(plaga.idLote);
        // print(plaga.estaciones);
        // print(plaga.fechaTest);
        if(plaga.id == null){
            plaga.id =  uuid.v1();
            fincasBloc.addPlaga(plaga);
        }else{
            //fincasBloc.actualizarFinca(finca);
        }

        setState(() {_guardando = false;});
        //mostrarSnackbar('Registro Guardado');


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