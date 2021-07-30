import 'dart:convert';
import 'package:app_plaga_enfermedades/src/models/acciones_model.dart';
import 'package:app_plaga_enfermedades/src/models/decisiones_model.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/pages/pdf/pdf_api.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:app_plaga_enfermedades/src/utils/constants.dart';
import 'package:app_plaga_enfermedades/src/utils/widget/varios_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

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

    Testplaga? testplaga;
    final Map checksPrincipales = {};
    

    Future getdata(Testplaga? testplaga) async{
        List<List> totalEstacion = [];

        List<Decisiones> listDecisiones = await DBProvider.db.getDecisionesIdTest(testplaga!.id);         
        List<Acciones> listAcciones= await DBProvider.db.getAccionesIdTest(testplaga.id);

        Finca? finca = await DBProvider.db.getFincaId(testplaga.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(testplaga.idLote);
        for (var i = 0; i < 4; i++) {
            totalEstacion.add(
                [
                    await _mazorcaSana(testplaga.id, i),
                    await _mazorcaEnfermas(testplaga.id, i),
                    await _mazorcaDanadas(testplaga.id, i),
                ]
            );
        }

        return [listDecisiones, listAcciones, finca, parcela , totalEstacion];
    }

    Future<double> _countPercentPlaga(String? idTest, int estacion, int idPlaga) async{
        double countPalga = await DBProvider.db.countPlagaEstacion(idTest, estacion, idPlaga);         
        return countPalga*100;
    }
    
    Future<double> _countPercentTotal(String? idTest,int idPlaga) async{
        double countPalga = await DBProvider.db.countPlagaTotal(idTest, idPlaga);         
        return countPalga*100;
    }

    
    Future<double> _countPercentProduccion(String? idTest, int estacion, int estado) async{
        double countProduccion = await DBProvider.db.countProduccion(idTest, estacion, estado);
        return countProduccion*100;
    }

    Future<double> _countPercentTotalProduccion(String? idTest, int estado) async{
        double countProduccion = await DBProvider.db.countTotalProduccion(idTest, estado);
        return countProduccion*100;
    }

    Future<int?> _mazorcaSana(String? idTest, int estacion) async{
        int? countSanas = await DBProvider.db.countMazorcaSana(idTest!, estacion);
        return countSanas;
    }
    Future<int?> _mazorcaEnfermas(String? idTest, int estacion) async{
        int? countSanas = await DBProvider.db.countMazorcaEnfermas(idTest!, estacion);
        return countSanas;
    }
    Future<int?> _mazorcaDanadas(String? idTest, int estacion) async{
        int? countSanas = await DBProvider.db.countMazorcaDanadas(idTest!, estacion);
        return countSanas;
    }
    

    @override
    Widget build(BuildContext context) {
        testplaga = ModalRoute.of(context)!.settings.arguments as Testplaga?;

        return Scaffold(
            appBar: AppBar(
                title: Text('Reporte de Decisiones'),
                actions: [
                    TextButton(
                        onPressed: () => _crearPdf(testplaga),
                        child: Row(
                            children: [
                                Icon(Icons.download, color: kwhite, size: 16,),
                                SizedBox(width: 5,),
                                Text('PDF', style: TextStyle(color: Colors.white),)
                            ],
                        )
                        
                    )
                ],
            ),
            body: FutureBuilder(
                future: getdata(testplaga),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    List<Widget> pageItem = [];
                    Finca finca = snapshot.data[2];
                    Parcela parcela = snapshot.data[3];
                    List estacionTotal = snapshot.data[4];

                    pageItem.add(_principalData(finca, parcela, testplaga!.id));
                    
                    pageItem.add(_datosCosecha(finca, parcela, testplaga!.id, estacionTotal));
                    pageItem.add( _generatePregunta(snapshot.data[0],'Plagas principales del momento', 1, itemPlagas));
                    pageItem.add( _generatePregunta(snapshot.data[0],'Situación de las plagas en la parcela', 2, itemSituacion));
                    pageItem.add( _generatePregunta(snapshot.data[0],'¿Porqué hay problemas de plagas?  Suelo', 3, itemProbSuelo));
                    pageItem.add( _generatePregunta(snapshot.data[0],'¿Porqué hay problemas de plagas?  Sombra', 4, itemProbSombra));
                    pageItem.add( _generatePregunta(snapshot.data[0],'¿Porqué hay problemas de plagas?  Manejo', 5, itemProbManejo));
                    pageItem.add( _accionesMeses(snapshot.data[1]));
                    
                    
                    return Column(
                        children: [
                            mensajeSwipe('Deslice hacia la izquierda para continuar con el reporte'),
                            Expanded(
                                
                                child: Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(15),
                                    child: Swiper(
                                        itemBuilder: (BuildContext context, int index) {
                                            return pageItem[index];
                                        },
                                        itemCount: pageItem.length,
                                        viewportFraction: 1,
                                        loop: false,
                                        scale: 1,
                                    ),
                                ),
                            ),
                        ],
                    );
                },
            ),
        );
    }

    Widget _principalData(Finca finca, Parcela parcela, String? plagaid){
        return Container(
            decoration: BoxDecoration(
                
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
                children: [
                    _dataFincas( context, finca, parcela),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                                children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: InkWell(
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    Container(                                                                    
                                                        child: Text(
                                                            "Porcentaje de plantas afectadas",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                                                        ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Icon(
                                                            Icons.info_outline_rounded,
                                                            color: Colors.green,
                                                            size: 20,
                                                        ),
                                                    ),
                                                ],
                                            ),
                                            onTap: () => _explicacion(context),
                                        ),
                                    ),
                                    Divider(),
                                    Column(
                                        children: [
                                            _encabezadoTabla(),
                                            Divider(),
                                            _countPlagas(plagaid, 1),
                                            _countProduccion(plagaid),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    )
                    
                ],
            ),
        ); 
    }

    Widget _dataFincas( BuildContext context, Finca finca, Parcela parcela ){
        String? labelMedidaFinca;
        String? labelvariedad;

        labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}')['label'];
        labelvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela.variedadCacao}')['label'];

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                encabezadoCard('${finca.nombreFinca}','Parcela: ${parcela.nombreLote}', ''),
                textoCardBody('Productor: ${finca.nombreProductor}'),
                tecnico('${finca.nombreTecnico}'),
                textoCardBody('Variedad: $labelvariedad'),
                Wrap(
                    spacing: 20,
                    children: [
                        textoCardBody('Área Finca: ${finca.areaFinca} ($labelMedidaFinca)'),
                        textoCardBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)'),
                        textoCardBody('N de plantas: ${parcela.numeroPlanta}'),
                    ],
                ),
            ],  
        );

    }
    
    Widget _encabezadoTabla(){
        return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                Expanded(child: textList('Estaciones'),),
                Container(
                    width: 50,
                    child: titleList('1'),
                ),
                Container(
                    width: 50,
                    child: titleList('2'),
                ),
                Container(
                    width: 50,
                    child: titleList('3')
                ),
                Container(
                    width: 50,
                    child: titleList('Total'),
                ),
            ],
        );
    }

    Widget _countPlagas(String? idTest, int estacion){
        List<Widget> lisItem = [];

        for (var i = 0; i < itemPlagas.length; i++) {
            String? labelPlaga = itemPlagas.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "1","label": "No data"})['label'];
            int idplga = int.parse(itemPlagas.firstWhere((e) => e['value'] == '$i', orElse: () => {"value": "100","label": "No data"})['value']);
            lisItem.add(
                Row(
                    children: [
                        Expanded(child: textList('$labelPlaga'),),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 1, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    return _labelColor(snapshot.data);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 2, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return _labelColor(snapshot.data);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentPlaga(idTest, 3, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return _labelColor(snapshot.data);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentTotal(idTest, idplga),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }

                                    return _labelColor(snapshot.data);
                                },
                            ),
                        ),
                        
                    ],
                )
            );
            lisItem.add(Divider());
        }
        return Column(children:lisItem,);
    }

    Widget _countProduccion(String? idTest){
        List<Widget> lisProd= [];

        List<String> nameProd = ['Alta','Media','Baja'];
        lisProd.add(titleList('Producción'));
        lisProd.add(Divider());
        for (var i = 0; i < nameProd.length; i++) {
            lisProd.add(

                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        Expanded(child: textList('%${nameProd[i]}'),),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 1, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 2, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentProduccion(idTest, 3, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),);
                                },
                            ),
                        ),
                        Container(
                            width: 50,
                            child: FutureBuilder(
                                future: _countPercentTotalProduccion(idTest, i+1),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                        return textFalse;
                                    }
                                    return Text('${snapshot.data.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),);
                                },
                            ),
                        ),
                    ],
                )
            );
            lisProd.add(Divider());
        }
        return Column(children:lisProd,);
    }

    Widget _labelColor(double valor){
        if (valor >= 0 && valor <= 15) {
            return Text('${valor.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green[900]),);
        } else if (valor >= 16 && valor <= 50){
            return Text('${valor.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange[900]),);
        }else{
            return Text('${valor.toStringAsFixed(0)}%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red[900]),);
        }

        
    }

    
    Widget _datosCosecha(Finca finca, Parcela parcela, String? plagaTest, List estacionTotal){
        String? labelMedidaFinca;

        labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}')['label'];
        double? factorBaba = 5;
        double? factorSeco = 3;
        return SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    // encabezadoCard('${finca.nombreFinca}','Parcela: ${parcela.nombreLote}', ''),
                    textoCardBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)'),
                    textoCardBody('Numero de plantas productivas: ${parcela.numeroPlanta}'),
                    textoCardBody('Número de mazorcas para 1 lb cacao en baba: $factorBaba'),
                    textoCardBody('QQ de baba para producir QQ de granos seco: $factorSeco'),
                    Divider(),
                    _tablaEstimacion(parcela, labelMedidaFinca, factorBaba, factorSeco, estacionTotal)
                ],  
            ),
        );

    }

    Widget _tablaEstimacion(Parcela parcela, String? labelMedidaFinca, double? factorBaba, double? factorSeco, List estacionTotal){
        
        List<Widget> listPrincipales = [];

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList(''),),
                    Container(
                        width: 70,
                        child: titleList('Sanas'),
                    ),
                    Container(
                        width: 70,
                        child: titleList('Enfermas'),
                    ),
                    Container(
                        width: 70,
                        child: titleList('Dañadas'),
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());

        for (var i = 1; i < estacionTotal.length; i++) {
            listPrincipales.add(
                Row(
                    children: [
                        Expanded(child: textList('Número de mazorcas en Sitio $i'),),
                        Container(
                            width: 70,
                            child: numberFormar(estacionTotal[i][0], '')
                        ),
                        Container(
                            width: 70,
                            child: numberFormar(estacionTotal[i][1], '')
                        ),
                        Container(
                            width: 70,
                            child: numberFormar(estacionTotal[i][2], '')
                        ),
                    ],
                ),
            );
            listPrincipales.add(Divider());
        }
        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Total # de mazorcas en 3 Sitios'),),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][0], '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][1],'')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][2], '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());
        
        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Promedio # mazorcas por planta'),),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][0]/10, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][1]/10, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(estacionTotal[0][2]/10, '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Numero de mazorcas en la parcela'),),
                    Container(
                        width: 70,
                        child: numberFormar((estacionTotal[0][0]/10)*parcela.numeroPlanta, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar((estacionTotal[0][1]/10)*parcela.numeroPlanta, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar((estacionTotal[0][2]/10)*parcela.numeroPlanta, '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());
        
        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Número de mazorcas por $labelMedidaFinca'),),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][0]/10)*parcela.numeroPlanta)/parcela.areaLote, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][1]/10)*parcela.numeroPlanta)/parcela.areaLote, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][2]/10)*parcela.numeroPlanta)/parcela.areaLote, '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Peso de baba en QQ por $labelMedidaFinca'),),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][0]/10)*parcela.numeroPlanta)/(factorBaba!*100), '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][1]/10)*parcela.numeroPlanta)/(factorBaba*100), '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(((estacionTotal[0][2]/10)*parcela.numeroPlanta)/(factorBaba*100), '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());
        double pesoGramoEstacion1 = (((estacionTotal[0][0]/10)*parcela.numeroPlanta)/(factorBaba*100))/factorSeco;
        double pesoGramoEstacion2 = (((estacionTotal[0][1]/10)*parcela.numeroPlanta)/(factorBaba*100))/factorSeco;
        double pesoGramoEstacion3 = (((estacionTotal[0][2]/10)*parcela.numeroPlanta)/(factorBaba*100))/factorSeco;

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Peso de granos seco QQ por $labelMedidaFinca'),),
                    Container(
                        width: 70,
                        child: numberFormar(pesoGramoEstacion1, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(pesoGramoEstacion2, '')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar(pesoGramoEstacion3, '')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());
        
        double totalPesoGrano = pesoGramoEstacion1 + pesoGramoEstacion2 + pesoGramoEstacion3;

        listPrincipales.add(
            Row(
                children: [
                    Expanded(child: textList('Pérdida'),),
                    Container(
                        width: 70,
                        child: titleList('---')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar((pesoGramoEstacion2/totalPesoGrano)*100, '%')
                    ),
                    Container(
                        width: 70,
                        child: numberFormar((pesoGramoEstacion3/totalPesoGrano)*100, '%')
                    ),
                ],
            ),
        );
        listPrincipales.add(Divider());

        return Column(children:listPrincipales,);
    }
    

    Widget _generatePregunta(List<Decisiones> decisionesList, String? titulo, int idPregunta, List<Map<String, dynamic>>  listaItem){
        List<Widget> listWidget = [];
        List<Decisiones> listDecisiones = decisionesList.where((i) => i.idPregunta == idPregunta).toList();
        listWidget.add(tituloDivider(titulo!));
        
        for (var item in listDecisiones) {
                String? label= listaItem.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listWidget.add(

                    Container(
                        child: CheckboxListTile(
                        title: Text('$label',
                            style: TextStyle(fontSize: 14),
                        
                        ),
                            value: item.repuesta == 1 ? true : false ,
                            activeColor: Colors.teal[900], 
                            onChanged: (value) {
                                
                            },
                        ),
                    )                  
                    
                );
        }
        return SingleChildScrollView(
            child: Column(
                children: listWidget,
            ),
        );
    }

    Widget _accionesMeses(List<Acciones> listAcciones){
        List<Widget> listPrincipales = [];

        listPrincipales.add(tituloDivider('¿Qué acciones vamos a realizar y cuando?'));
        
        
        for (var item in listAcciones) {

                List<String?> meses = [];
                String? label= listSoluciones.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];
                List listaMeses = jsonDecode(item.repuesta!);
                if (listaMeses.length==0) {
                    meses.add('Sin aplicar');
                }
                for (var item in listaMeses) {
                    String? mes = _meses.firstWhere((e) => e['value'] == '$item', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    meses.add(mes);
                }

                listPrincipales.add(

                    ListTile(
                        title: Text('$label',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(meses.join(","+" ")),
                    )
                );
        }
        return SingleChildScrollView(
            child: Column(children:listPrincipales,),
        );
    }
   

    Future _crearPdf( Testplaga? testplaga ) async{      

        Map<String,List<double>>? listaCountPlaga = {};

        for (var item in itemPlagas) {
            String key = item['label'];
            List<double> valueItem =[
                await _countPercentPlaga(testplaga!.id, 1, int.parse(item['value'])),
                await _countPercentPlaga(testplaga.id, 2, int.parse(item['value'])),
                await _countPercentPlaga(testplaga.id, 3, int.parse(item['value'])),
                await _countPercentTotal(testplaga.id, int.parse(item['value'])),
            ];

            listaCountPlaga.putIfAbsent(key, () => valueItem);
          
        }
        
        final pdfFile = await PdfApi.generateCenteredText(testplaga, listaCountPlaga);
        
        PdfApi.openFile(pdfFile);
    }


    Future<void> _explicacion(BuildContext context){

        return dialogText(
            context,
            Column(
                children: [
                    textoCardBody('•	Las observaciones sobre sobre plagas, enfermedades, cosecha y pérdida se presentan en dos pantallas.'),
                    textoCardBody('•	En la primera pantalla se indican la prevalencia de plagas y enfermedades con los siguientes datos:'),
                    textoCardBody(' o	% plantas de cacao afectadas por enfermedades'),
                    textoCardBody(' o	% plantas de cacao afectadas por los insectos y otras plagas'),
                    textoCardBody(' o	% plantas con deficiencias nutricionales'),
                    textoCardBody(' o	% plantas con alto, medio y bajo rendimiento'),
                    textoCardBody('•	Estos datos nos ayudan a entender el grado de afectación de las parcelas por las diferentes plagas y enfermedades.'),
                    textoCardBody('•	En la segunda pantalla se presenta datos sobre Número de mazorcas sanas, enfermas y dañadas en los tres sitios. En base de esto se estima # de mazorcas sanas, enfermas y dañadas en las parcelas. Con estos datos se estima la cosecha y pérdida en cosecha causada por las enfermedades y plagas.'),
                ],
            ),
            'Explicación de la tabla de datos'
        );
    } 


}