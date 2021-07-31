import 'package:app_plaga_enfermedades/src/bloc/fincas_bloc.dart';
import 'package:app_plaga_enfermedades/src/models/existePlaga_model.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/utils/validaciones.dart' as utils;
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/button.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    int? countPlanta = 0;
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

        List data = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
        
        planta.idTest = data[1];
        planta.estacion = data[0] ;
        countPlanta = data[2]+1;
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text('Planta $countPlanta sitio ${planta.estacion}'),),
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                            children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                            Expanded(child: textList('Lista Plagas')),
                                            Container(
                                                width: 60,
                                                child: titleList('Si'),
                                            ),
                                            Container(
                                                width: 60,
                                                child: titleList('No'),
                                            ),
                                        ],
                                    ),
                                ),
                                Divider(),
                                _plagasList(),
                                Divider(),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Expanded(child: Container(),),
                                        Container(
                                            width: 60,
                                            child: titleList('Alta')
                                        ),
                                        Container(
                                            width: 60,
                                            child: titleList('Media')
                                        ),
                                        Container(
                                            width: 60,
                                            child: titleList('Baja')
                                        ),
                                    ],
                                ),
                                _produccion(),
                                Divider(),
                                SizedBox(height: 20,),
                                textList('Número de mazorcas'),
                                Divider(),
                                Row(
                                    children: [
                                        Flexible(child: _mazorcasSanas()),
                                        SizedBox(width: 20,),
                                        Flexible(child: _mazorcasEnfermas()),

                                    ],
                                ),
                                _mazorcasDanadas(),
                                SizedBox(height: 20,),
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
                
                String? labelPlaga = itemPlagas.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "1","label": "No data"})['label'];
                int idPlaga = int.parse(itemPlagas.firstWhere((e) => e['value'] == '$index', orElse: () => {"value": "100","label": "No data"})['value']);
            
                return Column(
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                                Expanded(child: textList('$labelPlaga')),
                                Container(
                                    width: 60,
                                    child: Radio(
                                        value: '1',
                                        groupValue: radios[itemPlagas[idPlaga]['value']],
                                        onChanged: (dynamic value){
                                            setState(() {
                                                radios[itemPlagas[idPlaga]['value']] = value;
                                            });
                                        },
                                        activeColor: Colors.teal[900],
                                    ),
                                ),
                                Container(
                                    width: 60,
                                    child: Radio(
                                        value:'2',
                                        groupValue: radios[itemPlagas[idPlaga]['value']],
                                        onChanged: (dynamic value){
                                            setState(() {
                                                radios[itemPlagas[idPlaga]['value']] = value;
                                            });
                                        },
                                        activeColor: Colors.red[900],
                                    ),
                                ),
                            

                            ],
                        ),
                    ],
                );
        
            },
            shrinkWrap: true,
            itemCount: itemPlagas.length,
            physics: NeverScrollableScrollPhysics(),
        ); 
    }

    Widget _produccion(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                Expanded(child: textList('Producción')),
                Container(
                    width: 60,
                    child: Radio(
                        value: 1,
                        groupValue: planta.produccion,
                        onChanged: (dynamic value) {
                            setState(() {
                                planta.produccion = value;
                            });
                        },
                        activeColor: Colors.teal[900],
                    ),
                ),
                Container(
                    width: 60,
                    child: Radio(
                        value: 2,
                        groupValue: planta.produccion,
                        onChanged: (dynamic value) {
                            setState(() {
                                planta.produccion = value;
                            });
                        },
                        activeColor: Colors.orange[900],
                    ),
                ),
                Container(
                    width: 60,
                    child: Radio(
                        value: 3,
                        groupValue: planta.produccion,
                        onChanged: (dynamic value) {
                            setState(() {
                                planta.produccion = value;
                            });
                        },
                        activeColor: Colors.red[900],
                    ),
                ),   
            ],
        );
        
    }

    Widget _mazorcasSanas(){
        return TextFormField(
            initialValue: planta.sanas == null ? '' : planta.sanas.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
            ],
            maxLength: 3,
            decoration: InputDecoration(
                labelText: 'Sanas'
            ),
            validator: (value) => utils.enteroSiCEro(value),
            onSaved: (value) => planta.sanas = int.parse(value!),
        );
    }

    Widget _mazorcasEnfermas(){
        return TextFormField(
            initialValue: planta.enfermas == null ? '' : planta.enfermas.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
            ],
            maxLength: 3,
            decoration: InputDecoration(
                labelText: 'Enfermas'
            ),
            validator: (value) => utils.enteroSiCEro(value),
            onSaved: (value) => planta.enfermas = int.parse(value!),
        );
    }

    Widget _mazorcasDanadas(){
        return TextFormField(
            initialValue: planta.danadas == null ? '' : planta.danadas.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
            ],
            maxLength: 3,
            decoration: InputDecoration(
                labelText: 'Dañadas'
            ),
            validator: (value) => utils.enteroSiCEro(value),
            onSaved: (value) => planta.danadas = int.parse(value!),
        );
    }



    Widget  _botonsubmit(){
        return ButtonMainStyle(
            title: 'Guardar',
            icon: Icons.save,
            press:(_guardando) ? null : _submit,
        );
    }


    _listaPlagas(){

        radios.forEach((key, value) {
            final ExistePlaga itemPlaga = ExistePlaga();
            itemPlaga.id = uuid.v1();
            itemPlaga.idPlanta = planta.id;
            itemPlaga.idPlaga = int.parse(key);
            itemPlaga.existe = int.parse(value);


            listaPlagas.add(itemPlaga);
        });
        
    }

    void _submit(){
        if  ( !formKey.currentState!.validate() ){
            //Cuendo el form no es valido
            return null;
        }
        
        variableVacias = 0;
        radios.forEach((key, value) {
            if (value == '-1') {
                variableVacias ++;
            } 
        });


        if (planta.produccion == 0) {
            variableVacias ++;
        }


        if  ( variableVacias !=  0){
            mostrarSnackbar('Hay $variableVacias Campos Vacios, Favor llene todo los campos', context);
            return null;
        }

        formKey.currentState!.save();

        setState(() {_guardando = true;});

        
        if(planta.id == null){
            planta.id =  uuid.v1();
            _listaPlagas();
            
            fincasBloc.addPlata(planta, planta.idTest, planta.estacion);

            listaPlagas.forEach((item) {
                DBProvider.db.nuevoExistePlagas(item);
            });
            mostrarSnackbar('Registro planta guardado', context);
        }
         
        setState(() {_guardando = false;});

        Navigator.pop(context, 'estaciones');
       
        
    }


   


}