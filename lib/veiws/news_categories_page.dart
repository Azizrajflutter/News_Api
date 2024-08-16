import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/veiws/home_screen.dart';
import 'package:news_app/veiws/news_detail_screen.dart';
import 'package:news_app/views_model/news_view_model.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final formet = DateFormat('MMMM dd,yyyy');
  String categoryName = 'general';
  List<String> categriesList = [
    'General',
    'Entertaiment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: DefaultTabController(
          length: categriesList.length,
          child: Column(
            children: <Widget>[
              ButtonsTabBar(
                  // Customize the appearance and behavior of the tab bar
                  backgroundColor: Colors.blue,
                  borderWidth: 0,
                  borderColor: Colors.black,
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  contentPadding: EdgeInsets.all(10),
                  height: 50.sp,

                  // Add your tabs here
                  tabs: [
                    Tab(
                      text: "General",
                    ),
                    Tab(text: "Entertaiment"),
                    Tab(text: "Health"),
                    Tab(text: "Sports"),
                    Tab(text: "Business"),
                    Tab(text: "Technology"),
                  ]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TabBarView(
                    children: [
                      Category(categoryName: 'general'),
                      Category(categoryName: 'Entertaiment'),
                      Category(categoryName: 'Health'),
                      Category(categoryName: 'Sports'),
                      Category(categoryName: 'Business'),
                      Category(categoryName: 'Technology'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class Category extends StatefulWidget {
  final String categoryName;
  const Category({super.key, required this.categoryName});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final formet = DateFormat('MMMM dd,yyyy');
  @override
  Widget build(BuildContext context) {
    final h = context.height;
    final w = context.width;
    return FutureBuilder<CategoriesNewsModel>(
      future: NewsViewModel().fetchNewsCatogoryApi(widget.categoryName),
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
        } else if (!snapshot.hasData || snapshot.data!.articles!.isEmpty) {
          return Center(
            child: Text('No articles available'),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.articles!.length,
            itemBuilder: (context, index) {
              final imageUrl = snapshot.data!.articles![index].urlToImage;
              DateTime dateTime = DateTime.parse(
                  snapshot.data!.articles![index].publishedAt.toString());
              print('Loading image: $imageUrl');
              return Padding(
                padding: EdgeInsets.only(top: 10),
                child: GestureDetector(
                  onTap: () {
                    String? newsImage =
                        snapshot.data!.articles![index].urlToImage;
                    String? newsTitle = snapshot.data!.articles![index].title;
                    String? newsDate =
                        snapshot.data!.articles![index].publishedAt;
                    String? newsAuthor = snapshot.data!.articles![index].author;
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
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                height: h * .19,
                                width: w * .3,
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvioder) {
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
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.grey,
                                height: h * .20,
                                width: w * .3,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                      Expanded(
                        child: Container(
                          height: h * .18,
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Column(
                            children: [
                              Text(
                                snapshot.data!.articles![index].title
                                    .toString(),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data!.articles![index].source!.name
                                        .toString(),
                                    style:
                                        GoogleFonts.poppins(color: Colors.blue),
                                  ),
                                  Text(
                                    formet.format(dateTime),
                                    style: GoogleFonts.poppins(fontSize: 10.sp),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
