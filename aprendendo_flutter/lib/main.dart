// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Aqui temos uma declaração de construtor compacta que define o valor de key
  // do pai da classe
  //const MyApp({Key?: key}): super(key:key)
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seja bem vindo ao Registry BR',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

// Talvez tenha a ver com o StatefullWidget, sempre que o tem o evento de rolar
// a tela o estado muda.??
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  // Em Dart o _ significa que o método é privado.
  State<RandomWords> createState() => _RandomWordsState();
}

// Não entendi como funciona as chamadas, como ele sabe que é pra chamar
// o estado até preencher o display do equipamento?
class _RandomWordsState extends State<RandomWords> {
  // _suggestions é uma lista (list) de WordPair.
  // Listas em Dart permitem elementos duplicados e null. Listas são indexadas
  // _suggestions.add(WordPair instance)
  // _suggestions.remove(WordPair instance)
  // Note que essa lista é final, então ela é imutável
  // É possível iterar em list igual no python
  // for( var suggestion in _suggestions){
  //   print(suggestion)
  // }
  // List mantem a ordem dos elementos
  final _suggestions = <WordPair>[];
  // _saved é um Set. Set não permite elementos duplicados e também não ordena.
  // Geralmente Set é mais rápido de List.
  // Diferente de List para acessar um elemento em Set usa-se:
  // _saved.elementAt(index)
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  void _pushSaved() {
    Navigator.of(context).push(
      // Aqui é um construtor de MaterialPageRoute
      MaterialPageRoute<void>(
        // Agora começa os argumentos do construtor:
        // que aqui é apenas o builder que recebe uma função anonima com
        // context como argumento.
        builder: (context) {
          // Aqui tem alguma bruxaria, como que esse método consegue percorrer
          // o Set saved e criar a lista.
          // Aqui nesse caso o método map percorre o Set de palavras salvas e
          // cria um novo iteravel objetos do tipo ListTile com o texto preen-
          // chido.
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(pair.asPascalCase, style: _biggerFont),
              );
            },
          );
          // aqui divide a lista de tiles. Caso seja vazio divided recebe a
          // lista de <Widget>
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];
          // Note que o botão de voltar não foi definido aqui, então eu
          // entendo que isso é feito automaticamente.
          return Scaffold(
            appBar: AppBar(
              title: const Text('Sugestões Salvas'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registry BR'), actions: [
        // Clicando nesse botão, o método _pushSaved vai empilhar
        // um MaterialPageRoute que vai usar build para criar uma página
        // completa, o titulo em appbar será "sugestões salvas" e ali no map
        // será criada uma lista de tiles e depois acrescentado divisórias,
        // por fim esse widget lista seja fixado no body.
        IconButton(
          onPressed: _pushSaved,
          icon: const Icon(Icons.list),
          tooltip: 'Sugestões Salvas',
        ),
      ]),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // de onde veio o iterator i?
        // Parece que em Dart vc pode "declarar" uma variável pelo parâmetro
        // da função. Mas se assim fosse o i apenas viveria na função anonima
        // mas note que eu passo a função para o parâmetro itemBuilder e a
        // ListView através do método consegue incrementar ele.
        itemBuilder: (context, i) {
          print('Valor de i: $i');
          if (i.isOdd) {
            return const Divider();
          }
          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            // Esse metodo, addAll, é para add varios elementos de uma list.
            // Pelo que entendi o generatoWordPairs retorna um iterador de pala-
            // vras geradas aleatoriamente.
            _suggestions.addAll(generateWordPairs().take(10));
          }

          final alreadySaved = _saved.contains(_suggestions[index]);

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remover dos Favoritos' : 'Salvar',
            ),
            onTap: () {
              // Eu entendi que ao chamar o setState um gatilho que chama novamen-
              // o método build do State será chamado, mas não entendi o que acon-
              // tece com iterador i. Ele não seria incrementado? Pelo que vi
              // sempre que mexe no scroll ou mesmo clica no coração a build é
              // chamada. Aí o iterador i tem um range, que vai from to. Acredito
              // que a ListView mantenha isso em controle, através do objeto ins-
              // ciado então o i da função anonima realmente é uma variável que o
              // dart cria ali só.
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
    );
  }
}
