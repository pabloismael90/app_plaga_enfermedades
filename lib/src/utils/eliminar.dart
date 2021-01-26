// import 'package:flutter/material.dart';
// import 'package:app_plaga_enfermedades/src/models/selectValue.dart' as selectMap;
//     final List<Map<String, dynamic>>  itemPlagas = selectMap.plagasCacao();
//     final Map boleanos = {};
//     final Map radios = {};

//     void tratando(){
//         for(int i = 0 ; i < itemPlagas.length ; i ++){
//             boleanos[itemPlagas[i]['label']+i.toString()] = false;
//         }
//     }

//     Widget _lista2(){
//         List<Widget> lisItem = List<Widget>();
        

//         for(int i = 0 ; i < itemPlagas.length ; i ++){
//             //print('hola $boleanos');
//             lisItem.add(
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                         Expanded(child: Text('${itemPlagas[i]['label']}', style:TextStyle(fontWeight: FontWeight.bold))),
//                         Checkbox(
//                             value: boleanos[itemPlagas[i]['label']+i.toString()], 
//                             onChanged: (bool value){
//                                 setState(() {
//                                     boleanos[itemPlagas[i]['label']+i.toString()] = value;
//                                     //print(boleanos[itemPlagas[i]['label']+i.toString()]);
//                                 });
//                             }
//                         ),
                        
                       

//                     ],
//                 )
//             );

//         }
//         //print(boleanos['Monilia0']);
//         return Column(children:lisItem,);
//     }

//     Widget _monilia(){
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//                 Expanded(child: Text('Monilia', style:TextStyle(fontWeight: FontWeight.bold))),
//                 Radio(
//                     value: 1,
//                     groupValue: planta.monilia,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.monilia = value;
//                     });
//                 }),
//                 Radio(
//                     value: 2,
//                     groupValue: planta.monilia,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.monilia = value;
//                     });
//                 }),   

//             ],
//         );
        
//     }

//     Widget _mazorcaNegra(){
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//                 Expanded(child: Text('Mazorca negra',  style:TextStyle(fontWeight: FontWeight.bold))),
//                 Radio(
//                     value: 1,
//                     groupValue: planta.mazorcaNegra,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.mazorcaNegra = value;
//                     });
//                 }),
//                 Radio(
//                     value: 2,
//                     groupValue: planta.mazorcaNegra,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.mazorcaNegra = value;
//                     });
//                 }),   

//             ],
//         );
        
//     }

//     Widget _malDeMachete(){
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//                 Expanded(child: Text('Mal de machete', style:TextStyle(fontWeight: FontWeight.bold))),
//                 Radio(
//                     value: 1,
//                     groupValue: planta.malDeMachete,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.malDeMachete = value;
//                     });
//                 }),
//                 Radio(
//                     value: 2,
//                     groupValue: planta.malDeMachete,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.malDeMachete = value;
//                     });
//                 }),   

//             ],
//         );
        
//     }

//     Widget _ardilla(){
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//                 Expanded(child: Text('Ardilla/Rata', style:TextStyle(fontWeight: FontWeight.bold))),
//                 Radio(
//                     value: 1,
//                     groupValue: planta.ardillaRata,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.ardillaRata = value;
//                     });
//                 }),
//                 Radio(
//                     value: 2,
//                     groupValue: planta.ardillaRata,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.ardillaRata = value;
//                     });
//                 }),   

//             ],
//         );
        
//     }

//     Widget _barrenador(){
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//                 Expanded(child: Text('Barrenador', style:TextStyle(fontWeight: FontWeight.bold))),
//                 Radio(
//                     value: 1,
//                     groupValue: planta.barrenador,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.barrenador = value;
//                     });
//                 }),
//                 Radio(
//                     value: 2,
//                     groupValue: planta.barrenador,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.barrenador = value;
//                     });
//                 }),   

//             ],
//         );
        
//     }

//     Widget _chupadores(){
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//                 Expanded(child: Text('Chupadores', style:TextStyle(fontWeight: FontWeight.bold))),
//                 Radio(
//                     value: 1,
//                     groupValue: planta.chupadores,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.chupadores = value;
//                     });
//                 }),
//                 Radio(
//                     value: 2,
//                     groupValue: planta.chupadores,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.chupadores = value;
//                     });
//                 }),   

//             ],
//         );
        
//     }

//     Widget _zompopos(){
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//                 Expanded(child: Text('Zompopos', style:TextStyle(fontWeight: FontWeight.bold))),
//                 Radio(
//                     value: 1,
//                     groupValue: planta.zompopos,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.zompopos = value;
//                     });
//                 }),
//                 Radio(
//                     value: 2,
//                     groupValue: planta.zompopos,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.zompopos = value;
//                     });
//                 }),   

//             ],
//         );
        
//     }

//     Widget _bejuco(){
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//                 Expanded(child: Text('Bejuco', style:TextStyle(fontWeight: FontWeight.bold))),
//                 Radio(
//                     value: 1,
//                     groupValue: planta.bejuco,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.bejuco = value;
//                     });
//                 }),
//                 Radio(
//                     value: 2,
//                     groupValue: planta.bejuco,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.bejuco = value;
//                     });
//                 }),   

//             ],
//         );
        
//     }

//     Widget _tanda(){
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//                 Expanded(child: Text('Tanda', style:TextStyle(fontWeight: FontWeight.bold))),
//                 Radio(
//                     value: 1,
//                     groupValue: planta.tanda,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.tanda = value;
//                     });
//                 }),
//                 Radio(
//                     value: 2,
//                     groupValue: planta.tanda,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.tanda = value;
//                     });
//                 }),   

//             ],
//         );
        
//     }

//     Widget _deficiencia(){
//         return Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: <Widget>[
//                 Expanded(child: Text('Deficiencia', style:TextStyle(fontWeight: FontWeight.bold))),
//                 Radio(
//                     value: 1,
//                     groupValue: planta.deficiencia,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.deficiencia = value;
//                     });
//                 }),
//                 Radio(
//                     value: 2,
//                     groupValue: planta.deficiencia,
//                     onChanged: (value) {
//                     setState(() {
//                         planta.deficiencia = value;
//                     });
//                 }),   

//             ],
//         );
        
//     }

    
