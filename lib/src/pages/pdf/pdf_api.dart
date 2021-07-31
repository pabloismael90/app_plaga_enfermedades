import 'dart:convert';
import 'dart:io';
import 'package:app_plaga_enfermedades/src/models/acciones_model.dart';
import 'package:app_plaga_enfermedades/src/models/decisiones_model.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:app_plaga_enfermedades/src/providers/db_provider.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
import 'package:pdf/widgets.dart';

class PdfApi {
    

    static Future<File> generateCenteredText(
        Testplaga? testPlaga,
        Map<String,List<double>> listaCountPlaga,
    
    ) async {
        final pdf = pw.Document();
        final font = pw.Font.ttf(await rootBundle.load('assets/fonts/Museo/Museo300.ttf'));
        Finca? finca = await DBProvider.db.getFincaId(testPlaga!.idFinca);
        Parcela? parcela = await DBProvider.db.getParcelaId(testPlaga.idLote);
        List<Decisiones> listDecisiones = await DBProvider.db.getDecisionesIdTest(testPlaga.id);
        List<Acciones> listAcciones= await DBProvider.db.getAccionesIdTest(testPlaga.id);
        List<List> totalEstacion = [];
        for (var i = 0; i < 4; i++) {
            totalEstacion.add(
                [
                    await DBProvider.db.countMazorcaSana(testPlaga.id as String, i),
                    await DBProvider.db.countMazorcaEnfermas(testPlaga.id as String, i),
                    await DBProvider.db.countMazorcaDanadas(testPlaga.id  as String, i),
                ]
            );
        }
        String? labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca!.tipoMedida}')['label'];
        String? labelvariedad = selectMap.variedadCacao().firstWhere((e) => e['value'] == '${parcela!.variedadCacao}')['label'];

        
        final List<Map<String, dynamic>>  itemPlagas = selectMap.plagasCacao();
        final List<Map<String, dynamic>>  itemSituacion = selectMap.situacionPlaga();
        final List<Map<String, dynamic>>  itemProbSuelo = selectMap.problemasPlagaSuelo();
        final List<Map<String, dynamic>>  itemProbSombra = selectMap.problemasPlagaSombra();
        final List<Map<String, dynamic>>  itemProbManejo = selectMap.problemasPlagaManejo();
        final List<Map<String, dynamic>>?  _meses = selectMap.listMeses();
        final List<Map<String, dynamic>>?  listSoluciones = selectMap.solucionesXmes();

