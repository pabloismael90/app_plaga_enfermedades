import 'package:app_plaga_enfermedades/src/models/finca_model.dart';
import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class DesicionesPage extends StatefulWidget {
    DesicionesPage({Key key}) : super(key: key);

    @override
    _DesicionesPageState createState() => _DesicionesPageState();
}

class _DesicionesPageState extends State<DesicionesPage> {

    
    final List<Map<String, dynamic>>  itemPlagas = selectMap.plagasCacao();
    final List<Map<String, dynamic>>  itemSituacion = selectMap.situacionPlaga();

    Widget textFalse = Text('0.00%', textAlign: TextAlign.center);
    final Map checksPrincipales = {};
    final Map checksSituacion = {};
    void checkKeys(){
        for(int i = 0 ; i < itemPlagas.length ; i ++){
            checksPrincipales[itemPlagas[i]['value']] = false;
        }
        for(int i = 0 ; i < itemSituacion.length ; i ++){
            checksSituacion[itemSituacion[i]['value']] = false;
            
        }

        
    }

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

                    return Swiper(
                        itemBuilder: (BuildContext context, int index) {
                            return pageItem[index];
                        },
                        itemCount: 3,
                        viewportFraction: 1,
                        scale: 1,
                    );

                        
                },
            ),
            floatingActionButton: _botonsubmit(),
            
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
                                print(value);
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
        print(itemSituacion.length);

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
                                print(value);
                            });
                        },
                    ),
                )                  
                    
            );
        }
        
        return Column(children:listSituacionPlaga,);
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
            onPressed:null,
            
        );
    }

    void _submit(){
        checksPrincipales.forEach((key, value) {
            print('Esta es la key : $value');
            
        });
    }

}