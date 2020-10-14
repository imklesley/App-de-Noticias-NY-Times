import 'package:flutter/material.dart';
import 'package:newyorktimes_app/modelos/usuario_adm.dart';
import 'package:scoped_model/scoped_model.dart';

class Cadastro extends StatelessWidget {
  //Valida o formulário
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Controladores de cada campo do formulário
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //Caso o cadastro ocorra bem
    VoidCallback sucesso() {
      SnackBar snackBar = SnackBar(
        content: Text('Usuário Criado com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
      Navigator.popUntil(context, (route) => route.isFirst);
    }

    //Caso ocorra algum erro no cadastro
    VoidCallback falhou() {
      SnackBar snackBar = SnackBar(
        content: Text('Erro ao criar usuário!'),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        )),
        duration: Duration(seconds: 3),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        actions: [
          FlatButton(
            child: Text(
              'Ja tenho conta',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            highlightColor: Colors.grey,
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Image.asset(
                      'config_app/imagens/logo_simplificado_branco.png',
                      fit: BoxFit.cover,
                      height: 130,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Cadastro',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        height: 485,
                        width: 350,
                        child: ScopedModelDescendant<UsuarioAdm>(
                          builder: (context, child, model) {
                            if (model.carregando) {
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              );
                            }
                            return Form(
                              key: _formKey,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 20, 10),
                                      child: TextFormField(
                                        controller: _nomeController,
                                        textAlign: TextAlign.center,
                                        cursorColor: Colors.black,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                        decoration: InputDecoration(
                                            labelText: 'Nome',
                                            labelStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                            icon: Icon(
                                              Icons.person_outline,
                                              color: Colors.black,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black))),
                                        validator: (nome) {
                                          if (nome.isEmpty)
                                            return 'Insira seu nome';
                                          return null;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 20, 10),
                                      child: TextFormField(
                                        keyboardType: TextInputType.emailAddress,
                                        controller: _emailController,
                                        textAlign: TextAlign.center,
                                        cursorColor: Colors.black,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                        decoration: InputDecoration(
                                            labelText: 'E-mail',
                                            labelStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                            icon: Icon(
                                              Icons.email_outlined,
                                              color: Colors.black,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black))),
                                        validator: (email) {
                                          if (email.isEmpty)
                                            return 'Insira seu e-mail';
                                          else if (!email.contains('@'))
                                            return 'Email inválido !';
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 5, 20, 0),
                                      child: TextFormField(
                                        controller: _senhaController,
                                        textAlign: TextAlign.center,
                                        cursorColor: Colors.black,
                                        obscureText: true,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700),
                                        decoration: InputDecoration(
                                            labelText: 'Senha',
                                            labelStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                            icon: Icon(
                                              Icons.lock_outline,
                                              color: Colors.black,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black))),
                                        validator: (senha) {
                                          if (senha.isEmpty)
                                            return 'Insira sua senha !';
                                          else if (senha.length < 6)
                                            return 'Senha inválida !';
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Container(
                                        height: 44,
                                        width: 150,
                                        child: RaisedButton(
                                          color: Colors.black,
                                          child: Text(
                                            'Cadastrar',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                          onPressed: () {
                                            //quando o usuário pressionar o btn para cadastrar e feito uma verificação nos campos do form, caso esteja tudo validado ele procede a execução
                                            if (_formKey.currentState
                                                .validate()) {
                                              //Cria um dicionário que vai conter os dados do usuário
                                              Map<String, dynamic> dados = {
                                                'email': _emailController.text,
                                                'nome': _nomeController.text
                                              };
                                              //Tentativa de cadastro
                                              model.cadastrar(
                                                  dados: dados,
                                                  senha: _senhaController.text,
                                                  sucesso: sucesso,
                                                  falhou: falhou);
                                            }
                                          },
                                        ))
                                  ]),
                            );
                          },
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
