import 'package:arkan_aleiraq/core/%20navigation/navigation.dart';
import 'package:arkan_aleiraq/features/admin/add_products.dart';
import 'package:arkan_aleiraq/features/admin/add_sender.dart';
import 'package:arkan_aleiraq/features/admin/add_user.dart';
import 'package:arkan_aleiraq/features/agent/details.dart';
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


class HomeAgent extends StatelessWidget {
  const HomeAgent({super.key});

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          cubit.getProductsByVariantsModel.isNotEmpty?
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
                              childCount: cubit.getProductsByVariantsModel.length, (context, index) {
                              String rawImageUrl = cubit.getProductsByVariantsModel[index].images[0];
                              String cleanImageUrl = rawImageUrl.replaceAll(RegExp(r'[\[\]]'), '');
                              return GestureDetector(
                                onTap: (){
                                  navigateTo(context, Details(
                                      id: cubit.getProductsByVariantsModel[index].id.toString(),
                                      tittle: cubit.getProductsByVariantsModel[index].title,
                                      images: cubit.getProductsByVariantsModel[index].images,
                                    variants: cubit.getProductsByVariantsModel[index].variants,
                                  ),
                                  );
                                },
                                child: Container(
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
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  cubit.getProductsByVariantsModel[index].title,
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
