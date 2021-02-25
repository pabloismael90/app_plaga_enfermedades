import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatelessWidget {
  const ViewImage({Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        
        List dataRoute = ModalRoute.of(context).settings.arguments;
        String nombre = dataRoute[0];
        String urlImg = dataRoute[1];
        int index = dataRoute[2];
        Size size = MediaQuery.of(context).size;
        return Scaffold(
            appBar: AppBar(),
            
            body: Column(
                children: [
                    Expanded(
                        child: Hero(
                            tag: index,
                            child: PhotoView(
                                imageProvider: AssetImage(urlImg),
                                
                                minScale: PhotoViewComputedScale.contained * 0.8,
                                maxScale: PhotoViewComputedScale.covered * 1.8,
                                initialScale: PhotoViewComputedScale.contained,
                            ),
                        )
                    ),
                    Container(
                        color: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            child: Container(
                                height: size.height * 0.08,
                                color: Colors.white,
                                child: Center(child: Text(nombre),),
                                    
                            ),
                        ),
                    ),
                ],
            )

        );
    }
}