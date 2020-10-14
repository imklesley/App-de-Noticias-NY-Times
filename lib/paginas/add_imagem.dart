import 'package:flutter/material.dart';

class AddImage extends StatelessWidget {

  TextEditingController _linkImageController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
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
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  validator: (texto) {
                    if (texto.isEmpty) return 'Insira o link da imagem que deseja adicionar!';
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
                        if(_formKey.currentState.validate())
                          Navigator.pop(context,{'tipo': 'imagem', 'valor': _linkImageController.text});

                      }),
                ),

              ],
            ),
          ),
        ));
  }
}
