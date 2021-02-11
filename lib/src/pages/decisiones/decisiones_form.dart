import 'package:app_plaga_enfermedades/src/models/acciones_model.dart';
import 'package:app_plaga_enfermedades/src/models/decisiones_model.dart';
import 'package:app_plaga_enfermedades/src/models/finca_model.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:uuid/uuid.dart';

class DesicionesPage extends StatefulWidget {
    DesicionesPage({Key key}) : super(key: key);

    @override
    _DesicionesPageState createState() => _DesicionesPageState();
}

class _DesicionesPageState extends State<DesicionesPage> {


    Decisiones decisiones = Decisiones();
    Acciones acciones = Acciones();
    List<Decisiones> listaDecisiones = [];
    List<Acciones> listaAcciones = [];
    String idPlagaMain = "";
    bool _guardando = false;
    var uuid = Uuid();
    
    final List<Map<String, dynamic>>  itemPlagas = selectMap.plagasCacao();
    final List<Map<String, dynamic>>  itemSituacion = selectMap.situacionPlaga();
    final List<Map<String, dynamic>>  itemProbSuelo = selectMap.problemasPlagaSuelo();
    final List<Map<String, dynamic>>  itemProbSombra = selectMap.problemasPlagaSombra();
    final List<Map<String, dynamic>>  itemProbManejo = selectMap.problemasPlagaManejo();
    final List<Map<String, dynamic>>  _meses = selectMap.listMeses();
    final List<Map<String, dynamic>>  listSoluciones = selectMap.solucionesXmes();

    Widget textFalse = Text('0.00%', textAlign: TextAlign.center);
    final Map checksPrincipales = {};
    final Map checksSituacion = {};
    final Map checksSuelo = {};
    final Map checksSombra = {};
    final Map checksManejo = {};
    final Map itemActividad = {};
    final Map itemResultado = {};

    void checkKeys(){
        for(int i = 0 ; i < itemPlagas.length ; i ++){
            checksPrincipales[itemPlagas[i]['value']] = false;
        }
        for(int i = 0 ; i < itemSituacion.length ; i ++){
            checksSituacion[itemSituacion[i]['value']] = false; 
        }
        for(int i = 0 ; i < itemProbSuelo.length ; i ++){
            checksSuelo[itemProbSuelo[i]['value']] = false;
        }
        for(int i = 0 ; i < itemProbSombra.length ; i ++){
            checksSombra[itemProbSombra[i]['value']] = false;
        }

        for(int i = 0 ; i < itemProbManejo.length ; i ++){
            checksManejo[itemProbManejo[i]['value']] = false;
        }
        for(int i = 0 ; i < listSoluciones.length ; i ++){
            itemActividad[i] = [];
            itemResultado[i] = '';
        }
    }
    


    final formKey = new GlobalKey<FormState>();

    Future<double> _countPercentPlaga(String idTest, int estacion, int idPlaga) async{
        double countPalga = await DBProvider.db.countPlagaEstacion(idTest, estacion, idPlaga);         
        return countPalga*100;
    }
    
    Future<double> _countPercentTotal(String idTest,int idPlaga) async{
        double countPalga = await DBProvider.db.countPlagaTotal(idTest, idPlaga);         
        return countPalga*100;
    }

    Future<double> _countPercentDeficiencia(String idTest, int estacion) async{
        double countDeficiencia = await DBProvider.db.countDeficiencia(idTest, estacion);      
        return countDeficiencia*100;
    }

    Future<double> _countPercentTotalDeficiencia(String idTest) async{
        double countDeficiencia = await DBProvider.db.countTotalDeficiencia(idTest);      
        return countDeficiencia*100;
    }

    Future<double> _countPercentProduccion(String idTest, int estacion, int estado) async{
        double countProduccion = await DBProvider.db.countProduccion(idTest, estacion, estado);
        return countProduccion*100;
    }

    Future<double> _countPercentTotalProduccion(String idTest, int estado) async{
        double countProduccion = await DBProvider.db.countTotalProduccion(idTest, estado);
        return countProduccion*100;
    }
    
    @override
    void initState() {
        super.initState();
        checkKeys();
    }


