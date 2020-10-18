import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class AddGaleria extends StatefulWidget {
  @override
  _AddGaleriaState createState() => _AddGaleriaState();
}

class _AddGaleriaState extends State<AddGaleria> {
  //Controller que permite pegar o contúdo do form
  TextEditingController _linkImageController = TextEditingController();

  //Permite validar o form
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Somente para mostrar snackbar de erro, caso o usuário não insira pelo menos duas imagens
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //A lista que irá conter todos os links de cada imagem adicionada
  List<String> _galeria = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 10,
          shadowColor: Colors.grey,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: Text(
            'Adicionar Galeria',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          //Para conseguir "scrollar" a tela quando o teclado for chamado
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    cursorColor: Colors.white,
                    textAlign: TextAlign.center,
                    controller: _linkImageController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Insira o link da imagem desejada',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Link Da Imagem',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 20),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    validator: (link) {
                      if (link.isEmpty)
                        return 'Insira o link da imagem que deseja adicionar!';
                      else if (!link.contains('https://')) {
                        return 'Insira uma url válida';
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 44,
                    child: RaisedButton(
                        color: Colors.white,
                        child: Text(
                          'Adicionar Imagem à Galeria',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              //Adicionamos o link da imagem à lista _galeria
                              _galeria.add(_linkImageController.text);
                              _linkImageController.text = '';
                              //cria-se a snackbar
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  'Imagem inserida à galeria com sucesso',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 4),
                              );

                              //exibe-se a snackbar
                              _scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                          });
                        }),
                  ),
                  //DIFERENTE DOS OUTROS ADDS
                  SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Pré-vizualização da galeria',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    color: Colors.grey[700],
                    height: 230,
                    child: Carousel(
                      dotSize: 5,
                      defaultImage: Container(
                        color: Colors.black,
                        height: 100,
                        width: 220,
                        child: Center(
                          child: Text(
                            'Adicione para vizualizar',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      borderRadius: true,
                      images: _galeria
                          .map((urlImagem) => Image.network(
                                urlImagem,
                                fit: BoxFit.cover,
                                height: 230,
                              )).toList(),

                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    height: 44,
                    child: RaisedButton(
                        color: Colors.white,
                        child: Text(
                          'Adicionar Galeria à Notícia',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          //verificamos se a _galeria possui mais de um elemento, pois caso haja menos não faz sentido ser uma galeria
                          if (_galeria.length > 1) {
                            Navigator.pop(context,
                                {'tipo': 'galeria', 'valor': _galeria});
                          } else {
                            //seja menor que 1, criamos um snack que fala pro usuário inserir mais imagens
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                'Adicione mais imagens!',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 4),
                            );
                            //Exibimimos o snackbar
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
