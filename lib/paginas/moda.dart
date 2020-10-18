import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:newyorktimes_app/paginas/noticia.dart';

class Moda extends StatelessWidget {
  //Inicializa a nossa classe com a lista de notícias que foi separada anteriormente
  final List<DocumentSnapshot> noticiasModa;

  Moda(this.noticiasModa);

  @override
  Widget build(BuildContext context) {
    //Para adaptar o tamanho de alguns widgets mais embaixo
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

    //Aqui está o plugin que permite adicionar widgets em uma grid personalizada
    return StaggeredGridView.count(
      //Define quantos "Quadros" podemos colocar na horizontal
      crossAxisCount: 3,
      padding: EdgeInsets.all(5),
      //Espaçamento entre os elementos
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      //Prepara o formato do grid do elemento
      staggeredTiles: noticiasModa.map((noticia) {
        //Constroi as dimensões do grid desse elemento, para quando esse elemento ser carregado, já estiver tudo delimitado
        return StaggeredTile.count(
            noticia['largura_capa'], noticia['altura_capa']);
      }).toList(),
      //Constrói os elementos que irão ser colocados dentro das grids anteriormente definadas
      children: noticiasModa.map((noticia) {
        return GestureDetector(//Permite executar ações em um determinado widget após tocado
          child: Stack(// Usei, pois na capa da noticia, possui uma imagem no fundo,
            // embaixo sobrepondo essa imagem existe um container preto com transparência para colocarmos o texto da descrição ou titulo
            children: [
              Hero(
                //permite animação entre widgets de mesmo id
                tag: noticia.id,
                child: FadeInImage.memoryNetwork(
                  //caso o tipo da primeira posição seja "imagem, retorna-se o valor daquele campo, ou seja uma string contendo a url
                  placeholder: kTransparentImage,
                  image: noticia['noticia'][0]['tipo'] == 'imagem'
                      ? noticia['noticia'][0]['valor']
                      : noticia['noticia'][0]['valor'][0],//caso seja tipo galeria, entramos na lista que está dentro de "valor" e pegamos a primeira posição
                  //Comportamento da imagem na tela
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),

              //Vai ser o container que possui a descrição ou o título da noticia
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
                    //caso ocorra overflow de conteúdo texto
                    overflow: TextOverflow.ellipsis,
                    //Alinhamento do texto
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
            //ao clicar no capa da noticia, é feita a navegação na forma de empilhamento de tela para a tela da notícia
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Noticia(noticia)));
          },
        );
      }).toList(),
    );
  }
}
