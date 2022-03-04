import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:intl/intl.dart";
import 'package:ver1_20210924/news_detail.dart';




class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  List TodayTopics = [];
  List MyTrend = [];

  _readData() async {
    await DefaultAssetBundle.of(context).loadString("json/TodayNews.json").then((s) {
      setState(() {
        TodayTopics = json.decode(s);
      });
    });

    await DefaultAssetBundle.of(context).loadString("json/MyTrend.json").then((s) {
      setState(() {
        MyTrend = json.decode(s);
      });
    });
  }

  @override
  void initState() {
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return
      Scaffold(
          // appBar: AppBar(
          //     backgroundColor: Color(0xFFbd6856),
          // ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 50),
              color: const Color(0xFFefefef),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Text(
                        DateFormat('yyyy年 M月 d日').format(Get.arguments),
                        style: const TextStyle(
                          color: Color(0xFF555647),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ),
                  const Divider(thickness: 1.5,),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      children: [
                        const Text(
                          "スクリーンタイム",
                          style: TextStyle(
                              color: Color(0xFF1f2326),
                              fontSize: 20,
                              decoration: TextDecoration.none
                          ),
                        ),
                        Expanded(child: Container()),
                        const Text(
                          "Detail",
                          style: TextStyle(
                              color: Color(0xFFffa07a),
                              fontSize: 15,
                              decoration: TextDecoration.none
                          ),
                        ),

                        const SizedBox(width: 5,),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFffa07a)
                          ),
                          child: GestureDetector(
                              child: const Icon(
                                  Icons.arrow_forward_ios, color: Colors.white)
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    height: 200,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "よく使った言葉",
                      style: TextStyle(
                          color: Color(0xFF1f2326),
                          fontSize: 20,
                          decoration: TextDecoration.none
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  //list
                  SizedBox(
                      height: 180,
                      width: width,
                      child:   MediaQuery.removePadding(context: context,
                          removeTop: true,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: MyTrend.length,
                              itemBuilder: (_, i){
                                return Container(
                                  width: width,
                                  height: 60,
                                  margin: const EdgeInsets.only(left: 25, right: 20, bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color:const Color(0xFFdcd6d2),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20, right: 20),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      MyTrend[i]['title'],
                                      style: const TextStyle(
                                          color:Color(0xFF1f2326),
                                          fontSize: 18,
                                          decoration: TextDecoration.none
                                      ),
                                    ),
                                  ),
                                );
                              })

                      )

                  ),
                  // _VerticalList(context, MyTrend, width, Color(0xFFe6bfb2), Color(0xFFe8d3ca)),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      children: [
                        const Text(
                          "今日のニュース",
                          style: TextStyle(
                              color: Color(0xFF1f2326),
                              fontSize: 20,
                              decoration: TextDecoration.none
                          ),
                        ),
                        Expanded(child: Container()),
                        const Text(
                          "More",
                          style: TextStyle(
                              color: Color(0xFFffa07a),
                              fontSize: 15,
                              decoration: TextDecoration.none
                          ),
                        ),

                        const SizedBox(width: 5,),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFffa07a)
                          ),
                          child: GestureDetector(
                              onTap: (){
                                Get.to(()=>News_detailPage());
                              },
                              child: const Icon(
                                  Icons.arrow_forward_ios, color: Colors.white, )
                              ),

                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  //list
                  _VerticalList(context, TodayTopics, width, const Color(0xFF8fbc8f), const Color(0xFF54917f)),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      children: [
                        const Text(
                          "ヘルスケア",
                          style: TextStyle(
                            color: Color(0xFF1f2326),
                            fontSize: 20,
                            decoration: TextDecoration.none
                          ),
                        ),
                        Expanded(child: Container()),
                      ]
                    )
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    height: 100,
                    width: width,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius:40,
                          backgroundImage: AssetImage(
                            "img/5.jpg"
                          ),
                        ),
                        const SizedBox(width: 30,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "歩数",
                              style: TextStyle(
                                  color:Color(0xFF3b3f42),
                                  fontSize: 18,
                                  decoration: TextDecoration.none
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "Number of steps",
                              style: TextStyle(
                                  color:Colors.black,
                                  fontSize: 12,
                                  decoration: TextDecoration.none
                              ),
                            ),
                          ]
                        ),
                        const SizedBox(width: 30,),
                        const Text(
                          "121",
                          style: TextStyle(
                              color:Colors.black,
                              fontSize: 20,
                              decoration: TextDecoration.none
                          ),
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 10,),
                  Container(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      height: 100,
                      width: width,
                      child: Row(
                        children: [
                          SizedBox(
                            height:80,
                            width: 80,
                            child: Image.asset(
                                "img/6.png"
                            ),
                          ),
                          const SizedBox(width: 30,),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "移動距離",
                                  style: TextStyle(
                                      color:Color(0xFF3b3f42),
                                      fontSize: 18,
                                      decoration: TextDecoration.none
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  "Moving distance",
                                  style: TextStyle(
                                      color:Colors.black,
                                      fontSize: 12,
                                      decoration: TextDecoration.none
                                  ),
                                ),
                              ]
                          ),
                          const SizedBox(width: 30,),
                          const Text(
                            "2021 km",
                            style: TextStyle(
                                color:Colors.black,
                                fontSize: 20,
                                decoration: TextDecoration.none
                            ),
                          ),
                        ],
                      )
                  ),
                  const SizedBox(height: 10,),
                ],
              )
            )
          )
      );
  }
}

Widget _VerticalList(BuildContext context, List list, double width,
    Color color1, Color color2) {
  return SizedBox(
      height: 320,
      child: PageView.builder(
          controller: PageController(viewportFraction: 0.88),
          itemCount: list.length,
          itemBuilder: (_, i) {
            return GestureDetector(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20, top: 20),
                height: 320,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 20,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: i.isEven ? color1 : color2
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          list[i]['title'],
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: width,
                      child: Text(
                        list[i]['text'],
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(thickness: 1.0,),
                    const SizedBox(height: 5,),
                    SizedBox(

                      width: 200,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                                image: AssetImage(
                                    list[i]['img']
                                ),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            );
          }
      )
  );
}


