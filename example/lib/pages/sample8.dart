import 'dart:async';
import 'dart:convert' show json, base64Decode;
import 'package:flutter/material.dart';
import 'package:flutter_allroundrefresh_example/my/my_error/my_error1.dart';
import 'package:flutter_allroundrefresh_example/my/my_error/my_error2.dart';
import 'package:flutter_allroundrefresh_example/my/my_pro/my_proqress_view2.dart';
import 'package:http/http.dart' as HTTP;
import 'package:flutter_allroundrefresh/flutter_allroundrefresh.dart';

class Sample8 extends StatefulWidget {
  @override
  _Sample8State createState() => _Sample8State();
}

class _Sample8State extends State<Sample8> with TickerProviderStateMixin {
  var path6 = 'https://img11.360buyimg.com/n7/jfs/t25342/205/1747435396/262760/8f54e2/5bbac0f7N012a9912.jpg';
  RefreshController _controller;
  int indexPage = 0;
  List<String> data = [];
  int count = 0;
  bool isLoadMore = true;

  void _fetch(up) {
    HTTP
        .get(
        'http://image.baidu.com/channel/listjson?pn=$indexPage&rn=6&tag1=%E6%98%8E%E6%98%9F&tag2=%E5%85%A8%E9%83%A8&ie=utf8')
        .then((HTTP.Response response) {
      Map map = json.decode(response.body);
      return map["data"];
    }).then((array) {
      var start = new DateTime.now().millisecondsSinceEpoch;
      print('getTaskList itme = ${start} %2 =${start % 2}');
      if(up){
        if(count!=0){
          data.clear();
          resultStatus = ResultStatus.nomel;
          for (var item in array) {
            data.add(item["image_url"]);
          }
        }else{
          data.clear();
          resultStatus = ResultStatus.error;
        }
        count++;
        _controller.loadComplete();
      }else{
        print('触发  加载更多');
      }
      setState(() {});

      print('getTaskList data = ${data
          .length} ，count = ${count} ，，indexPage = ${indexPage}');
    }).catchError((_) {
      resultStatus = ResultStatus.error;
      _controller.loadComplete();
    });
  }

  void _onRefresh() {
    Future.delayed(const Duration(milliseconds: 1000)).then((val) {
      _fetch(true);
      _controller.refreshCompleted();

//                refresher.sendStatus(RefreshStatus.completed);
    });
  }

  void _onLoading() {
    Future.delayed(const Duration(milliseconds: 1000)).then((val) {
      _fetch(false);
    });
  }

  Widget buildImage(context, index) {
    return Item(
      url: data[index],
    );
  }

  void _onOffsetCallback(bool isUp, double offset) {
    // if you want change some widgets state ,you should rewrite the callback
    if (isUp) {} else {}
  }


  Widget _footerCreate(BuildContext context, LoadStatus mode) {
    return Image.memory(base64Decode(
        "R0lGODlhFAAUALMAAGaZADOZzP8zM5mZmczMzNra2t7e3uLi4uXl5enp6e3t7fHx8fb29vn5+f7+/gAAACH/C05FVFNDQVBFMi4wAwEAAAAh/g9Qb3dlcmVkIGJ5IEFGRUkAIfkECRQADwAsAAAAABQAFAAABJLwkUmrpdLpzfue2jA4YliKowOmZBtu6drMQ1PbM96oBJnXwF+O52CIjEiU8UhcOJ/Q6KIpDQSkU5Biy1VYtwAAl5gomxPWcthMLgsE5XRiXSYi7u+79R6+I4gHgW+BVoFhgQdEBotvi1aLYYsGiowCjgGQAJJEBZ1vnVadYZ0FnJ4CoAGiAKREHq8cBBIXtBUPEQAh+QQJFAAPACwAAAAAFAAUAAAEjPCRSaul0unN+57aMDhiWIqjA6ZkG27p2sxDU9sz3qgEmdfAX47nYIiMSJTxSFw4n9DooimtOomKrECQ7XqzxIR4Ky6bxeGx4JwAAMpEhHwrryPcdeJhv937D25+RAaEW4QBAYRuhAaDhQKHiQaLhEQFl1uXiJdulwWWmAKaAZwAnkQeqRwEEheuFQ8RADs="));
  }

  ScrollController _scrollController;
  var resultStatus = ResultStatus.init;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController(keepScrollOffset: true);
    _controller = RefreshController();

    Future.delayed(const Duration(milliseconds: 3000)).then((val) {
      _fetch(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('8自定义错误页面2（不可重试）'),
      ),
      body: AllRoundRefresher(
        resultStatus: resultStatus,
        enablePullDown: true,
        progress: MyProgressView2(),
        header: WaterDropHeader(),
        error: MyError2(),
        controller: _controller,
        onRefresh: _onRefresh,
        onOffsetChange: _onOffsetCallback,
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Container(
              height: 200.0,
              color: index % 2 == 0 ? Colors.red : Colors.blue,
              child: Image.network(
                data[index]==null?path6:data[index],
                fit: BoxFit.cover,
              ),
            );
          },

        ),
      ),
    );
  }
}

class Item extends StatefulWidget {
  final String url;

  Item({this.url});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    if (widget.url == null) return Container();
    return Container(
      height: 200.0,
      child: RepaintBoundary(
        child: Image.network(
          widget.url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}