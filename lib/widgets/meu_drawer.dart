import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newyorktimes_app/modelos/usuario_adm.dart';
import 'package:newyorktimes_app/paginas/login.dart';
import 'package:newyorktimes_app/paginas/painel_administrativo.dart';
import 'package:scoped_model/scoped_model.dart';

class MeuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UsuarioAdm>(
      builder: (context, child, model) {
        return Drawer(
          child: SafeArea(
            // adapta a tela para as dimensões apropriadas do
            // aparelho, caso tenha algum elemento que poderia atrapalhar a
            // vizualização do usuário, ele alinha o widget para que fique visível
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  Container(
                      color: Colors.transparent,
                      height: 250,
                      width: double.infinity,
                      child: DrawerHeader(
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'config_app/imagens/logo_simplificado.png',
                                fit: BoxFit.cover,
                                height: 130,
                              ),
                            ),
                            Positioned(
                                left: 15.0,
                                bottom: 35.0,
                                child: Text(
                                  !model.estaLogado()
                                      ? 'Olá, Administrador'
                                      : 'Olá, ${model.dados_usuario['nome'].split(' ')[0]}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22),
                                )),
                            Positioned(
                              left: 15.0,
                              bottom: 0.0,
                              child: FlatButton(
                                highlightColor: Colors.grey,
                                //Não possui espaçamento nas laterais
                                padding: EdgeInsets.zero,
                                child: Text(
                                  !model.estaLogado()
                                      ? 'Entre para administrar notícias'
                                      : 'Encerrar sessão',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                                onPressed: () {
                                  if (model.estaLogado())
                                    model.sair();
                                  else
                                    Navigator.push(
                                        //Direciona o usuário para página de login
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                },
                              ),
                            )
                          ],
                        ),
                      )),
                  //Caso usuário esteja logado, signica que o botão que leva para o painel adm pode aparecer
                  if (model.estaLogado())
                    ListTile(
                      leading: Icon(
                        Icons.admin_panel_settings,
                        size: 30,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Painel Administrativo',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PainelAdministrativo()));
                      },
                    ),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                      size: 25,
                    ),
                    title: Text(
                      'Fechar Aplicativo',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onTap: () {
                      //Para fechar o app
                      SystemNavigator.pop();
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/**/
