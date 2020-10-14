import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Noticia extends StatelessWidget {
  final DocumentSnapshot noticiaDados;

  Noticia(this.noticiaDados);

  List<Widget> contruirNoticia() {
    List<Widget> noticiaConstruida = [
      Text(
        noticiaDados['titulo'],
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w900,
            fontFamily: 'Piazzolla',
            decoration: TextDecoration.none),
      ),
      SizedBox(
        height: 10,
      )
    ];

    //Vai percorrer todos os elementos da noticia, verificar o seu tipo, construir o elemento da notícia da forma especificada e adicionar à lista "noticiaConstruida"
    for (Map<String, dynamic> elemento in noticiaDados['noticia']) {
      if (elemento['tipo'] == 'imagem') {
        var elementoConstruido = FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: elemento['valor'],
          fit: BoxFit.cover,
          height: 250,
        );
        noticiaConstruida.add(elementoConstruido);
      } else if (elemento['tipo'] == 'texto') {
        var elementoConstruido = Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            elemento['valor'],
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,fontFamily: 'Piazzolla',
                decoration: TextDecoration.none
            ),
          ),
        );
        noticiaConstruida.add(elementoConstruido);
      } else if (elemento['tipo'] == 'galeria') {
        var elementoConstruido = Container(
          height: 300,
          child: Stack(
            children: [
              Carousel(
                borderRadius: true,
                dotIncreasedColor: Colors.white,
                dotBgColor: Colors.transparent,
                dotColor: Colors.black,
                dotSize: 4,
                images: elemento['valor'].map((imagem) {
                  return FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: imagem,
                    fit: BoxFit.cover,
                    height: 500,
                  );
                }).toList(),
                autoplay: true,
                autoplayDuration: Duration(seconds: 4),
              )
            ],
          ),
        );
        noticiaConstruida.add(elementoConstruido);
      }
    }
    return noticiaConstruida;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.grey,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Notícia',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hero(
          tag: noticiaDados.id,
          child: ListView(
            children: contruirNoticia(),
          ),
        ),
      ),
    );
  }
}
