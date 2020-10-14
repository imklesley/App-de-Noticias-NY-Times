import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:newyorktimes_app/paginas/noticia.dart';

class Moda extends StatelessWidget {
  final List<DocumentSnapshot> noticiasModa;

  Moda(this.noticiasModa);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (noticiasModa.length == 0)
      return Container(
        child: Center(
          child: Text(
            'Não há notícias ainda. Aguarde!',
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      );

    return StaggeredGridView.count(
      padding: EdgeInsets.all(5),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      crossAxisCount: 2,
      staggeredTiles: noticiasModa.map((noticia) {
        if (noticia['tipo_noticia'] == 'moda') {
          return StaggeredTile.count(
              noticia['largura_capa'], noticia['altura_capa']);
        } else
          return null;
      }).toList(),
      children: noticiasModa.map((noticia) {
        if (noticia['tipo_noticia'] == 'moda') {
          return GestureDetector(
            child: Stack(
              children: [
                Hero(
                  tag: noticia.id,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: noticia['noticia'][0]['tipo'] == 'imagem'
                        ? noticia['noticia'][0]['valor']
                        : noticia['noticia'][0]['valor'][0],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 0,

                  //se a largura da imagem for igual a dois, coloca a descrição da noticia na tile, caso contrário usa-se o título
                  child: noticia['largura_capa'] == 2
                      ? Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(10),
                          color: Color.fromRGBO(0, 0, 0, .7),
                          height: 75,
                          width: size.width,
                          child: Text(
                            noticia['descricao'],
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18),
                          ),
                        )
                      : Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(10),
                          color: Color.fromRGBO(0, 0, 0, .7),
                          height: 75,
                          width: size.width / 2 + 10,
                          child: Text(
                            noticia['titulo'],
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18),
                          ),
                        ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Noticia(noticia)));
            },
          );
        } else
          return null;
      }).toList(),
    );
  }
}
