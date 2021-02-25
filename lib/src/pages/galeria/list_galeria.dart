import 'dart:convert';
import 'dart:io';

import 'package:app_plaga_enfermedades/src/utils/widget/titulos.dart';
import 'package:flutter/material.dart';

class GaleriaImagenes extends StatefulWidget {
    GaleriaImagenes({Key key}) : super(key: key);

    @override
    _GaleriaImagenesState createState() => _GaleriaImagenesState();
}


List someImages;
List nameImages;
Future _initImages(BuildContext context) async {
    // >> To get paths you need these 2 lines
    final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines
    
    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/galeria/'))
        .where((String key) => key.contains('.jpg'))
        .toList();
    
    return imagePaths;
}

class _GaleriaImagenesState extends State<GaleriaImagenes> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(),
            body: FutureBuilder(
                future: _initImages(context),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                    }
                    String name;

                    someImages = snapshot.data;

                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                            children: [
                                TitulosPages(titulo: 'Galería de Imágenes'),
                                Divider(),
                                Expanded(
                                    child: GridView.builder(
                                        itemCount: someImages.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing:5,
                                        ),
                                        itemBuilder: (BuildContext context, int index) {
                                            return GestureDetector(
                                                child: Hero(
                                                    tag: index,
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            image: DecorationImage(
                                                                image: AssetImage(someImages[index]),
                                                                fit: BoxFit.cover
                                                            )
                                                        ),
                                                    ),
                                                ),
                                                onTap: (){
                                                    File file = new File(someImages[index]);
                                                    name = file.path.split('/').last;
                                                    //print(name);
                                                    Navigator.pushNamed(context, 'viewImg', arguments: [name,someImages[index], index] );
                                                },
                                            );
                                        },
                                    )
                                
                                ),
                            ],
                        ),
                    );
                    
                },
            )
        );
    }


    
}