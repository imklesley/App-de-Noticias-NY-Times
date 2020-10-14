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
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    new ScopedModel<UsuarioAdm>(
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
  PageController _controller = PageController(initialPage: 0);
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
        // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _indexSelecionado = index;
          _controller.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
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
      ),
      body: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('noticias').snapshots(),builder: (context,snapshot){

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.black,
            ),
          );
        }



        // vai separar os tipos de noticias
        List<DocumentSnapshot> social = [];
        List<DocumentSnapshot> moda = [];

        for(var doc in snapshot.data.docs){

          if(doc['tipo_noticia'] == 'social')
            social.add(doc);
          else if(doc['tipo_noticia'] == 'moda') //não precisaria colocar os detalhes da condicional, porém no firebase tinha outras coleções antigo social e moda
            moda.add(doc);
        };



        return PageView(
          onPageChanged: (index) {
            setState(() {
              _indexSelecionado = index;
            });
          },
          controller: _controller,
          children: [
            Social(social),
            Moda(moda),
          ],
        );
      },)
    );
  }
}
