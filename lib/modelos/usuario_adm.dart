import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UsuarioAdm extends Model {
  //Instancia que controla tudo relacionado com autenticação no firebase
  FirebaseAuth _auth = FirebaseAuth.instance;

  //Guarda o usuário atual
  User _user;

  //Guarda os dados do usuário atual
  Map<String, dynamic> dados_usuario;

  //Controla estado da tela. Caso esteja aguardando coloquei um CirculaProgressIndicator
  bool carregando = false;

  //Realiza a verificação se o usuário está logado
  bool estaLogado() {
    bool resposta = _user != null;
    return resposta;
  }

  //Fazer com que ao entrar no app sejam carregados os dados do usuário, sobreescreve-se o método que é chamado pelo flutter assim que o app é inicializado
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    //método que carrega o usuário atual, caso tenha.
    carregaUsuarioAtual();
    notifyListeners();
  }

  //Processo de login
  void entrar(
      {@required String email,
      @required senha,
      @required VoidCallback sucesso,
      @required VoidCallback falhou}) async {
    //Avisa que o app entrou em estado de espera
    carregando = true;
    notifyListeners();

    //gambiarra pra fazer o circular progrss indicator aparecer pelo menos
    // um segundo. isso foi colocado pois na hr do dev estava simplesmente
    // pulando o circularPI.
    await Future.delayed(Duration(seconds: 1));

    //Chama-se a função que realiza o login usando email e senha
    _auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((user) async {      //Caso dê tudo certo

      //Salva o usuário logado localmente
      _user = user.user;
      sucesso();
      //Carrega os dados do usuário que estão no firebase
      await carregaUsuarioAtual();
      carregando = false;
      notifyListeners();
    }).catchError((error) {
      // Caso dê tudo errado
      falhou();
      carregando = false;
      notifyListeners();
    });
  }

  //Cria-se um novo usuário usando email e senha, e salva-se todas as informações do usuário, com exceção da senha.
  void cadastrar(
      {@required Map<String, dynamic> dados,
      @required String senha,
      @required VoidCallback sucesso,
      @required VoidCallback falhou}) {
    //Muda o estado da tela para modo de espera
    carregando = true;
    //Notifica todos os listeners
    notifyListeners();

    //Tentativa de criação de usuário por email e senha
    _auth
        .createUserWithEmailAndPassword(email: dados['email'], password: senha)
        .then((user) async {
      //Caso deu certo
      //Coloca-se o id do usuário em _user, para verificações no decorrer do app
      _user = user.user;
      //Salva-se os dados do usuário no cloudfirestore
      await salvaDados(dados);
      // Notifíca-se o usuário de alguma forma pela função sucesso(), muda o estado da variável "carregando"
      // e então avisa todos os listeners para reconstruir a tela desejada
      sucesso();
      carregando = false;
      notifyListeners();
    }).catchError((error) {
      //Caso o cadastro der erro, chama a função "falhou"
      falhou();
      //muda os estado para não carregando
      carregando = false;
      //notifica as atualizações da tela
      notifyListeners();
    });
  }

  //Realiza a saída da conta dos usuários
  void sair() async {
    //Realiza a saída do usuário do firebase e localmente
    await _auth.signOut();
    //reseta todas as informações do usuário, para o app identificar que não há usuário logado
    _user = null;
    dados_usuario = null;

    //notifica os listeners para atualizar as telas que possuem os dados do usuário
    notifyListeners();
  }

  //Recuperação de senha, basta passar uma string que representa o email
  void recuperarSenha(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }


  //SÓ UTILIZADO NA FUNÇÃO DE CADASTRO
  //Cria uma coleção com o id do usuário(retorno do firebase) e salvas as demais informações inseridas pelo usuário no form de cadastro
  Future<Null> salvaDados(Map<String, dynamic> dados) async {
    await FirebaseFirestore.instance
        .collection('administradores')
        .doc(this._user.uid)
        .set(dados);

    //carrega os dados do usuário localmente(cache)
    this.dados_usuario = dados;
    notifyListeners();
  }



  //carrega o usuário atual e suas informações
  Future<Null> carregaUsuarioAtual() async {
    // var _user é nula? se sim, vamo verificar se o _auth possui algum usuário salvo
    if (_user == null) {
      _user = _auth.currentUser;
    }
    //Agora verificamos a hipótese de cima
    if (_user != null) {
      //se deu certo e os dados dele é nulo buscamos os dados do usuário no firebase
      if (dados_usuario == null) {
        DocumentSnapshot dados = await FirebaseFirestore.instance
            .collection('administradores')
            .doc(_user.uid)
            .get();
        //atribui-=se os dados recebido pelo firebase e coloca-se em dados_usuario
        dados_usuario = dados.data();
      }
    }
    //Então notifico todos os elementos da tela que usam essa informação
    notifyListeners();
  }



  // AQUI SE ENCONTRA O NOSSO CRUD,COM EXCEÇÃO DO READ

  //CREATE
  //Pegamos o map com as informações da notícia, e enviamos para o cloudfirestore
  Future<Null> enviaNovaNoticia(Map<String, dynamic> dadosNoticia) {
    //Avisa o app que entramos em estado de espera
    carregando = true;
    notifyListeners();

    //Entramos na coleção "noticias" e adicionamos a notícia criada
    FirebaseFirestore.instance
        .collection('noticias')
        .add(dadosNoticia);

    //Avisamos que não está mais em estado de espera, isso para parar o circularPI
    carregando = false;
    notifyListeners();
  }


  //DELETE
  //Realiza-se a remoção da noticia do cloudfirestore
  Future<Null> deletarNoticia(String noticiaId) {
    //Avisa o app que entramos em estado de espera
    carregando = true;
    notifyListeners();

    //Entramos na coleção 'noticias', e então entramos no documento noticiaId
    FirebaseFirestore.instance.collection('noticias').doc(noticiaId).delete();

    //Avisamos que não está mais em estado de espera, isso para parar o circularPI
    carregando = false;
    notifyListeners();
  }


  //UPDATE
  //Realiza-se o update da notícia em questão
  Future<Null> atualizarNoticia(
      Map<String, dynamic> dadosNoticia, String noticiaId) {
    carregando = true;
    notifyListeners();

    //Aqui rola a atualização
    FirebaseFirestore.instance
        .collection('noticias')
        .doc(noticiaId)
        .update(dadosNoticia);


    //Avisamos que não está mais em estado de espera, isso para parar o circularPI
    carregando = false;
    notifyListeners();
  }
}
