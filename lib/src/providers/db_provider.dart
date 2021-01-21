import 'dart:io';

import 'package:app_plaga_enfermedades/src/models/planta_model.dart';
import 'package:app_plaga_enfermedades/src/models/testplaga_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


import 'package:app_plaga_enfermedades/src/models/finca_model.dart';
export 'package:app_plaga_enfermedades/src/models/finca_model.dart';
import 'package:app_plaga_enfermedades/src/models/parcela_model.dart';
export 'package:app_plaga_enfermedades/src/models/parcela_model.dart';

class DBProvider {

    static Database _database; 
    static final DBProvider db = DBProvider._();

    DBProvider._();

    Future<Database> get database async {

        if ( _database != null ) return _database;

        _database = await initDB();
        return _database;
    }

    initDB() async {

        Directory documentsDirectory = await getApplicationDocumentsDirectory();

        final path = join( documentsDirectory.path, 'herramienta.db' );

        return await openDatabase(
            path,
            version: 1,
            onOpen: (db) {},
            onCreate: ( Database db, int version ) async {
                await db.execute(
                    'CREATE TABLE Finca ('
                    ' id TEXT PRIMARY KEY,'
                    ' userid INTEGER,'
                    ' nombreFinca TEXT,'
                    ' nombreProductor TEXT,'
                    ' areaFinca REAL,'
                    ' tipoMedida INTEGER,'
                    ' nombreTecnico TEXT'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE Parcela ('
                    ' id TEXT PRIMARY KEY,'
                    ' idFinca TEXT,'
                    ' nombreLote TEXT,'
                    ' areaLote REAL,'
                    ' tipoMedida INTEGER,'
                    ' variedadCacao INTEGER,'
                    ' numeroPlanta INTEGER'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE Plaga ('
                    ' id TEXT PRIMARY KEY,'
                    ' idFinca TEXT,'
                    ' idLote TEXT,'
                    ' estaciones INTEGER,'
                    ' fechaTest TEXT,'
                    ' tipoMedida INTEGER'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE Planta ('
                    'id TEXT PRIMARY KEY,'
                    ' idPlaga TEXT,'
                    ' estacion INTEGER,'
                    ' monilia INTEGER,'
                    ' mazorcaNegra INTEGER,'
                    ' malDeMachete INTEGER,'
                    ' ardillaRata INTEGER,'
                    ' barrenador INTEGER,'
                    ' chupadores INTEGER,'
                    ' zompopos INTEGER,'
                    ' bejuco INTEGER,'
                    ' tanda INTEGER,'
                    ' deficiencia INTEGER,'
                    ' produccion INTEGER'
                    ')'
                );
            }
        
        );

    }

    //ingresar Registros
    nuevoFinca( Finca nuevaFinca ) async {
        final db  = await database;
        final res = await db.insert('Finca',  nuevaFinca.toJson() );
        return res;
    }

    nuevoParcela( Parcela nuevaParcela ) async {
        final db  = await database;
        final res = await db.insert('Parcela',  nuevaParcela.toJson() );
        return res;
    }

    nuevoTestPlaga( Testplaga nuevaPlaga ) async {
        final db  = await database;
        final res = await db.insert('Plaga',  nuevaPlaga.toJson() );
        return res;
    }

    nuevoPlanta( Planta nuevaPlanta ) async {
        final db  = await database;
        final res = await db.insert('Planta',  nuevaPlanta.toJson() );
        return res;
    }




    //Obtener registros
    Future<List<Finca>> getTodasFincas() async {

        final db  = await database;
        final res = await db.query('Finca');

        List<Finca> list = res.isNotEmpty 
                                ? res.map( (c) => Finca.fromJson(c) ).toList()
                                : [];
        return list;
    }


    Future<List<Parcela>> getTodasParcelas() async {

        final db  = await database;
        final res = await db.query('Parcela');

        List<Parcela> list = res.isNotEmpty 
                                ? res.map( (c) => Parcela.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<List<Testplaga>> getTodasTestPlaga() async {

        final db  = await database;
        final res = await db.query('Plaga');

        List<Testplaga> list = res.isNotEmpty 
                                ? res.map( (c) => Testplaga.fromJson(c) ).toList()
                                : [];
        return list;
    }

    Future<List<Planta>> getTodasPlantas() async {

        final db  = await database;
        final res = await db.query('Planta');

        List<Planta> list = res.isNotEmpty 
                                ? res.map( (c) => Planta.fromJson(c) ).toList()
                                : [];
        return list;
    }



    //REgistros por id
    Future<List<Parcela>> getTodasParcelasIdFinca(String idFinca) async{
        final db = await database;
        final res = await db.query('Parcela', where: 'idFinca = ?', whereArgs: [idFinca]);
        List<Parcela> list = res.isNotEmpty 
                    ? res.map( (c) => Parcela.fromJson(c) ).toList() 
                    : [];

        return list;            
    }

    Future<List<Planta>> getTodasPlantaIdPlaga(String idPlaga) async{
        final db = await database;
        final res = await db.query('Planta', where: 'idPlaga = ?', whereArgs: [idPlaga]);
        List<Planta> list = res.isNotEmpty 
                    ? res.map( (c) => Planta.fromJson(c) ).toList() 
                    : [];

        return list;            
    }
    
    Future<List<Planta>> getTodasPlantasIdTest(String idPlaga, int estacion) async{
        final db = await database;
        final res = await db.rawQuery("SELECT * FROM Planta WHERE idPlaga = '$idPlaga' AND estacion = '$estacion'");
        //final res = await db.query('Planta', where: 'idPlaga = ?', whereArgs: [idPlaga]);
        List<Planta> list = res.isNotEmpty 
                    ? res.map( (c) => Planta.fromJson(c) ).toList() 
                    : [];

        return list;           
    }




    //List SElect
    Future<List<Map<String, dynamic>>> getSelectFinca() async {
       
        final db  = await database;
        final res = await db.rawQuery(
            "SELECT id AS value, nombreFinca AS label FROM Finca"
        );
        List<Map<String, dynamic>> list = res.isNotEmpty ? res : [];

        //print(list);

        return list; 
    }
    
    Future<List<Map<String, dynamic>>> getSelectParcelasIdFinca(String idFinca) async{
        final db = await database;
        final res = await db.rawQuery(
            "SELECT id AS value, nombreLote AS label FROM Parcela WHERE idFinca = '$idFinca'"
        );
        List<Map<String, dynamic>> list = res.isNotEmpty ? res : [];
        return list;
                    
    }

     Future<int> countPlanta( String idPlaga, int estacion ) async {

        final db = await database;
        int count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM Planta WHERE idPlaga = '$idPlaga' AND estacion = '$estacion'"));
        return count;

    }



    

    // Actualizar Registros
    Future<int> updateFinca( Finca nuevaFinca ) async {

        final db  = await database;
        final res = await db.update('Finca', nuevaFinca.toJson(), where: 'id = ?', whereArgs: [nuevaFinca.id] );
        return res;

    }

    Future<int> updateParcela( Parcela nuevaParcela ) async {

        final db  = await database;
        final res = await db.update('Parcela', nuevaParcela.toJson(), where: 'id = ?', whereArgs: [nuevaParcela.id] );
        return res;

    }

    Future<int> updateTestPlaga( Testplaga nuevaPlaga ) async {

        final db  = await database;
        final res = await db.update('Plaga', nuevaPlaga.toJson(), where: 'id = ?', whereArgs: [nuevaPlaga.id] );
        return res;

    }
}