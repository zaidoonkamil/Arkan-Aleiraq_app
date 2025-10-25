import 'package:arkan_aleiraq/core/%20navigation/navigation.dart';
import 'package:arkan_aleiraq/features/admin/add_products.dart';
import 'package:arkan_aleiraq/features/admin/add_sender.dart';
import 'package:arkan_aleiraq/features/admin/add_user.dart';
import 'package:arkan_aleiraq/features/agent/details.dart';
import 'package:arkan_aleiraq/features/user/details.dart';
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


class HomeUser extends StatelessWidget {
  const HomeUser({super.key});

  static ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getProductsByVariants(context: context),
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
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        signOut(context);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        width: double.maxFinite,
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent,
                        ),
                        child: Center(child: Text('تسجيل الخروج',style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                    SizedBox(height: 18,),
                    state is! GetProductsLoadingState?
                    cubit.getProductsByVariantsModel.isNotEmpty?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                          itemCount: cubit.getProductsByVariantsModel.length,
                          itemBuilder:(context,index){
                            String rawImageUrl = cubit.getProductsByVariantsModel[index].images[0];
                            String cleanImageUrl = rawImageUrl.replaceAll(RegExp(r'[\[\]]'), '');
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  navigateTo(context, DetailsUser(
                                      productIndex: index,
                                      id: cubit.getProductsByVariantsModel[index].id,
                                      tittle: cubit.getProductsByVariantsModel[index].title,
                                      images: cubit.getProductsByVariantsModel[index].images,
                                      variants: cubit.getProductsByVariantsModel[index].variants,
                                  ));
                                },
                                child: Container(
                                  height: 120,
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
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              cubit.getProductsByVariantsModel[index].title,
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.end,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  cubit.getProductsByVariantsModel[index].variants.length.toString(),
                                                  style: TextStyle(fontSize: 14),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(width: 2,),
                                                Text(
                                                  ':التحديثات',
                                                  style: TextStyle(fontSize: 14,color: primaryColor),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 6,),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          '$url/uploads/$cleanImageUrl',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 6,),
                            ],
                          );
                        }),
                    ):Center(child: Text('لا يوجد بيانات')):
                    CircularProgressIndicator(color: primaryColor,),
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
