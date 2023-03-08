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
        //Botão flutante com o mais no canto inferior direito
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

        //Observador na coleção desejada, caso essa coleção seja alterada a tela tbm é reconstruida para se adaptar as novas informações
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('noticias').snapshots(),
          builder: (context, snapshot) {
            //Verifica-se ainda n possui os dados, caso n possua mostra circulaprogressindicator
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
                    //Caso o "carregando" seja true, mostra circulaprogressindicator
                if (model.carregando)
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.black,
                    ),
                  );
                else {
                  return ListView(//Para exisber todas as notícias sem dar overflow na tela, e para conseguir "scrollar" para baixo
                    children: [
                      SingleChildScrollView(//Os elementos de cada coluna podem ficar mt grandes, ou a tela
                        // do celular pode ser mt pequena, logo permitimos com que o usuário possa "scrollar" a
                        // nossa tabela na horizontal.
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          color: Colors.grey[700],
                          child: DataTable(//Inicia a nossa tabela
                            //tamanho da lionha a ser exibido
                              dataRowHeight: 100,
                              //espaçamento entre as colunas
                              columnSpacing: 70,
                              columns: [
                                //Coloca-se as nossas respectivas colunas
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
                              //Aqui criamos as nossas linhas. Pegamos os nossos documentos(que representam noticias)
                              // e então chamamos a função .map que permite separarmos cada elemento da nossa lista,
                              // construir algo e então reconstruir a nossa lista, agora com as informações que desejamos.
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
                                                  //Navega/empilha para tela editar
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
                                                        color: Colors.white,)),
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
                                                              //atualizo a variável apagar, caso essa variável seja true ao final do código
                                                              // onPressed do botão deletar, logo é chamado a função para deletar a noticia
                                                              apagar = true;
                                                              //Para fechar o AlertDialog
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
                                                              //Manti o false, e fechei o AlertDialog
                                                              apagar = false;
                                                              // fechei o AlertDialog
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

                                                  //chamo o AlertDialog, já criado, e aguado o usuário realizar alguma operação(Pressionar 'Sim' ou 'Não)

                                                  await showDialog(context: context, builder: (_)=>alert);


                                                  //Verificar se o usuário mudou o estado da variável "apagar". Caso seja verdadeiro vai e chama
                                                  // o método de DELETE que está no nosso modelo, isso passando o id da noticia que desejamos apagar.
                                                  if (apagar)
                                                    model.deletarNoticia(
                                                        noticia.id);
                                                },
                                              ),
                                            ],
                                          ),
                                        ))
                                      ])).toList()),

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
