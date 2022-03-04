import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/model/error.dart';
import 'package:news_api_flutter_package/model/source.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit.dart';

// void main() => runApp(MyApp());

// class News_retail extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Diary_basic',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: News_retailPage(title: "YYYY/MM/DD(Fri)"),
//     );
//   }
// }

class News_detailPage extends StatefulWidget {
  const News_detailPage({Key? key}) : super(key: key);
  @override
  State<News_detailPage> createState() => _News_detailPageState();
}

class _News_detailPageState extends State<News_detailPage> {
  final NewsAPI _newsAPI = NewsAPI("a03bef12463e4efca82f2dc20baf3b1c");
  // ignore: deprecated_member_use
  var _memoList = <String>[];
  var _currentIndex = -1;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    this.loadMemoList();
  }

  void loadMemoList() {
    SharedPreferences.getInstance().then((prefs) {
      const key = "memo-list";
      if (prefs.containsKey(key)) {
        _memoList = prefs.getStringList(key)!;
      }

      setState(() {
        _loading = false;
      });
    });
  }

  void _onChanged(String text) {
    setState(() {
      _memoList[_currentIndex] = text;
      storeMemoList();
    });
  }

  void storeMemoList() async {
    final prefs = await SharedPreferences.getInstance();
    const key = "memo-list";
    final success = await prefs.setStringList(key, _memoList);
    if (!success) {
      debugPrint("Failed to store value");
    }else{
      debugPrint("store success");
    }
  }

  @override
  Widget build(BuildContext context) {
    //final items = _news;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6c848d),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("News Detail"),
      ),
      body: _newsTile(),
    );
  }

  Widget _newsTile() {
    return FutureBuilder<List<Article>>(
        future: _newsAPI.getTopHeadlines(country: "jp"),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
              ? _buildArticleListView(snapshot.data!)
              : _buildError(snapshot.error as ApiError)
              : _buildProgress();
        });
  }


  // Widget _buildArticleListView(List<Article> articles) {
  //   bool _customTileExpanded = false;
  //   for (int i = 0; i < articles.length; i++) {
  //     _memoList.add("");
  //   }
  //   return ListView.builder(
  //     itemCount: 5,
  //     itemBuilder: (context, index) {
  //       Article article = articles[index];
  //       final memo = _memoList[index];
  //       return _newstopic(memo, index, article);
  //     },
  //   );
  // }

  Widget _buildArticleListView(List<Article> articles) {
    bool _customTileExpanded = false;
    for (int i = 0; i < articles.length; i++) {
      _memoList.add("");
    }
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, index) {
        Article article = articles[index];
        final memo = _memoList[index];
        return Container(
          height: 200,
          margin: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFefefef),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child:
                    Image.network(article.urlToImage.toString()
                  ),
                ),
                SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width:150,
                      child: Text(
                        article.title!,
                        style: TextStyle(
                            color:Color(0xFF1f2326),
                            fontSize: 15,
                            decoration: TextDecoration.none
                        ),
                      )
                    ),
                    SizedBox(height: 5,),
                    SizedBox(
                      width: 122,
                      child: Text(
                        article.source.name!,
                        style: TextStyle(
                            color:Color(0xFF3b3f42),
                            fontSize: 10,
                            decoration: TextDecoration.none
                        ),
                      ),
                    )

                  ],
                ),
              ]
            ),
          ),

        );
      },
    );
  }

  Widget _newsLap(bool _expanstion){
    return ExpansionTile(
      title: Text('もっとニュースを見る'),
      trailing: Icon(
        _expanstion
            ? Icons.arrow_drop_down_circle
            : Icons.arrow_drop_down,
      ),
    );
  }

  Widget _newstopic(String content, int index, Article article) {
    return Column(
      children: [
        ListTile(
          title: Text(
            article.title!,
            maxLines: 3,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            //article.description ?? "",
            article.source.name!,
            maxLines: 2,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          leading: article.urlToImage == null
              ? null
              : Image.network(
            article.urlToImage!,
            // width: 150
          ),
          tileColor: Color(0xFFdcd6d2),
          onTap: () => onLaunchUrl(article.url!),
        ),
        content == "" ? _nullContent(index) : _showContent(content, index),
      ],
    );
  }

  Widget _buildProgress() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildError(ApiError error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error.code ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 4),
            Text(error.message!, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }


  Future onLaunchUrl (String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }


  //一言メモ未記入時に表示させるウィジェット
  Widget _nullContent(int index) {
    return ElevatedButton(
      onPressed: () {
        _currentIndex = index;
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return new Edit(_memoList[_currentIndex], _onChanged);
        }));
      },
      child: Text('一言メモを書く'),
      // style: ElevatedButton.styleFrom(
      //
      // ),
    );
  }

  //一言メモ記入時に表示させるウィジェット
  Widget _showContent(String content, int index) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black,
      child: Column(
        children: [
          ListTile(
              title: Text(
                '一言メモ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                  decorationThickness: 5,
                  //decorationStyle: TextDecorationStyle.double,
                ),
              ),
              subtitle: Text(
                content,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              isThreeLine: true,
              onTap: () {
                _currentIndex = index;
                Navigator.of(context)
                    .push(MaterialPageRoute<void>(builder: (BuildContext context) {
                  return new Edit(_memoList[_currentIndex], _onChanged);
                }));
              }),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                child: Text(
                  'Delete',
                  // style: TextStyle(
                  //   color: Colors.red,
                  // ),
                ),
                onPressed: () {},
              ),
              OutlinedButton(
                child: Text(
                  'Edit',
                  // style: TextStyle(
                  //   color: Colors.green,
                  // ),
                ),
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
}