    @override
    Widget build(BuildContext context) {
        Testplaga plagaTest = ModalRoute.of(context).settings.arguments;
        
       
        Future _getdataFinca() async{
            Finca finca = await DBProvider.db.getFincaId(plagaTest.idFinca);
            Parcela parcela = await DBProvider.db.getParcelaId(plagaTest.idLote);
            List<Planta> plantas = await DBProvider.db.getTodasPlantaIdTest(plagaTest.id);
            return [finca, parcela, plantas];
        }

        

        return Scaffold(
            appBar: AppBar(
                title: Text('Toma de Decisiones'),
            ),
            body: FutureBuilder(
                future: _getdataFinca(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    List<Widget> pageItem = List<Widget>();
                    Finca finca = snapshot.data[0];
                    Parcela parcela = snapshot.data[1];
                    
                    pageItem.add(_principalData(finca, parcela, plagaTest.id));
                    pageItem.add(_plagasPrincipales());   
                    pageItem.add(_situacionPlaga());   
                    pageItem.add(_problemasSuelo());   
                    pageItem.add(_problemasSombra());   
                    pageItem.add(_problemasManejo());   
                    pageItem.add(_accionesMeses());   

                    return Swiper(
                        itemBuilder: (BuildContext context, int index) {
                            return pageItem[index];
                        },
                        itemCount: pageItem.length,
                        viewportFraction: 1,
                        scale: 1,
                    );

                        
                },
            ),
            floatingActionButton: _botonsubmit(plagaTest.id),
            
        );
    }

