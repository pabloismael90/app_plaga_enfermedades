import 'package:app_plaga_enfermedades/src/models/acciones_model.dart';
import 'package:app_plaga_enfermedades/src/models/decisiones_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ReportePage extends StatefulWidget {


  @override
  _ReportePageState createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
    final List<Map<String, dynamic>>  itemPlagas = selectMap.plagasCacao();
    final List<Map<String, dynamic>>  itemSituacion = selectMap.situacionPlaga();
    final List<Map<String, dynamic>>  itemProbSuelo = selectMap.problemasPlagaSuelo();
    final List<Map<String, dynamic>>  itemProbSombra = selectMap.problemasPlagaSombra();
    final List<Map<String, dynamic>>  itemProbManejo = selectMap.problemasPlagaManejo();
    final List<Map<String, dynamic>>  _meses = selectMap.listMeses();
    final List<Map<String, dynamic>>  listSoluciones = selectMap.solucionesXmes();
    
    Widget textFalse = Text('0.00%', textAlign: TextAlign.center);

    final Map checksPrincipales = {};

    Future getdata(String idTest) async{

        List<Decisiones> listDecisiones = await DBProvider.db.getDecisionesIdTest(idTest);         
        List<Acciones> listAcciones= await DBProvider.db.getAccionesIdTest(idTest);

        return [listDecisiones, listAcciones];
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
    Widget build(BuildContext context) {
        String idTest = ModalRoute.of(context).settings.arguments;

        

        return Scaffold(
            appBar: AppBar(title: Text('Reporte'),),
            body: FutureBuilder(
                future: getdata(idTest),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    List<Widget> pageItem = List<Widget>();
                    pageItem.add(_principalData(idTest));
                    
                    pageItem.add( _plagasPrincipales(snapshot.data[0]));
                    pageItem.add( _situacionPlaga(snapshot.data[0]));
                    pageItem.add( _problemasSuelo(snapshot.data[0]));
                    pageItem.add( _problemasSombra(snapshot.data[0]));
                    pageItem.add( _problemasManejo(snapshot.data[0]));

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
        );
    }

    Widget _principalData(String plagaid){
    
        return SingleChildScrollView(
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

    Widget _plagasPrincipales(List<Decisiones> decisionesList){
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
        

        for (var item in decisionesList) {

            if (item.idPregunta == 1) {
                String label = itemPlagas.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false , 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                        
                );
            }
            
            
            
        }
        
        return SingleChildScrollView(
            child: Column(children:listPrincipales,)
        );
        
    }

    Widget _situacionPlaga(List<Decisiones> decisionesList){
        List<Widget> listPrincipales = List<Widget>();

        listPrincipales.add(
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
        

        for (var item in decisionesList) {

            if (item.idPregunta == 1) {
                String label= itemSituacion.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false , 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
            }
            
            
            
        }
        
        return SingleChildScrollView(
            child: Column(children:listPrincipales,)
        );
        
    }

    Widget _problemasSuelo(List<Decisiones> decisionesList){
        List<Widget> listPrincipales = List<Widget>();

        listPrincipales.add(
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
        

        for (var item in decisionesList) {

            if (item.idPregunta == 2) {
                String label= itemProbSuelo.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false , 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
            }
            
            
            
        }
        
        return SingleChildScrollView(
            child: Column(children:listPrincipales,)
        );
        
    }

    Widget _problemasSombra(List<Decisiones> decisionesList){
        List<Widget> listPrincipales = List<Widget>();

        listPrincipales.add(
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
        

        for (var item in decisionesList) {

            if (item.idPregunta == 3) {
                String label= itemProbSombra.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false , 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
            }
            
            
            
        }
        
        return SingleChildScrollView(
            child: Column(children:listPrincipales,)
        );
        
    }

    Widget _problemasManejo(List<Decisiones> decisionesList){
        List<Widget> listPrincipales = List<Widget>();

        listPrincipales.add(
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
        

        for (var item in decisionesList) {

            if (item.idPregunta == 4) {
                String label= itemProbManejo.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listPrincipales.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label'),
                            value: item.repuesta == 1 ? true : false , 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
            }
            
            
            
        }
        
        return SingleChildScrollView(
            child: Column(children:listPrincipales,)
        );
        
    }





}