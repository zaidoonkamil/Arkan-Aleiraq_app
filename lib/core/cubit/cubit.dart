import 'package:arkan_aleiraq/core/cubit/states.dart';
import 'package:arkan_aleiraq/core/model/GetProductsByVariants.dart';
import 'package:arkan_aleiraq/core/widgets/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../model/GetProducts.dart';
import '../network/remote/dio_helper.dart';
import '../widgets/show_toast.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  void slid(){
    emit(ValidationState());
  }

  List<XFile> selectedImages = [];
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> resultList = await picker.pickMultiImage();

    if (resultList.isNotEmpty) {
      selectedImages = resultList;
      emit(SelectedImagesState());
    }
  }

  addProducts({required String tittle, required BuildContext context,})async{
    emit(AddProductsLoadingState());
    if (selectedImages.isEmpty) {
      showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
      emit(AddProductsErrorState());
      return;
    }
    FormData formData = FormData.fromMap(
        {
          'title': tittle,
        },
        ListFormat.multiCompatible
    );

    for (var file in selectedImages) {
      formData.files.add(
        MapEntry(
          "images",
          await MultipartFile.fromFile(
            file.path, filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    DioHelper.postData(
      url: '/products',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      emit(AddProductsSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddProductsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


  List<GetProducts> getProductsModel = [];
  void getProducts({required BuildContext context,}) {
    emit(GetProductsLoadingState());
    DioHelper.getData(
      url: '/products',
    ).then((value) {
      getProductsModel = (value.data as List)
          .map((item) => GetProducts.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetProductsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        print(error.toString());
        emit(GetProductsErrorState());
        }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<GetProductsByVariants> getProductsByVariantsModel = [];
  void getProductsByVariants({required BuildContext context,}) {
    emit(GetProductsLoadingState());
    DioHelper.getData(
      url: '/products-with-variants?user_id=$id',
    ).then((value) {
      getProductsByVariantsModel = (value.data as List)
          .map((item) => GetProductsByVariants.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetProductsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        print(error.toString());
        emit(GetProductsErrorState());
        }else {
        print("Unknown Error: $error");
      }
    });
  }

  void deleteProducts({required String idProducts,required BuildContext context}) {
    emit(DeleteProductsLoadingState());

    DioHelper.deleteData(
      url: '/products/$idProducts',
    ).then((value) {
      getProductsModel.removeWhere((Products) => Products.id.toString() == idProducts);
      showToastSuccess(
        text: 'تم الحذف بنجاح',
        context: context,
      );
      emit(DeleteProductsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),context: context,);
        print(error.toString());
        emit(DeleteProductsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addVariants({required String color,required String size,required String idd, required BuildContext context,})async{
    emit(AddVariantsLoadingState());
    DioHelper.postData(
      url: '/products/$idd/variants',
      data: {
        "color":color,
        "size":size,
        "userId": id,
      },
    ).then((value) {
      emit(AddVariantsSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddVariantsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void deleteVariants({required String idVariants, required int productIndex, required BuildContext context,}) {
    emit(DeleteVariantsLoadingState());
    DioHelper.deleteData(
      url: '/variants/$idVariants?user_id=$id',
    ).then((value) {
      emit(DeleteVariantsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(
          text: error.toString(),
          context: context,
        );
        emit(DeleteVariantsErrorState());
      } else {
        print("Unknown Error: $error");
      }
    });
  }

  void updateVariants({required String idVariants,required BuildContext context,}) {
    emit(UpdateVariantsLoadingState());
    DioHelper.putData(
      url: '/variants/$idVariants/complete',
      data: {
        "user_id": id,
      }
    ).then((value) {
      emit(UpdateVariantsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(
          text: error.toString(),
          context: context,
        );
        emit(UpdateVariantsErrorState());
      } else {
        print("Unknown Error: $error");
      }
    });
  }

}