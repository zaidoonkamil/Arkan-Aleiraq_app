import 'package:arkan_aleiraq/core/%20navigation/navigation.dart';
import 'package:arkan_aleiraq/core/model/GetProductsByVariants.dart';
import 'package:arkan_aleiraq/core/widgets/app_bar.dart';
import 'package:arkan_aleiraq/core/widgets/show_toast.dart';
import 'package:arkan_aleiraq/features/user/home.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/themes.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';
import '../../core/network/remote/dio_helper.dart';

class DetailsUser extends StatelessWidget {
  const DetailsUser({super.key, required this.id, required this.tittle, required this.images, required this.variants, required this.productIndex,});

  static CarouselController carouselController = CarouselController();

  static int currentIndex = 0;
  final int productIndex;
  final int id;
  final String tittle;
  final List<String>? images;
  final List<Variant> variants;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if(state is UpdateVariantsSuccessState){
              showToastSuccess(
                text: 'تم الامر بنجاح',
                context: context,
              );
              navigateAndFinish(context, HomeUser());
            }
          },
          builder: (context, state) {
            var cubit=AppCubit.get(context);
            return WillPopScope(
              onWillPop: () async {
                navigateAndFinish(context, HomeUser());
                return false;
              },
              child: SafeArea(
                child: Scaffold(
                  body: Stack(
                    children: [
                      Column(
                          children: [
                            CustomAppBarBack(),
                            SizedBox(height: 12,),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 373,
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(borderRadius:
                                      BorderRadius.circular(16)),
                                      child: Stack(
                                        children: [
                                          CarouselSlider(
                                            items:images!.map((entry) {
                                              return Builder(
                                                builder: (BuildContext context) {
                                                  return SizedBox(
                                                    width: double.maxFinite,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(16.0),
                                                      child: Image.network(
                                                        "$url/uploads/$entry",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }).toList(),
                                            options: CarouselOptions(
                                              height: 343,
                                              viewportFraction: 0.94,
                                              enlargeCenterPage: true,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: true,
                                              autoPlay: true,
                                              autoPlayInterval: const Duration(seconds: 6),
                                              autoPlayAnimationDuration:
                                              const Duration(seconds: 1),
                                              autoPlayCurve: Curves.fastOutSlowIn,
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index, reason) {
                                                currentIndex=index;
                                                cubit.slid();

                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(bottom: 16),
                                            width: double.maxFinite,
                                            height: double.maxFinite,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: images!.asMap().entries.map((entry) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    carouselController.animateTo(
                                                      entry.key.toDouble(),
                                                      duration: Duration(milliseconds: 500),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  },
                                                  child: Container(
                                                    width: currentIndex == entry.key ? 8 : 8,
                                                    height: 7.0,
                                                    margin: const EdgeInsets.symmetric(
                                                      horizontal: 3.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: currentIndex == entry.key
                                                            ? primaryColor
                                                            : Colors.white),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  tittle,
                                                  style: TextStyle(fontSize: 20, color: Colors.black87),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20,),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: variants.length,
                                            itemBuilder: (context, i) {
                                              final variant = variants[i];
                                              return variants[i].status== "قيد التجهيز"? Container(
                                                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                  border: Border.all(color: Colors.grey.shade200),
                                                ),
                                                child: Row(
                                                  children: [
                                                   state is! DeleteVariantsLoadingState?
                                                   GestureDetector(
                                                      onTap: (){
                                                        cubit.updateVariants(idVariants: variant.id.toString(), context: context);
                                                      },
                                                      child: Container(
                                                        width: 60,
                                                        height: 40,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                                          color: primaryColor,
                                                        ),
                                                        child: Center(child: Text('اتمام',style: TextStyle(color: Colors.white),)),
                                                      ),
                                                    ):CircularProgressIndicator(color: primaryColor,),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          variant.size != ' '? Text(
                                                            "المقاس: ${variant.size ?? '-'}",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black87,
                                                            ),
                                                            textAlign: TextAlign.right,
                                                          ):Container(),
                                                          const SizedBox(height: 4),
                                                          variant.color != ' '? Text(
                                                            "اللون: ${variant.color.trim().isEmpty ? 'غير محدد' : variant.color}",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.grey[600],
                                                            ),
                                                            textAlign: TextAlign.right,
                                                          ):Container(),
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            "المرسل: ${variant.creator.name}",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.grey[600],
                                                            ),
                                                            textAlign: TextAlign.right,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue.shade50,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Icon(Icons.inventory_2_outlined, color: Colors.blueAccent),
                                                    ),
                                                  ],
                                                ),
                                              ):Container();
                                            },
                                          ),
                                          SizedBox(height: 20,),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                  ],
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
