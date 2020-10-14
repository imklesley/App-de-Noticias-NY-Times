import 'package:flutter/material.dart';
import 'package:newyorktimes_app/modelos/usuario_adm.dart';
import 'package:newyorktimes_app/paginas/cadastro.dart';
import 'package:scoped_model/scoped_model.dart';

class Login extends StatelessWidget {
  //Valida o formulário
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Controladores de cada campo do formulário
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  //Serve para fazer alterações no estado do widget scaffold, foi usado para exibir snackbars
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //Caso o cadastro ocorra bem
    VoidCallback sucesso() {
      SnackBar snackBar = SnackBar(
        content: Text('Usuário Entrou !'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
      Future.delayed(Duration(seconds: 1)).then((value) {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    }

    //Caso ocorra algum erro no cadastro
    VoidCallback falhou() {
      SnackBar snackBar = SnackBar(
        content: Text('Erro ao entrar!'),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        )),
        duration: Duration(seconds: 3),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
      Future.delayed(Duration(seconds: 3)).then((value) => null);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        actions: [
          FlatButton(
            child: Text(
              'Criar Conta',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cadastro()));
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
                      'Login',
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
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      height: 380,
                      width: 350,
                      child: ScopedModelDescendant<UsuarioAdm>(
                        builder: (context, child, model) {
                          if (model.carregando) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            );
                          } else {
                            return Form(
                              key: _formKey,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
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
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: FlatButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              if (_emailController
                                                  .text.isEmpty) {
                                                SnackBar snackBar = SnackBar(
                                                  content: Text(
                                                      'Insira seu email para recuperar senha.'),
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                    Radius.circular(12.0),
                                                  )),
                                                  duration:
                                                      Duration(seconds: 3),
                                                );

                                                _scaffoldKey.currentState
                                                    .showSnackBar(snackBar);
                                              } else {
                                                SnackBar snackBar = SnackBar(
                                                  content: Text(
                                                      'Um link de recuperação foi enviado para seu email.'),
                                                  backgroundColor: Colors.green,
                                                  duration:
                                                      Duration(seconds: 3),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(12.0),
                                                    ),
                                                  ),
                                                );
                                                model.recuperarSenha(
                                                    _emailController.text);
                                                _scaffoldKey.currentState
                                                    .showSnackBar(snackBar);
                                                Future.delayed(
                                                        Duration(seconds: 3))
                                                    .then((value) {});
                                              }
                                            },
                                            child: Text('Esquecí minha senha')),
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
                                            'Entrar',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                          onPressed: () {
                                            //quando o usuário pressionar o btn para entrar e feito uma verificação nos campos do form, caso esteja tudo validado ele procede a execução
                                            if (_formKey.currentState
                                                .validate()) {
                                              //tentativa de login
                                              model.entrar(
                                                  email: _emailController.text,
                                                  senha: _senhaController.text,
                                                  sucesso: sucesso,
                                                  falhou: falhou);
                                            }
                                          },
                                        ))
                                  ]),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
