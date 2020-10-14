import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class AddGaleria extends StatefulWidget {
  @override
  _AddGaleriaState createState() => _AddGaleriaState();
}

class _AddGaleriaState extends State<AddGaleria> {
  TextEditingController _linkImageController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _galeria = [];


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



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
                    validator: (texto) {
                      if (texto.isEmpty)
                        return 'Insira o link da imagem que deseja adicionar!';
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 54,
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
                              _galeria.add(_linkImageController.text);
                              _linkImageController.text = '';
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                  'Imagem inserida com sucesso',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 4),
                              );
                              _scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                          });
                        }),
                  ),
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
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    height: 54,
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
                          if (_galeria.length > 1) {
                            Navigator.pop(context,
                                {'tipo': 'galeria', 'valor': _galeria});
                          } else {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                'Adicione mais uma imagem !',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 4),
                            );
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
