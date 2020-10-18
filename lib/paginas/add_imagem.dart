import 'package:flutter/material.dart';

class AddImage extends StatelessWidget {

  //O controller que permite pegarmos os dados textformfield
  TextEditingController _linkImageController = TextEditingController();

  //Key que permite verificar a validade do nosso campo em questão
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //elevação da appbar
          elevation: 10,
          //caso elevação maior que 0, mostra uma cor embaixo da appbar. Essa cor é o shadowColor
          shadowColor: Colors.grey,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: Text(
            'Adicionar Imagem',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        backgroundColor: Colors.black,
        body: Form(
          key: _formKey,
          child: Padding(// Para dá espaçamento no widget
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
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  validator: (String link) {
                    if (link.isEmpty) return 'Insira o link da imagem que deseja adicionar!';
                    else if(!link.contains('https://')){
                      return 'Insira uma url válida';
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Container(height: 44,
                  child: RaisedButton(
                      color: Colors.white,
                      child: Text(
                        'Adicionar Imagem',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if(_formKey.currentState.validate()) {
                          //Caso esteja tudo okay com o nosso form, então retornamos para página anterior com os dados inseridos. Isso em forma de map.
                          Navigator.pop(context,{'tipo': 'imagem', 'valor': _linkImageController.text});
                        }

                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
