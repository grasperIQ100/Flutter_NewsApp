

import 'package:damn_news/models/categories_new_model.dart';
import 'package:damn_news/models/news_channel_headlines_model.dart';
import 'package:damn_news/view/categories_screen.dart';
import 'package:damn_news/view/news_detail_screen.dart';
import 'package:damn_news/view_model/news_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


enum FilterList { bbcNews, aryNews, independent, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {

  NewsViewModel newsViewModel = NewsViewModel();

  FilterList? selectedMenu ;
  final format = DateFormat('MMMM dd, yyyy');

  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png',
            height: 30,
            width: 30,
            ),
          ),
        title: Center(child: Text('News' , style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),)),
        actions: [
          PopupMenuButton<FilterList>(
          initialValue: selectedMenu,
          icon: Icon(Icons.more_vert, color: Colors.black,),
          onSelected: (FilterList item){

            if(FilterList.bbcNews.name == item.name){
              name = 'bbc-news';
            }
            if(FilterList.aryNews.name == item.name){
              name = 'ary-news';
            }
            if(FilterList.independent.name == item.name){
              name = 'ars-technica';
            }
            if(FilterList.cnn.name == item.name){
              name = 'cnn';
            }
            if(FilterList.alJazeera.name == item.name){
              name = 'al-jazeera-english';
            }

            setState(() {
              selectedMenu = item;
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>> [
            PopupMenuItem<FilterList>(
              value: FilterList.bbcNews,
              child: Text('BBC News'),
            ),
            PopupMenuItem<FilterList>(
              value: FilterList.aryNews,
              child: Text('Ary News'),
            ),
            PopupMenuItem<FilterList>(
              value: FilterList.independent,
              child: Text('Independent'),
            ),
            PopupMenuItem<FilterList>(
              value: FilterList.cnn,
              child: Text('CNN News'),
            ),
            PopupMenuItem<FilterList>(
              value: FilterList.alJazeera,
              child: Text('Al Jazeera News'),
            )
          ]
          )

        ],

      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewChannelHeadlinesApi(name),
              builder: (BuildContext context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitWaveSpinner(
                      size: 70,
                      color: Colors.blue,
                    ),
                  );
                }else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){


                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return  InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                NewsDetailsScreen(
                                    newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                    newsTitle: snapshot.data!.articles![index].title.toString(),
                                    newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                    author: snapshot.data!.articles![index].author.toString(),
                                    description: snapshot.data!.articles![index].description.toString(),
                                    content: snapshot.data!.articles![index].content.toString(),
                                    source: snapshot.data!.articles![index].source!.name.toString()))
                            );

                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * .9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * .02
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context,url) => Container(child: spinkit2,),
                                      errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red,),
                                                              ),
                                  ),
                          ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      
                          
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.all(15),
                                      height: height * .22,
                                      child: Column(
                          
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                          
                                          Container(
                                            width: width * 0.7,
                                            child: Text(snapshot.data!.articles![index].title.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis
                                              ,style:
                                              GoogleFonts.poppins(fontSize:17, fontWeight: FontWeight.w700),),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * 0.7,
                          
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis
                                                  ,style:
                                                  GoogleFonts.poppins(fontSize:13, fontWeight: FontWeight.w600),),
                                                Text(format.format(dateTime),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis
                                                  ,style:
                                                  GoogleFonts.poppins(fontSize:12, fontWeight: FontWeight.w500),)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          ],
                          ),
                          ),
                        );
    }

                  );
                }
              },
            )
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchNewsCategoriesApi('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitWaveSpinner(
                      size: 70,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(), // Add this line to prevent scrolling
                      primary: true, // Add this line to ensure correct scrolling behavior
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.articles!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {


                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return  Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(

                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3 ,
                                  placeholder: (context,url) => Container(child: Center(
                                    child: SpinKitWaveSpinner(
                                      size: 70,
                                      color: Colors.blue,
                                    ),
                                  ),),
                                  errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red,),
                                ),
                              ),
                              Expanded(
                                child: Container(

                                  height: height * .18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(snapshot.data!.articles![index].title.toString() ,
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(snapshot.data!.articles![index].source!.name.toString() ,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          Text(format.format(dateTime) ,
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )
                                        ],
                                      ),


                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }

                  );
                }
              },
            ),
          )
        ],
      )
    );
  }


}
const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);