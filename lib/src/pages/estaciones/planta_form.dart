import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
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
    var uuid = Uuid();

    Planta planta = Planta();
    final fincasBloc = new FincasBloc();

    @override
    Widget build(BuildContext context) {

        List data = ModalRoute.of(context).settings.arguments;
        
        planta.idPlaga = data[1];
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
                                _monilia(),
                                _mazorcaNegra(),
                                _malDeMachete(),
                                _ardilla(),
                                _barrenador(),
                                _chupadores(),
                                _zompopos(),
                                _bejuco(),
                                _tanda(),
                                _deficiencia(),
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

    Widget _monilia(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Monilia', style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.monilia,
                    onChanged: (value) {
                    setState(() {
                        planta.monilia = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.monilia,
                    onChanged: (value) {
                    setState(() {
                        planta.monilia = value;
                    });
                }),   

            ],
        );
        
    }

    Widget _mazorcaNegra(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Mazorca negra',  style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.mazorcaNegra,
                    onChanged: (value) {
                    setState(() {
                        planta.mazorcaNegra = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.mazorcaNegra,
                    onChanged: (value) {
                    setState(() {
                        planta.mazorcaNegra = value;
                    });
                }),   

            ],
        );
        
    }

    Widget _malDeMachete(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Mal de machete', style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.malDeMachete,
                    onChanged: (value) {
                    setState(() {
                        planta.malDeMachete = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.malDeMachete,
                    onChanged: (value) {
                    setState(() {
                        planta.malDeMachete = value;
                    });
                }),   

            ],
        );
        
    }

    Widget _ardilla(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Ardilla/Rata', style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.ardillaRata,
                    onChanged: (value) {
                    setState(() {
                        planta.ardillaRata = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.ardillaRata,
                    onChanged: (value) {
                    setState(() {
                        planta.ardillaRata = value;
                    });
                }),   

            ],
        );
        
    }

    Widget _barrenador(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Barrenador', style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.barrenador,
                    onChanged: (value) {
                    setState(() {
                        planta.barrenador = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.barrenador,
                    onChanged: (value) {
                    setState(() {
                        planta.barrenador = value;
                    });
                }),   

            ],
        );
        
    }

    Widget _chupadores(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Chupadores', style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.chupadores,
                    onChanged: (value) {
                    setState(() {
                        planta.chupadores = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.chupadores,
                    onChanged: (value) {
                    setState(() {
                        planta.chupadores = value;
                    });
                }),   

            ],
        );
        
    }

    Widget _zompopos(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Zompopos', style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.zompopos,
                    onChanged: (value) {
                    setState(() {
                        planta.zompopos = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.zompopos,
                    onChanged: (value) {
                    setState(() {
                        planta.zompopos = value;
                    });
                }),   

            ],
        );
        
    }

    Widget _bejuco(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Bejuco', style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.bejuco,
                    onChanged: (value) {
                    setState(() {
                        planta.bejuco = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.bejuco,
                    onChanged: (value) {
                    setState(() {
                        planta.bejuco = value;
                    });
                }),   

            ],
        );
        
    }

    Widget _tanda(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Tanda', style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.tanda,
                    onChanged: (value) {
                    setState(() {
                        planta.tanda = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.tanda,
                    onChanged: (value) {
                    setState(() {
                        planta.tanda = value;
                    });
                }),   

            ],
        );
        
    }

    Widget _deficiencia(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: Text('Deficiencia', style:TextStyle(fontWeight: FontWeight.bold))),
                Radio(
                    value: 1,
                    groupValue: planta.deficiencia,
                    onChanged: (value) {
                    setState(() {
                        planta.deficiencia = value;
                    });
                }),
                Radio(
                    value: 2,
                    groupValue: planta.deficiencia,
                    onChanged: (value) {
                    setState(() {
                        planta.deficiencia = value;
                    });
                }),   

            ],
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
            //onPressed: clearTextInput,
        );
    }

    void _submit(){
        int variableVacias = 0;
        planta.monilia == null ? variableVacias++ : print('');
        planta.mazorcaNegra == null ? variableVacias++ : print('');
        planta.malDeMachete == null ? variableVacias++ : print('');
        planta.ardillaRata == null ? variableVacias++ : print('');
        planta.barrenador == null ? variableVacias++ : print('');
        planta.chupadores == null ? variableVacias++ : print('');
        planta.zompopos == null ? variableVacias++ : print('');
        planta.bejuco == null ? variableVacias++ : print('');
        planta.tanda == null ? variableVacias++ : print('');
        planta.deficiencia == null ? variableVacias++ : print('');
        planta.produccion == null ? variableVacias++ : print('');

        if  ( variableVacias !=  0){
            //print(variableVacias);
            mostrarSnackbar(variableVacias);
            return null;
        }

        formKey.currentState.save();

        setState(() {_guardando = true;});


        // print("idplaga: ${planta.idPlaga}");
        // print("estacion: ${planta.estacion}");
        // print("monilia: ${planta.monilia}");
        // print("mazorcaNegra: ${planta.mazorcaNegra}");
        // print("malDeMachete: ${planta.malDeMachete}");
        // print("ardillaRata: ${planta.ardillaRata}");
        // print("barrenador: ${planta.barrenador}");
        // print("chupadores: ${planta.chupadores}");
        // print("zompopos: ${planta.zompopos}");
        // print("bejuco: ${planta.bejuco}");
        // print("tanda: ${planta.tanda}");
        // print("deficiencia: ${planta.deficiencia}");
        // print("produccion: ${planta.produccion}");

        if(planta.id == null){
            planta.id =  uuid.v1();
            fincasBloc.addPlata(planta, planta.idPlaga, planta.estacion);
        }else{
            //fincasBloc.actualizarFinca(finca);
        }

        setState(() {_guardando = false;});
        


        Navigator.pop(context, 'estaciones');
       
        
    }


    void mostrarSnackbar(int variableVacias){
        final snackbar = SnackBar(
            content: Text('Hay $variableVacias Campos Vacios, Favor llene todo los campos'),
            duration: Duration(seconds: 2),
        );

        scaffoldKey.currentState.showSnackBar(snackbar);
    }


}