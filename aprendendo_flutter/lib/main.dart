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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Registry BR'),
        ),
        body: const Center(
          child: RandomWords(),
        ),
      ),
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
  //Acho que suggestions é uma lista de WordPair
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // da onde veio o iterator i?
      // Parece que em Dart vc pode "declarar" uma variável pelo parametro
      // da função. Mas se assim fosse o i apenas viveria na função anonima
      // mas note que eu passo a função para o parametro itemBuilder e a
      // ListView através do metodo consegue incrementar ele.
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return ListTile(
          title: Text(
            _suggestions[index].asPascalCase,
            style: _biggerFont,
          ),
        );
      },
    );
  }
}
