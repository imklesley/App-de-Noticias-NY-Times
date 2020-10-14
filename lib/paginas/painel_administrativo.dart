import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newyorktimes_app/modelos/usuario_adm.dart';
import 'package:newyorktimes_app/paginas/edita_noticia.dart';
import 'package:newyorktimes_app/paginas/nova_noticia.dart';
import 'package:scoped_model/scoped_model.dart';

class PainelAdministrativo extends StatefulWidget {
  @override
  _PainelAdministrativoState createState() => _PainelAdministrativoState();
}

class _PainelAdministrativoState extends State<PainelAdministrativo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: 'Adicionar Nova Notícia',
          child: Icon(Icons.add),
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NovaNoticia()));
          },
        ),
        appBar: AppBar(
          elevation: 10,
          shadowColor: Colors.grey,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: Text(
            'Painel Administrativo',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        backgroundColor: Colors.black,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('noticias').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.black,
                  ),
                ),
              );
            } else {
              return ScopedModelDescendant<UsuarioAdm>(
                  builder: (context, child, model) {
                if (model.carregando)
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.black,
                    ),
                  );
                else {
                  return ListView(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          color: Colors.grey[700],
                          child: DataTable(
                              dataRowHeight: 100,
                              columnSpacing: 70,
                              columns: [
                                DataColumn(
                                    label: Text(
                                  'Notícia',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Categoria',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Ações',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ))
                              ],
                              rows: snapshot.data.docs
                                  .map((noticia) => DataRow(cells: [
                                        DataCell(Container(
                                          width: 150,
                                          child: Text(
                                            noticia['titulo'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        )),
                                        DataCell(Text(
                                          noticia['tipo_noticia'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        )),
                                        DataCell(Center(
                                          child: Column(
                                            children: [
                                              FlatButton(
                                                child: Text('Editar',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditaNoticia(
                                                                  noticia)));
                                                },
                                              ),
                                              FlatButton(
                                                padding: EdgeInsets.zero,
                                                child: Text('Deletar',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                onPressed: () async {
                                                  //Coordena o delete pelo alertDialog
                                                  bool apagar = false;
                                                  AlertDialog alert =
                                                      AlertDialog(
                                                    title: Text(
                                                        'Deletar Noticia?'),
                                                    content: Text(
                                                        'Você realmente deseja deletar essa notícia?'),
                                                    actions: [
                                                      FlatButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              apagar = true;
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          child: Text(
                                                            'Sim',
                                                          )),
                                                      FlatButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              apagar = false;
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          child: Text('Não',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)))
                                                    ],
                                                  );

                                                  await showDialog(
                                                      context: context,
                                                      child: alert);
                                                  if (apagar)
                                                    model.deletarNoticia(
                                                        noticia.id);
                                                },
                                              ),
                                            ],
                                          ),
                                        ))
                                      ]))
                                  .toList()),
                        ),
                      )
                    ],
                  );
                }
              });
            }
          },
        ));
  }
}