    Widget _principalData(Finca finca, Parcela parcela, String plagaid){
    
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    _dataFincas( context, finca ),
                                    _dataParcela( context, parcela ),
                                ],
                            ),

                            Expanded(
                                child: SingleChildScrollView(
                                    child: Container(
                                        color: Colors.white,
                                        child: Column(
                                            children: [
                                                Text(
                                                    '% de plantas afectadas', 
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20.0
                                                    ),
                                                ),
                                                _encabezadoTabla(),
                                                _countPlagas(plagaid, 1),
                                                _countDeficiencia(plagaid),
                                                _countProduccion(plagaid),
                                                
                                            ],
                                        ),
                                    ),
                                ),
                            )
                            
                        ],
                    ),
                );

            
    }

    Widget _dataFincas( BuildContext context, Finca finca ){
        String labelMedida;
        final item = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}');
        labelMedida  = item['label'];

        return Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width*0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Finca: ${finca.nombreFinca}', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                        ),
                    ),
                    Text(
                        'Area: ${finca.areaFinca} ($labelMedida)', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                        ),
                    ),
                    Text(
                        'Productor: ${finca.nombreProductor}', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                        ),
                    ),
                ],
            ),
        );
    }
    
    Widget _dataParcela( BuildContext context, Parcela parcela ){
        String labelMedida;
        String labelvariedad;
        

        final item = selectMap.dimenciones().firstWhere((e) => e['value'] == '${parcela.tipoMedida}');
        labelMedida  = item['label'];

        final itemvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela.tipoMedida}');
        labelvariedad  = itemvariedad['label'];
        
        return Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width*0.5,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Finca: ${parcela.nombreLote}', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                        ),
                    ),
                    Text(
                        'Area: ${parcela.areaLote} ($labelMedida)', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                        ),
                    ),

                    Text(
                        'Plantas: ${parcela.numeroPlanta} - $labelvariedad', 
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                        ),
                    ),
                    
                ],
            ),
        );
    }

    Widget _encabezadoTabla(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Expanded(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Plaga', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                ),),
                Container(
                    width: 68.0,
                    child: Text('1', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold) ,),
                ),
                Container(
                    width: 68.0,
                    child: Text('2', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                    width: 68.0,
                    child: Text('3', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                    width: 68.0,
                    child: Text('Total', textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold)),
                    //color: Colors.deepPurple,
                ),
            ],
        );
    }

    Widget _countPlagas(String idTest, int estacion){
        List<Widget> lisItem = List<Widget>();

        for (var i = 0; i < itemPlagas.length; i++) {
            String labelPlaga = itemPlagas.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            int idplga = int.parse(itemPlagas.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "100","label": "No data"})['value']);
            lisItem.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('$labelPlaga', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                        ),),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 1, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    
                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 2, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 3, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentTotal(idTest, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        
                    ],
                )
            );
        }
        return Column(children:lisItem,);
    }

    Widget _countDeficiencia(String idTest){
        
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Expanded(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Deficiencia', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                ),),
                Container(
                    width: 68.0,
                    child: FutureBuilder(
                        future: _countPercentDeficiencia(idTest, 1),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                                return textFalse;
                            }
                            
                            return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                        },
                    ),
                ),
                Container(
                    width: 68.0,
                    child: FutureBuilder(
                        future: _countPercentDeficiencia(idTest, 2),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                                return textFalse;
                            }

                            return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                        },
                    ),
                ),
                Container(
                    width: 68.0,
                    child: FutureBuilder(
                        future: _countPercentDeficiencia(idTest, 3),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                                return textFalse;
                            }

                            return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                        },
                    ),
                ),
                Container(
                    width: 68.0,
                    child: FutureBuilder(
                        future: _countPercentTotalDeficiencia(idTest),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                                return textFalse;
                            }

                            return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                        },
                    ),
                ),
                
            ],
        );

    }

    Widget _countProduccion(String idTest){
        List<Widget> lisProd= List<Widget>();

        List<String> nameProd = ['Alta','Media','Baja'];

        lisProd.add(
            Row(
                children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text('Producción', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                    )
                ],
            )
        );
        
        for (var i = 0; i < nameProd.length; i++) {
            lisProd.add(

                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('%${nameProd[i]}', textAlign: TextAlign.left, style:TextStyle(fontWeight: FontWeight.bold) ,),
                        ),),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 1, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    
                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 2, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 3, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        Container(
                            width: 68.0,
                            child: FutureBuilder(
                                future: _countPercentTotalProduccion(idTest, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return Text('${snapshot.data.toStringAsFixed(2)}%', textAlign: TextAlign.center);
                                },
                            ),
                        ),
                        
                    ],
                )
            );
        }
        return Column(children:lisProd,);
    }

    Widget _plagasPrincipales(){
        List<Widget> listPrincipales = List<Widget>();

        listPrincipales.add(
            Column(
                children: [
                    SizedBox(height: 20,),
                    Container( 
                        child: Text('Plagas principales del momento', style: TextStyle(color: Colors.black,fontSize: 20.0))
                    ),
                    SizedBox(height: 20,),
                ],
            )
            
        );

        for (var i = 0; i < itemPlagas.length; i++) {
            String labelPlaga = itemPlagas.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            //print(checksPrincipales[itemPlagas[i]['value']]);
            
            listPrincipales.add(

                Container(
                    child: CheckboxListTile(
                        title: Text('$labelPlaga'),
                        value: checksPrincipales[itemPlagas[i]['value']], 
                        onChanged: (value) {
                            setState(() {
                                checksPrincipales[itemPlagas[i]['value']] = value;
                                //print(value);
                            });
                        },
                    ),
                )                  
                    
            );
        }
        
        return Column(children:listPrincipales,);
    }

    Widget _situacionPlaga(){
        List<Widget> listSituacionPlaga = List<Widget>();

        listSituacionPlaga.add(
            Column(
                children: [
                    SizedBox(height: 20,),
                    Container( 
                        child: Text('Situación de las plagas en la parcela', style: TextStyle(color: Colors.black,fontSize: 20.0))
                    ),
                    SizedBox(height: 20,),
                ],
            )
            
        );
        

        for (var i = 0; i < itemSituacion.length; i++) {
            String labelSituacion = itemSituacion.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            
            listSituacionPlaga.add(

                Container(
                    child: CheckboxListTile(
                        title: Text('$labelSituacion'),
                        value: checksSituacion[itemSituacion[i]['value']], 
                        onChanged: (value) {
                            setState(() {
                                checksSituacion[itemSituacion[i]['value']] = value;
                                //print(value);
                            });
                        },
                    ),
                )                  
                    
            );
        }
        
        return Column(children:listSituacionPlaga,);
    }

    Widget _problemasSuelo(){
        List<Widget> listProblemasSuelo = List<Widget>();

        listProblemasSuelo.add(
            Column(
                children: [
                    SizedBox(height: 20,),
                    Container( 
                        child: Text('¿Porqué hay problemas de plagas?  Suelo', style: TextStyle(color: Colors.black,fontSize: 20.0))
                    ),
                    SizedBox(height: 20,),
                ],
            )
            
        );
        

        for (var i = 0; i < itemProbSuelo.length; i++) {
            String labelProblemaSuelo = itemProbSuelo.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            
            listProblemasSuelo.add(

                Container(
                    child: CheckboxListTile(
                        title: Text('$labelProblemaSuelo'),
                        value: checksSuelo[itemProbSuelo[i]['value']], 
                        onChanged: (value) {
                            setState(() {
                                checksSuelo[itemProbSuelo[i]['value']] = value;
                                //print(value);
                            });
                        },
                    ),
                )                  
                    
            );
        }
        
        return Column(children:listProblemasSuelo,);
    }

    Widget _problemasSombra(){
        List<Widget> listProblemasSombra = List<Widget>();

        listProblemasSombra.add(
            Column(
                children: [
                    SizedBox(height: 20,),
                    Container( 
                        child: Text('¿Porqué hay problemas de plagas?  Sombra', style: TextStyle(color: Colors.black,fontSize: 20.0))
                    ),
                    SizedBox(height: 20,),
                ],
            )
            
        );
        

        for (var i = 0; i < itemProbSombra.length; i++) {
            String labelProblemaSombra = itemProbSombra.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            
            listProblemasSombra.add(

                Container(
                    child: CheckboxListTile(
                        title: Text('$labelProblemaSombra'),
                        value: checksSombra[itemProbSombra[i]['value']], 
                        onChanged: (value) {
                            setState(() {
                                checksSombra[itemProbSombra[i]['value']] = value;
                                //print(value);
                            });
                        },
                    ),
                )                  
                    
            );
        }
        
        return Column(children:listProblemasSombra,);
    }

    Widget _problemasManejo(){
        List<Widget> listProblemasManejo = List<Widget>();

        listProblemasManejo.add(
            Column(
                children: [
                    SizedBox(height: 20,),
                    Container( 
                        child: Text('¿Porqué hay problemas de plagas?  Manejo', style: TextStyle(color: Colors.black,fontSize: 20.0))
                    ),
                    SizedBox(height: 20,),
                ],
            )
            
        );
        

        for (var i = 0; i < itemProbManejo.length; i++) {
            String labelProblemaManejo = itemProbManejo.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            
            listProblemasManejo.add(

                Container(
                    child: CheckboxListTile(
                        title: Text('$labelProblemaManejo'),
                        value: checksManejo[itemProbManejo[i]['value']], 
                        onChanged: (value) {
                            setState(() {
                                checksManejo[itemProbManejo[i]['value']] = value;
                                //print(value);
                            });
                        },
                    ),
                )
            );
        }
        
        return Column(children:listProblemasManejo,);
    }

    Widget _accionesMeses(){

        List<Widget> listaAcciones = List<Widget>();
        listaAcciones.add(
            Column(
                children: [
                    SizedBox(height: 20,),
                    Container( 
                        child: Text('¿Qué acciones vamos a realizar y cuando?', style: TextStyle(color: Colors.black,fontSize: 20.0))
                    ),
                    SizedBox(height: 20,),
                ],
            )
            
        );
        for (var i = 0; i < listSoluciones.length; i++) {
            String labelSoluciones = listSoluciones.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            
            
            listaAcciones.add(
                Container(
                    padding: EdgeInsets.all(16),
                    child: MultiSelectFormField(
                        autovalidate: false,
                        chipBackGroundColor: Colors.deepPurple,
                        chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                        dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        checkBoxActiveColor: Colors.deepPurple,
                        checkBoxCheckColor: Colors.white,
                        dialogShapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0))
                        ),
                        title: Text(
                            "$labelSoluciones",
                            style: TextStyle(fontSize: 16),
                        ),
                        validator: (value) {
                            if (value == null || value.length == 0) {
                            return 'Seleccione una o mas opciones';
                            }
                            return null;
                        },
                        dataSource: _meses,
                        textField: 'label',
                        valueField: 'value',
                        okButtonLabel: 'Aceptar',
                        cancelButtonLabel: 'Cancelar',
                        hintWidget: Text('Seleccione una o mas meses'),
                        initialValue: itemActividad[i],
                        onSaved: (value) {
                            if (value == null) return;
                                setState(() {
                                itemActividad[i] = value;
                            });
                        },
                    ),
                )
            );
        }

        return SingleChildScrollView(child: Column(children:listaAcciones,));
    }


    Widget  _botonsubmit(String idplaga){
        idPlagaMain = idplaga;
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

    _listaDecisiones(Map checksPreguntas, int pregunta){
       
        checksPreguntas.forEach((key, value) {
            final Decisiones itemDesisiones = Decisiones();
            itemDesisiones.id = uuid.v1();
            itemDesisiones.idPregunta = pregunta;
            itemDesisiones.idItem = int.parse(key);
            itemDesisiones.repuesta = value ? 1 : 0;
            itemDesisiones.idTest = idPlagaMain;

            listaDecisiones.add(itemDesisiones);
        });
    }

    _listaAcciones(){

        //print(itemActividad);
        itemActividad.forEach((key, value) {
            final Acciones itemAcciones = Acciones();
            itemAcciones.id = uuid.v1();
            itemAcciones.idItem = key;
            itemAcciones.repuesta = value.toString();
            itemAcciones.idTest = idPlagaMain;
            
            listaAcciones.add(itemAcciones);
        });
    }

    void _submit(){
        setState(() {_guardando = true;});
        _listaDecisiones(checksPrincipales, 1);
        _listaDecisiones(checksSituacion, 2);
        _listaDecisiones(checksSuelo, 3);
        _listaDecisiones(checksSombra, 4);
        _listaDecisiones(checksManejo, 5);
        _listaAcciones();

        listaDecisiones.forEach((decision) {
        //     print("Id Pregunta: ${element.idPregunta}");
        //     print("Id item: ${element.idItem}");
        //     print("Id Respues: ${element.repuesta}");
        //     print("Id prueba: ${element.idTest}");
            DBProvider.db.nuevaDecision(decision);
        });

        
        
        listaAcciones.forEach((accion) {
        //     print("Id item: ${element.idItem}");
        //     print("Id Respues: ${element.repuesta}");
        //     print("Id prueba: ${element.idTest}");
            DBProvider.db.nuevaAccion(accion);
        });
        setState(() {_guardando = false;});

        Navigator.pop(context, 'estaciones');
    }

}