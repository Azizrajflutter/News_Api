import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/veiws/news_categories_page.dart';
import 'package:news_app/veiws/news_detail_screen.dart';
import 'package:news_app/views_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum Filterdlist { bbcNews, aryNews, reuters, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  Filterdlist? seletcetdItem;
  final formet = DateFormat('MMMM dd,yyyy');
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final h = context.height;
    final w = context.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<Filterdlist>(
          
            onSelected: (Filterdlist item) {
              if (Filterdlist.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (Filterdlist.aryNews.name == item.name) {
                name = 'ary-news';
              }

              if (Filterdlist.cnn.name == item.name) {
                name = 'cnn';
              }
              if (Filterdlist.alJazeera.name == item.name) {
                name = 'al-jazeera-english';
              }
              if (Filterdlist.reuters.name == item.name) {
                name = 'reuters';
              }
              setState(() {});
            },
            initialValue: seletcetdItem,
            itemBuilder: (context) {
              return <PopupMenuEntry<Filterdlist>>[
                PopupMenuItem<Filterdlist>(
                  child: Text('BBC News'),
                  value: Filterdlist.bbcNews,
                ),
                PopupMenuItem<Filterdlist>(
                  child: Text('Ary News'),
                  value: Filterdlist.aryNews,
                ),
                PopupMenuItem<Filterdlist>(
                  child: Text('CNN'),
                  value: Filterdlist.cnn,
                ),
                PopupMenuItem<Filterdlist>(
                  child: Text('AlJazeera'),
                  value: Filterdlist.alJazeera,
                ),
                PopupMenuItem<Filterdlist>(
                  child: Text('Reuters'),
                  value: Filterdlist.reuters,
                ),
              ];
            },
          )
        ],
        leading: IconButton(
          onPressed: () {
            Get.to(() => CategoriesPage());
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: 30,
            width: 30,
          ),
        ),
        centerTitle: true,
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: h * .55,
              width: w,
              child: FutureBuilder<NewsChannelHeadlinesModel>(
                future: NewsViewModel().fetchNewsChannelHeadlinesApi(name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SpinKitThreeBounce(
                      color: Colors.black,
                      size: 25,
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading images'),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles!.isEmpty) {
                    return Center(
                      child: Text('No articles available'),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        final imageUrl =
                            snapshot.data!.articles![index].urlToImage;
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());

                        return GestureDetector(
                          onTap: () {
                            String? newsImage =
                                snapshot.data!.articles![index].urlToImage;
                            String? newsTitle =
                                snapshot.data!.articles![index].title;
                            String? newsDate =
                                snapshot.data!.articles![index].publishedAt;
                            String? newsAuthor =
                                snapshot.data!.articles![index].author;
                            String? newsDesc =
                                snapshot.data!.articles![index].description;
                            String? newsContent =
                                snapshot.data!.articles![index].content;
                            String? newsSource =
                                snapshot.data!.articles![index].source!.name;
                            Get.to(() => NewsDetailScreen(
                                newsImage,
                                newsTitle,
                                newsDate,
                                newsAuthor,
                                newsDesc,
                                newsContent,
                                newsSource));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: w * 0.9,
                                height: h * 0.6,
                                padding:
                                    EdgeInsets.symmetric(horizontal: h * .02),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: imageUrl != null && imageUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          imageBuilder:
                                              (context, imageProvioder) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: imageProvioder,
                                                    fit: BoxFit.fill),
                                              ),
                                            );
                                          },
                                          placeholder: (context, url) => Center(
                                            child: spinkit2,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                      padding: EdgeInsets.all(15),
                                      alignment: Alignment.bottomCenter,
                                      height: h * .22.sp,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: w * 0.6,
                                            child: Text(
                                              snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17.r,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: w * 0.6,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12.r,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  formet.format(dateTime),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12.r,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: h * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Category(categoryName: 'general'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);

const spinkit3 = CircularProgressIndicator();
