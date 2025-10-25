import 'package:arkan_aleiraq/core/%20navigation/navigation.dart';
import 'package:arkan_aleiraq/features/admin/add_products.dart';
import 'package:arkan_aleiraq/features/admin/add_sender.dart';
import 'package:arkan_aleiraq/features/admin/add_user.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/styles/themes.dart';
import '../../../core/widgets/app_bar.dart';
import '../../../core/widgets/circular_progress.dart';
import '../../../core/widgets/constant.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';
import '../../core/network/remote/dio_helper.dart';


class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  static ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getProducts(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    CustomAppBar(),
                    SizedBox(height: 18,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              navigateTo(context, AddSender());
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 40,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                color: primaryColor,
                              ),
                              child: Center(child: Text('اضافة مرسل',style: TextStyle(color: Colors.white),)),
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: (){
                              navigateTo(context, AddUser());
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 40,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                color: primaryColor,
                              ),
                              child: Center(child: Text('اضافة مستقبل',style: TextStyle(color: Colors.white),)),
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: (){
                              navigateTo(context, AddProducts());
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 40,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                color: primaryColor,
                              ),
                              child: Center(child: Text('اضافة منتج',style: TextStyle(color: Colors.white),)),
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: (){
                              signOut(context);
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 40,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                color: Colors.redAccent,
                              ),
                              child: Center(child: Text('تسجيل الخروج',style: TextStyle(color: Colors.white),)),
                            ),
                          ),
                          SizedBox(height: 10,),
                          cubit.getProductsModel.isNotEmpty?
                          GridView.custom(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            controller: scrollController,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 1,
                              childAspectRatio: 0.6,
                            ),
                            childrenDelegate: SliverChildBuilderDelegate(
                              childCount: cubit.getProductsModel.length, (context, index) {

                              String rawImageUrl = cubit.getProductsModel[index].images[0];
                              String cleanImageUrl = rawImageUrl.replaceAll(RegExp(r'[\[\]]'), '');
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1.0,
                                  ),
                                  color: containerColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        '$url/uploads/$cleanImageUrl',
                                        width: double.maxFinite,
                                        height: 143,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap:(){
                                            cubit.deleteProducts(idProducts: cubit.getProductsModel[index].id.toString(), context: context);
                                          },
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                cubit.getProductsModel[index].title,
                                                style: TextStyle(fontSize: 14),
                                                textAlign: TextAlign.end,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 6,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Spacer(),
                                  ],
                                ),
                              );
                            },
                            ),
                          ):
                          CircularProgressIndicator(color: primaryColor,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