        pdf.addPage(
            
            pw.MultiPage(
                pageFormat: PdfPageFormat.a4,
                build: (context) => <pw.Widget>[
                    _encabezado('Datos de finca', font),
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                            pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                    _textoBody('Finca: ${finca!.nombreFinca}', font),
                                    _textoBody('Parcela: ${parcela!.nombreLote}', font),
                                    _textoBody('Productor: ${finca.nombreProductor}', font),
                                    finca.nombreTecnico != '' ?
                                    _textoBody('Técnico: ${finca.nombreTecnico}', font)
                                    : pw.Container(),

                                    _textoBody('Variedad: $labelvariedad', font),


                                ]
                            ),
                            pw.Container(
                                padding: pw.EdgeInsets.only(left: 40),
                                child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                        _textoBody('Área Finca: ${finca.areaFinca} ($labelMedidaFinca)', font),
                                        _textoBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)', font),
                                        _textoBody('N de plantas: ${parcela.numeroPlanta}', font),                    
                                        _textoBody('Fecha: ${testPlaga.fechaTest}', font),                    
                                    ]
                                ),
                            )
                        ]
                    ),
                    pw.SizedBox(height: 10),
                    _encabezado('Porcentaje de plantas afectadas', font),
                    pw.SizedBox(height: 10),
                    _countPlaga(listaCountPlaga,font),
                    pw.SizedBox(height: 100),
                    _datosCosecha(finca, parcela, totalEstacion, font),
                    pw.SizedBox(height: 30),
                    _pregunta('Plagas principales del momento', font, listDecisiones, 1, itemPlagas),
                    _pregunta('Situación de las plagas en la parcela', font, listDecisiones, 2, itemSituacion),
                    _pregunta('¿Porqué hay problemas de plagas?  Suelo', font, listDecisiones, 3, itemProbSuelo),
                    _pregunta('¿Porqué hay problemas de plagas?  Sombra', font, listDecisiones, 4, itemProbSombra),
                    _pregunta('¿Porqué hay problemas de plagas?  Manejo', font, listDecisiones, 5, itemProbManejo),

                    _accionesMeses(listAcciones, listSoluciones, _meses, font)                 
                    
                ],
                footer: (context) {
                    final text = 'Page ${context.pageNumber} of ${context.pagesCount}';

                    return Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(top: 1 * PdfPageFormat.cm),
                        child: Text(
                            text,
                            style: TextStyle(color: PdfColors.black, font: font),
                        ),
                    );
                },
            )
        
        );

        return saveDocument(name: 'Reporte ${finca!.nombreFinca} ${testPlaga.fechaTest}.pdf', pdf: pdf);
    }

    static Future<File> saveDocument({
        required String name,
        required pw.Document pdf,
    }) async {
        final bytes = await pdf.save();

        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$name');

        await file.writeAsBytes(bytes);

        return file;
    }

    static Future openFile(File file) async {
        final url = file.path;

        await OpenFile.open(url);
    }

    static pw.Widget _encabezado(String? titulo, pw.Font fuente){
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
                pw.Text(
                    titulo as String,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, font: fuente)
                ),
                pw.Divider(color: PdfColors.black),
            
            ]
        );

    }

    static pw.Widget _textoBody(String? contenido, pw.Font fuente){
        return pw.Container(
            padding: pw.EdgeInsets.symmetric(vertical: 3),
            child: pw.Text(contenido as String,style: pw.TextStyle(fontSize: 12, font: fuente))
        );

    }

    static pw.Widget _pregunta(String? titulo, pw.Font fuente, List<Decisiones> listDecisiones, int idPregunta, List<Map<String, dynamic>>? listaItem){

        List<pw.Widget> listWidget = [];

        listWidget.add(
            _encabezado(titulo, fuente)
        );

        for (var item in listDecisiones) {

            if (item.idPregunta == idPregunta) {
                String? label= listaItem!.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];

                listWidget.add(
                    pw.Column(
                        children: [
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                    _textoBody(label, fuente),
                                    pw.Container(
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border.all(color: PdfColors.green900),
                                            borderRadius: pw.BorderRadius.all(
                                                pw.Radius.circular(5.0)
                                            ),
                                            color: item.repuesta == 1 ? PdfColors.green900 : PdfColors.white,
                                        ),
                                        width: 10,
                                        height: 10,
                                        padding: pw.EdgeInsets.all(2),
                                        
                                    )
                                ]
                            ),
                            pw.SizedBox(height: 10)
                        ]
                    ),

                    
                    
                );
            }
        }


        return pw.Container(
            padding: pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Column(children:listWidget)
        );

    }

    static pw.Widget _datosCosecha(Finca finca, Parcela parcela, List estacionTotal, Font font){
        String? labelMedidaFinca;

        labelMedidaFinca = selectMap.dimenciones().firstWhere((e) => e['value'] == '${finca.tipoMedida}')['label'];
        return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    _encabezado('Estimación de cosecha', font),
                    _textoBody('Área Parcela: ${parcela.areaLote} ($labelMedidaFinca)', font),
                    _textoBody('Numero de plantas productivas: ${parcela.numeroPlanta}', font),
                    _textoBody('Número de mazorcas para 1 lb cacao en baba: ${finca.factorBaba}', font),
                    _textoBody('QQ de baba para producir QQ de granos seco: ${finca.factorSeco}', font),
                    pw.SizedBox(height: 10),
                    _tablaEstimacion(parcela, labelMedidaFinca, finca.factorBaba, finca.factorSeco, estacionTotal, font)
                ],  
            );

    }

    static pw.Table _countPlaga(Map<String,List<double>> listaCountPlaga, Font font){
        List<pw.TableRow> filas = [];

        filas.add(_crearFila(['Sitios','1', '2', '3', 'Total'], font, true));

        listaCountPlaga.forEach((key, value) {
            filas.add(_filaPlaga(key, value, font, false));        
        });


        return pw.Table(
            columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1:FixedColumnWidth(70),
                2:FixedColumnWidth(70),
                3:FixedColumnWidth(70),
                4:FixedColumnWidth(70),
            },
            border: TableBorder.all(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: filas
        );

    }

    static pw.TableRow _filaPlaga(String titulo, List<double> data, Font font, bool fondo){
        List<Widget> celdas = [];
        celdas.add(_cellText('$titulo', font));

        for (var item in data) {
            celdas.add(_cellText('${item.toStringAsFixed(1)} %', font));
        }
        
        return pw.TableRow(children: celdas,decoration: pw.BoxDecoration(color: fondo ? PdfColors.grey300 : PdfColors.white));

    }


    static pw.Widget _tablaEstimacion(Parcela parcela, String? labelMedidaFinca, double? factorBaba, double? factorSeco, List estacionTotal, Font font){
       
        List<TableRow> listPrincipales = [];

        listPrincipales.add(_crearFila(['', 'Sanas', 'Enfermas', 'Dañadas'], font, true));

        for (var i = 1; i < estacionTotal.length; i++) {
            listPrincipales.add( 
                _crearFila(
                    ['Número de mazorcas en Sitio $i',
                    estacionTotal[i][0].toStringAsFixed(0),
                    estacionTotal[i][1].toStringAsFixed(0),
                    estacionTotal[i][2].toStringAsFixed(0),],
                    font, 
                    false
                )
            );
        }

        listPrincipales.add( 
            _crearFila(
                ['Total # de mazorcas en 3 Sitios',
                estacionTotal[0][0].toStringAsFixed(0),
                estacionTotal[0][1].toStringAsFixed(0),
                estacionTotal[0][2].toStringAsFixed(0),],
                font, 
                false
            )
        );

        listPrincipales.add( 
            _crearFila(
                ['Número de plantas muestreadas en 3 sitios',
                10,
                10,
                10],
                font, 
                false
            )
        );

        listPrincipales.add( 
            _crearFila(
                ['Promedio # mazorcas por planta',
                (estacionTotal[0][0]/10).toStringAsFixed(1),
                (estacionTotal[0][1]/10).toStringAsFixed(1),
                (estacionTotal[0][2]/10).toStringAsFixed(1),],
                font, 
                false
            )
        );

        listPrincipales.add( 
            _crearFila(
                ['Numero de mazorcas en la parcela',
                ((estacionTotal[0][0]/10)*parcela.numeroPlanta).toStringAsFixed(1),
                ((estacionTotal[0][1]/10)*parcela.numeroPlanta).toStringAsFixed(1),
                ((estacionTotal[0][2]/10)*parcela.numeroPlanta).toStringAsFixed(1),],
                font, 
                false
            )
        );

        listPrincipales.add( 
            _crearFila(
                ['Número de mazorcas por $labelMedidaFinca',
                (((estacionTotal[0][0]/10)*parcela.numeroPlanta)/parcela.areaLote).toStringAsFixed(1),
                (((estacionTotal[0][1]/10)*parcela.numeroPlanta)/parcela.areaLote).toStringAsFixed(1),
                (((estacionTotal[0][2]/10)*parcela.numeroPlanta)/parcela.areaLote).toStringAsFixed(1),],
                font, 
                false
            )
        );

        listPrincipales.add( 
            _crearFila(
                ['Peso de baba en QQ por $labelMedidaFinca',
                (((estacionTotal[0][0]/10)*parcela.numeroPlanta)/(factorBaba!*100)).toStringAsFixed(1),
                (((estacionTotal[0][1]/10)*parcela.numeroPlanta)/(factorBaba*100)).toStringAsFixed(1),
                (((estacionTotal[0][2]/10)*parcela.numeroPlanta)/(factorBaba*100)).toStringAsFixed(1),],
                font, 
                false
            )
        );
        

        double pesoGramoEstacion1 = (((estacionTotal[0][0]/10)*parcela.numeroPlanta)/(factorBaba*100))/factorSeco;
        double pesoGramoEstacion2 = (((estacionTotal[0][1]/10)*parcela.numeroPlanta)/(factorBaba*100))/factorSeco;
        double pesoGramoEstacion3 = (((estacionTotal[0][2]/10)*parcela.numeroPlanta)/(factorBaba*100))/factorSeco;

        listPrincipales.add( 
            _crearFila(
                ['Peso de granos seco QQ por $labelMedidaFinca',
                (pesoGramoEstacion1).toStringAsFixed(1),
                (pesoGramoEstacion2).toStringAsFixed(1),
                (pesoGramoEstacion3).toStringAsFixed(1),],
                font, 
                false
            )
        );
        
        double totalPesoGrano = pesoGramoEstacion1 + pesoGramoEstacion2 + pesoGramoEstacion3;
        listPrincipales.add( 
            _crearFila(
                ['Peso de granos seco QQ por $labelMedidaFinca',
                '---',
                '${((pesoGramoEstacion2/totalPesoGrano)*100).toStringAsFixed(1)} %',
                '${((pesoGramoEstacion3/totalPesoGrano)*100).toStringAsFixed(1)} %'],
                font, 
                false
            )
        );

        return pw.Table(
            columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1:FixedColumnWidth(90),
                2:FixedColumnWidth(90),
                3:FixedColumnWidth(90),
            },
            border: TableBorder.all(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: listPrincipales
        );
    }
        
    static pw.TableRow _crearFila(List data, Font font, bool fondo){
        List<Widget> celdas = [];

        for (var item in data) {
            celdas.add(_cellText('$item', font));
        }
        
        return pw.TableRow(children: celdas,decoration: pw.BoxDecoration(color: fondo ? PdfColors.grey300 : PdfColors.white));

    }
    

    static pw.Widget _cellText( String texto, pw.Font font){
        return pw.Container(
            padding: pw.EdgeInsets.all(5),
            child: pw.Text(texto,
                style: pw.TextStyle(font: font)
            )
        );
    }

    static pw.Widget _accionesMeses( List<Acciones>? listAcciones, List<Map<String, dynamic>>?  listSoluciones, List<Map<String, dynamic>>?  _meses, Font font){
        List<pw.Widget> listPrincipales = [];

        listPrincipales.add(_encabezado('¿Qué acciones vamos a realizar y cuando?', font));
        
        
        for (var item in listAcciones!) {

                List<String?> meses = [];
                
                String? label= listSoluciones!.firstWhere((e) => e['value'] == '${item.idItem}', orElse: () => {"value": "1","label": "No data"})['label'];
                List listaMeses = jsonDecode(item.repuesta!);
                if (listaMeses.length==0) {
                    meses.add('Sin aplicar');
                }
                for (var item in listaMeses) {
                    String? mes = _meses!.firstWhere((e) => e['value'] == '$item', orElse: () => {"value": "1","label": "No data"})['label'];
                    
                    meses.add(mes);
                }
                

                listPrincipales.add(
                    pw.Column(
                        children: [
                            _textoBody('$label : ${meses.join(","+" ")}', font),
                            pw.SizedBox(height: 10)
                        ]
                    )
                                    
                    
                );
            
            
            
            
        }
        return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children:listPrincipales);
    }


}


