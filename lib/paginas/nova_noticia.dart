import 'dart:math';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newyorktimes_app/modelos/usuario_adm.dart';
import 'package:newyorktimes_app/paginas/add_galeria.dart';
import 'package:newyorktimes_app/paginas/add_imagem.dart';
import 'package:newyorktimes_app/paginas/add_texto.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class NovaNoticia extends StatefulWidget {
  @override
  _NovaNoticiaState createState() => _NovaNoticiaState();
}

class _NovaNoticiaState extends State<NovaNoticia> {
  //Controllers que permitem termos acesso aos dados dos campos
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  //Key que serva para validar o nosso formulario
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //a key do scaffold para podermos exiber o nossos snackbars
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Uma lista que irá guardar todos os elementos da noticia
  List<Map<String, dynamic>> elementosNoticia = [];

  //Para o Radio, 1-Social,2-Moda
  int group = null;

  //Para construir cada tipo de elemento da notícia
  Widget constroiElemento(Map<String, dynamic> elemento) {
    if (elemento['tipo'] == 'imagem') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          height: 250,
          child: Stack(
            //Usei uma stack pois gostaria de apagar os elementos na pré-vizualização
            children: [
              FadeInImage.memoryNetwork(
                //base da stack
                placeholder: kTransparentImage,
                image: elemento['valor'],
                fit: BoxFit.cover,
                height: 250,
              ),
              //
              Positioned(
                  top: 0,
                  right: 5,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    highlightColor: Colors.red,
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    child: Text(
                      'Remover',
                      style: TextStyle(color: Colors.white),
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
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    child: Text(
                      'Remover',
                      style: TextStyle(color: Colors.white),
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
    } else if (elemento['tipo'] == 'texto') {
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
    //São as instancias dos botões que aparecem somente após o textformfield "descrição"
    //Cada botão desse direciona para a página que realiza a respectiva adição de conteúdo.
    // Quando finalizar essa página retorna um dicionário contendo o tipo desse dado(image,galeria,texto) e o seu respectivo valor.
    Widget addImagem = RaisedButton(
      child: Text(
        'Imagem',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        //Redireciona para a tela AddImage, aguarda até obter um retorno
        var imagem = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddImage()));
        //Verifica-se se a var imagem é diferente de null, pois o usuário pode simplesmente ir na página e voltar sem adicionar nada
        if (imagem != null) {
          // caso seja diferente de null, adiciona-se a var imagem em elementosNoticia que será utilizado
          // para salvarmos a nossa noticia no firebase e tbm realizarmos a pré-vizualização na nossa tela
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
            'Nova Notícia',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        backgroundColor: Colors.black,
        //Usamos o scoped para buscar nosso modelo e então,chamar os métodos de criação de notícia ou
        // verificar se está carregando alguma coisa e alterna a tela para um circulaPI
        body: ScopedModelDescendant<UsuarioAdm>(
          builder: (context, child, model) {
            if (model.carregando) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            } else {
              return SingleChildScrollView(
                //Permite "scrollar" a tela novamente
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
                            //Nessa linha possuímos outras duas linhas como filhos, cada linha dessas representa um Radio ao lado de um Texto
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    //valor do elemento, caso seja 1 social, aso seja 2 moda
                                    value: 1,
                                    //inicialmente essa variável é nula, logo na exibição nenhum dos Radios estarão marcados,
                                    // assim que se tornar 1 ou 2 ele é considerado ativo
                                    groupValue: group,
                                    //Assim que pressionarmos o radio, entramos na função anônima
                                    //cor de quando está ativo
                                    activeColor: Colors.white,
                                    onChanged: (value) {
                                      //Quando adicionar dentro de group caso tenha o Radio,
                                      // o outro Rádio vai "perceber" que não possui o mesmo valor do group e vai perder o estado de ativo
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
                        //Form do título
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
                          validator: (titulo) {
                            if (titulo.isEmpty) return 'Insira um título!';
                          },
                        ),
                        //Form da descrição
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
                          validator: (descricao) {
                            if (descricao.isEmpty) return 'Insira uma descrição!';
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Adicionar elementos da notícia',
                          style: TextStyle(color: Colors.white, fontSize: 21),
                          textAlign: TextAlign.center,
                        ),
                        //Aqui entra os botões de add elementos já criados no inicio da clase
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                          child: Row(
                            //Damos um espaçamento igualmente entre os botões que estão dentro da nossa Row
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [addImagem, addGaleria, addTexto],
                          ),
                        ),

                        //PRE-VISUALIZAÇÃO
                        //Caso a lista elementosNoticia seja maior que 0, exibimos a nossa pré-vizualização
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
                                      'Pré-visualização da notícia',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 21),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  //Serve para o flutter se auto-desenhar
                                  // quando ele perceber que há mais conteúdo. Ou seja ele vai expandir ao máximo a estrutura da nossa tela
                                  child: Container(
                                    color: Colors.grey[700],
                                    child: ListView(//Permite vizualizar coisas em formato de lista
                                      children:
                                          //usa-se a função .map para pegar cada elemento da lista e construir de forma separada um outro elemento
                                          elementosNoticia.map((elemento) {
                                            //passamos o elemento da vez, para dentro do método constroiElemento, esse método vai verificar o 'tipo' daquele elemento
                                            // E retorna o elemento já construído para nossas listview
                                        return constroiElemento(elemento);
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else // Caso contrário, exibimos um container com uma msg.
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
                          height: 20,
                        ),
                        Container(
                          height: 44,
                          child: RaisedButton(
                              color: Colors.white,
                              child: Text(
                                'Enviar Notícia',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                //Ao pressionar, precisamos verificar se o form é válido(titulo e descrição)
                                if (_formKey.currentState.validate()) {
                                  //Agora verificamos se o usuário ainda não colocou o group. Ou seja se o usuário ainda não marcou nenhum dos Radios
                                  if (group == null) {
                                    //Cria-se um snackbar avisando o usuário que ele precisa escolher o tipo de noticia no topo
                                    SnackBar snackBar = SnackBar(
                                      content: Text(
                                        'Escolha o tipo de notícia!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 4),
                                    );
                                    //Exibimos o snackbar
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  }
                                  if (elementosNoticia.length == 0) {
                                    //Cria-se um snackbar avisando o usuário que ele precisa adicionar pelo menos um elemento

                                    SnackBar snackBar = SnackBar(
                                      content: Text(
                                        'Insira algum elemento de notícia',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 4),

                                    );


                                    //Exibimos o snackbar
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  } else {// Caso esteja tudo validado e preenchido podemos enviar nossa noticia
                                    //aqui é Aonde Acontece a preparação de envio

                                    //representa o tipo de notícia escolhido
                                    String tipoNoticia = group == 1 ? 'social' : 'moda'; // Caso o group seja igual a 1 ele retorna a string social, caso contrário moda

                                    //Vai gerar os tamanhos aleatórios das capas
                                    var random = new Random();

                                    Map<String, dynamic> dadosNoticia = {
                                      'altura_capa': random.nextInt(2) + 1,
                                      //Soma mais um pois a função começa do zero e não permite inserir min
                                      'largura_capa': random.nextInt(2) + 1,
                                      //Soma mais um pois a função começa do zero e não permite inserir min
                                      'data_e_horario_publicacao':Timestamp.fromDate(DateTime.now()),// timestamp é um formato em micro/mili segundos de uma respectiva data e horário
                                      'descricao': _descricaoController.text,
                                      'titulo': _tituloController.text,
                                      'noticia': elementosNoticia,
                                      'tipo_noticia': tipoNoticia
                                    };

                                    //Chamamos o método que está dentro do modelo, passamos como parâmetro o
                                    // dicionário que contém os dados da notícia, e então o método envia para o firebase
                                    model.enviaNovaNoticia(dadosNoticia);
                                    //Volta-se para página anterior, onde contem as notícias no nosso painel administrativo
                                    Navigator.pop(context);
                                  }

                                  //método de envio
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
