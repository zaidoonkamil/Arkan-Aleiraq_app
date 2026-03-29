import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_bar.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';


class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  static ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getAllUser(context: context),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  CustomAppBarBack(),
                  SizedBox(height: 18),

                  if (state is GetAllUserLoadingState)
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )

                  else if (cubit.allUserModel != null &&
                      cubit.allUserModel!.users.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        controller: AllUsers.scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: cubit.allUserModel!.users.length,
                        itemBuilder: (context, index) {
                          var user = cubit.allUserModel!.users[index];

                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: ListTile(
                              title: Text(user.name),
                              subtitle: Text(user.phone),
                              leading: CircleAvatar(
                                child: Text(
                                  (user.name.isNotEmpty)
                                      ? user.name[0].toUpperCase() : '?',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )

                  else
                    Expanded(
                      child: Center(
                        child: Text("No Users Found"),
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
