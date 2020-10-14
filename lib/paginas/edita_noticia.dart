import 'dart:math';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newyorktimes_app/modelos/usuario_adm.dart';
import 'package:newyorktimes_app/paginas/add_galeria.dart';
import 'package:newyorktimes_app/paginas/add_imagem.dart';
import 'package:newyorktimes_app/paginas/add_texto.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class EditaNoticia extends StatefulWidget {
  final QueryDocumentSnapshot noticia;

  EditaNoticia(this.noticia);

  @override
  _EditaNoticiaState createState() => _EditaNoticiaState.fromDocument(noticia);
}

class _EditaNoticiaState extends State<EditaNoticia> {
  final QueryDocumentSnapshot noticia;
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int group;
  List<dynamic> elementosNoticia = [];

  //Criei um named construtor para inicializar os elementos da notícia;
  _EditaNoticiaState.fromDocument(this.noticia) {
    //Para o Radio, 1-Social,2-Moda
    group = noticia['tipo_noticia'] == 'social' ? 1 : 2;
    _tituloController.text = noticia['titulo'];
    _descricaoController.text = noticia['descricao'];
    elementosNoticia = noticia['noticia'];
    // print('Todas informações inseridas');
  }

  //Para construir cada tipo de elemento da notícia
  Widget buildElement(Map<String, dynamic> elemento) {
    if (elemento['tipo'] == 'imagem') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          height: 250,
          child: Stack(
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: elemento['valor'],
                fit: BoxFit.cover,
                height: 250,
              ),
              Positioned(
                  top: 0,
                  right: 5,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    highlightColor: Colors.red,
                    color: Colors.white,
                    child: Text(
                      'Remover',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {
                        elementosNoticia.remove(elemento);
                      });
                    },
                  ))
            ],
          ),
        ),
      );
    } else if (elemento['tipo'] == 'galeria') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          height: 250,
          child: Stack(
            children: [
              Carousel(
                dotSize: 5,
                defaultImage: Container(
                  color: Colors.black,
                  height: 100,
                  child: Center(
                    child: Text(
                      'Adicione para vizualizar',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                borderRadius: true,
                images: elemento['valor'].map((urlImagem) {
                  return Image.network(
                    urlImagem,
                    fit: BoxFit.cover,
                    height: 250,
                  );
                }).toList(),
              ),
              Positioned(
                  top: 0,
                  right: 5,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    highlightColor: Colors.red,
                    color: Colors.white,
                    child: Text(
                      'Remover',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {
                        elementosNoticia.remove(elemento);
                      });
                    },
                  ))
            ],
          ),
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Stack(
            children: [
              Text(
                elemento['valor'],
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Positioned(
                  top: 0,
                  right: 5,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    highlightColor: Colors.red,
                    color: Colors.white,
                    child: Text(
                      'Remover',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {
                        elementosNoticia.remove(elemento);
                      });
                    },
                  ))
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget addImagem = RaisedButton(
      child: Text(
        'Imagem',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        var imagem = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddImage()));
        if (imagem != null) {
          setState(() {
            elementosNoticia.add(imagem);
          });
        }
      },
      color: Colors.white,
      elevation: 10,
    );
    Widget addGaleria = RaisedButton(
      child: Text(
        'Galeria',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        var galeria = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddGaleria()));
        if (galeria != null) {
          setState(() {
            elementosNoticia.add(galeria);
          });
        }
      },
      color: Colors.white,
      elevation: 10,
    );
    Widget addTexto = RaisedButton(
      child: Text(
        'Texto',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        var texto = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddTexto()));
        if (texto != null) {
          setState(() {
            elementosNoticia.add(texto);
          });
        }
      },
      color: Colors.white,
      elevation: 10,
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 10,
          shadowColor: Colors.grey,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: Text(
            'Editar Notícia',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        backgroundColor: Colors.black,
        body: ScopedModelDescendant<UsuarioAdm>(
          builder: (scopedContext, child, model) {
            if (model.carregando) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo de notícia',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    activeColor: Colors.white,
                                    value: 1,
                                    groupValue: group,
                                    onChanged: (value) {
                                      setState(() {
                                        group = value;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Social',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    activeColor: Colors.white,
                                    value: 2,
                                    groupValue: group,
                                    onChanged: (value) {
                                      setState(() {
                                        group = value;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Moda',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          textAlign: TextAlign.center,
                          controller: _tituloController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Insira o título',
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: 'Titulo',
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          validator: (texto) {
                            if (texto.isEmpty) return 'Insira um título!';
                          },
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          textAlign: TextAlign.center,
                          controller: _descricaoController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: 'Insira a Descrição',
                              hintStyle: TextStyle(color: Colors.grey),
                              labelText: 'Descrição',
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white))),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          validator: (texto) {
                            if (texto.isEmpty) return 'Insira uma descrição!';
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Adicionar elementos da notícia',
                          style: TextStyle(color: Colors.white, fontSize: 21),
                          textAlign: TextAlign.start,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [addImagem, addGaleria, addTexto],
                          ),
                        ),
                        if (elementosNoticia.length > 0)
                          Container(
                            height: 300,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Pré-vizualização da notícia',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 21),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.grey[700],
                                    child: ListView(
                                      children:
                                          elementosNoticia.map((elemento) {
                                        return buildElement(elemento);
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            height: 300,
                            color: Colors.grey[700],
                            child: Center(
                              child: Text(
                                'Adicione elementos para pré-vizualizar sua notícia.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 44,
                          child: RaisedButton(
                              color: Colors.white,
                              child: Text(
                                'Atualizar Notícia',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async{
                                if (_formKey.currentState.validate()) {
                                  if (group == null) {
                                    SnackBar snackBar = SnackBar(
                                      content: Text(
                                        'Escolha o tipo de notícia!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 4),
                                    );
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  }
                                  if (elementosNoticia.length == 0) {
                                    SnackBar snackBar = SnackBar(
                                      content: Text(
                                        'Insira algum elemento de notícia',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 4),
                                    );
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  } else {
                                    //aqui é Aonde Acontece a preparação dos dados e o envio da atualização

                                    //representa o tipo de notícia escolhido
                                    String tipoNoticia =
                                        group == 1 ? 'social' : 'moda';

                                    //Vai gerar os tamanhos aleatórios das capas
                                    var random = new Random();
                                    Map<String, dynamic> dadosNoticia = {
                                      // 'altura_capa': random.nextInt(2) + 1, //Na atualização não precisa mudar as dimensões da capa
                                      //Soma mais um pois a função começa do zero e não permite inserir min
                                      // 'largura_capa': random.nextInt(2) + 1, //Na atualização não precisa mudar as dimensões da capa
                                      //Soma mais um pois a função começa do zero e não permite inserir min
                                      'data_e_horario_publicacao':
                                          Timestamp.fromDate(DateTime.now()),
                                      'descricao': _descricaoController.text,
                                      'titulo': _tituloController.text,
                                      'noticia': elementosNoticia,
                                      'tipo_noticia': tipoNoticia
                                    };

                                    //Coordena o update pelo alertDialog
                                    bool atualizar = false;
                                    AlertDialog alert = AlertDialog(
                                      title: Text('Atualizar Noticia?'),
                                      content: Text(
                                          'Você realmente deseja atualizar essa notícia?'),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                atualizar = true;
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text(
                                              'Sim',
                                            )),
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                atualizar = false;
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text('Não',
                                                style: TextStyle(
                                                    color: Colors.black)))
                                      ],
                                    );

                                    //Não estava funcionando antes, pois havia dois "context", o da classe e o do scopedModel.
                                    // Para funcionar só renomeei o context do scopedModel para scopedContext e coloquei no alert e no navigator
                                   await showDialog(
                                        context: scopedContext,
                                        builder: (BuildContext scopedContext) {
                                          return alert;
                                        });

                                    if (atualizar) {
                                      //método de envio
                                      model.atualizarNoticia(
                                          dadosNoticia, noticia.id);
                                      Navigator.pop(context);
                                    }
                                  }
                                }
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
