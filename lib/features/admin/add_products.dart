import 'dart:io';

import 'package:arkan_aleiraq/core/widgets/app_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../../core/widgets/background.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';

class AddProducts extends StatelessWidget {
  const AddProducts({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController tittleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AddProductsSuccessState){
            AppCubit.get(context).selectedImages=[];
            tittleController.text='';
            showToastSuccess(
              text: "تمت العملية بنجاح",
              context: context,
            );
          }
        },
        builder: (context,state){
          var cubit=AppCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body:Stack(
                children: [
                  SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        CustomAppBarBack(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                const SizedBox(height: 50),
                                GestureDetector(
                                    onTap:(){
                                      cubit.pickImages();
                                    },
                                    child:
                                    cubit.selectedImages.isEmpty?
                                    Image.asset('assets/images/Group 1171275632 (1).png'):Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ClipOval(
                                        child: Image.file(
                                          File(cubit.selectedImages[0].path),
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  controller: tittleController,
                                  hintText: 'العنوان',
                                  prefixIcon: Icons.title,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'رجائا اخل العنوان';
                                    }
                                  },
                                ),
                                const SizedBox(height: 60),
                                ConditionalBuilder(
                                  condition: state is !AddProductsLoadingState,
                                  builder: (context){
                                    return GestureDetector(
                                      onTap: (){
                                        if (formKey.currentState!.validate()) {
                                          cubit.addProducts(
                                              tittle: tittleController.text.trim(),
                                              context: context);
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 48,
                                        decoration: BoxDecoration(
                                            borderRadius:  BorderRadius.circular(12),
                                            color: primaryColor,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            )
                                        ),
                                        child: Center(
                                          child: Text('اضافة المنتج',
                                            style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                        ),
                                      ),
                                    );
                                  },
                                  fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
