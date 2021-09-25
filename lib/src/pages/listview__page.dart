import 'dart:async';

import 'package:flutter/material.dart';

class ListviewPage extends StatefulWidget {
  const ListviewPage({Key? key}) : super(key: key);

  @override
  _ListviewPageState createState() => _ListviewPageState();
}

class _ListviewPageState extends State<ListviewPage> {
  ScrollController _scrollController = new ScrollController();
  List<int> _numbersList = [];
  int _lastItem = 0;
  bool _isLoading = false;
  @override
  void initState() {
    _add10();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // _add10();
        fetchData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listas'),
      ),
      body: Stack(
        children: [_crearLista(), _crearLoading()],
      ),
    );
  }

  _crearLista() {
    return RefreshIndicator(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: _numbersList.length,
            itemBuilder: (BuildContext context, int index) {
              final image = _numbersList[index];
              return FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'),
                image:
                    NetworkImage('https://picsum.photos/500/300/?image=$image'),
              );
            }),
        onRefresh: _refreshList);
  }

  _add10() {
    for (var i = 1; i < 10; i++) {
      _lastItem++;
      _numbersList.add(_lastItem);
    }
    setState(() {});
  }

  Future fetchData() async {
    _isLoading = true;
    setState(() {});
    return new Timer(new Duration(seconds: 2), () {
      _isLoading = false;
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
      _add10();
    });
  }

  _crearLoading() {
    if (_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
          SizedBox(
            height: 15.0,
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Future<void> _refreshList() async {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {
      _numbersList.clear();
      _lastItem++;
      _add10();
    });
    return Future.delayed(duration);
  }
}
