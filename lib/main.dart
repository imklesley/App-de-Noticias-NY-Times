import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newyorktimes_app/modelos/usuario_adm.dart';
import 'package:newyorktimes_app/paginas/moda.dart';
import 'package:newyorktimes_app/paginas/social.dart';
import 'package:newyorktimes_app/widgets/meu_drawer.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  //Inicializar a conexão com o firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //

  //Inicializa-se o app
  runApp(
    new ScopedModel<UsuarioAdm>(
        //Para que eu consiga utilizar o meu modelo criado (UsuarioAdm) em todo o app, preciso chamar o scopedmodel como "pai" do MaterialApp.
        model: UsuarioAdm(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NYTimes',
          theme: ThemeData(
              fontFamily: 'Piazzolla',
              primaryColor: Colors.white,
              primarySwatch: Colors.grey),
          home: Home(),
        )),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Controlador de páginas, iniciado na posição 0
  PageController _controller = PageController(initialPage: 0);

  //Informação do BottomNavigator -- aqui está a posição inicial do bottomnavigator
  int _indexSelecionado = 0;

  @override
  Widget build(BuildContext context) {
    //Para deixar em fullscreen
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
        drawer: MeuDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Image.asset(
              'config_app/imagens/logo_fundo_preto_letra_branca.png',
              fit: BoxFit.cover,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        backgroundColor: Colors.black,
        bottomNavigationBar: BottomNavyBar(
          containerHeight: 60,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          backgroundColor: Colors.black54,
          selectedIndex: _indexSelecionado,
          showElevation: true,
          //Aqui realiza-se alteração na demarcação do botão do bottomnavigator e tbm executa a transição entre as páginas
          items: [
            //Items que representam cada botão do bottom
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                icon: Icon(Icons.people),
                title: Text(
                  'Social',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                activeColor: Colors.white,
                inactiveColor: Colors.grey),
            BottomNavyBarItem(
                textAlign: TextAlign.center,
                icon: Icon(Icons.shopping_bag),
                title: Text(
                  'Moda',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                activeColor: Colors.white,
                inactiveColor: Colors.grey),
          ],
          onItemSelected: (index) => setState(() {
            //Muda a demarcação para a escolhida
            _indexSelecionado = index;
            //Usamos o controller, para então irmos para a página deseja
            _controller.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
        ),
        //Cria-se um observador, que toda vês que os dados no cloudfirestore mudar ele reenvia os dados e reconstrói a tela
        body: StreamBuilder<QuerySnapshot>(
          //Direcionamos os Stream para uma deternada colletion e pegamos seus dados
          stream: FirebaseFirestore.instance.collection('noticias').snapshots(),
          builder: (context, snapshot) {
            //Não há dados? se não deixa mostrando um circularprogressindicator
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.black,
                ),
              );
            }

            // Vai separar os tipos de noticias
            List<DocumentSnapshot> social = [];
            List<DocumentSnapshot> moda = [];

            //Aqui realizamos essa semaparação das notícias. Percorremos todas os documentos(que representam notícia) e verifcamops o 'tipo_noticia'.
            for (var doc in snapshot.data.docs) {
              if (doc['tipo_noticia'] == 'social')
                social.add(doc);
              else if (doc['tipo_noticia'] ==
                  'moda') //não precisaria colocar os detalhes da condicional, porém no firebase tinha outras coleções antigo social e moda
                moda.add(doc);
            }


            return PageView(
              // physics: NeverScrollableScrollPhysics(), //caso queira que a mudança de pages seja somente pelos botões
              controller: _controller,
              onPageChanged: (index) {
                // se mudei página, logo preciso que o bottomnavigator mude para o elemento certo
                setState(() {
                  _indexSelecionado = index;
                });
              },
              children: [
                //Aqui estão todas as páginas
                Social(social),
                Moda(moda),
              ],
            );
          },
        ));
  }
}
