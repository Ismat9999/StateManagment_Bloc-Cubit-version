import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/models/log_service.dart';
import '../../data/models/random_user_list_res.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';
import '../views/view_error.dart';
import '../views/view_of_loading.dart';
import '../widgets/item_of_random_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit homeCubit;
  ScrollController scrollController= ScrollController();


  @override
  void initState() {
    super.initState();
homeCubit= BlocProvider.of<HomeCubit>(context);
homeCubit.onloadRandomUserList();

    scrollController.addListener((){
      if (scrollController.position.maxScrollExtent <= scrollController.offset){
        LogService.i(homeCubit.currentPage.toString());
        homeCubit.onloadRandomUserList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232,232, 232, 1),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:  const Text("Bloc - Cubit"),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current){
          return current is HomeRandomUserListState;
        },
        builder: (context, state){
          if(state is HomeErrorState){
            return viewError(state.errorMessage);
          }
          if(state is HomeRandomUserListState){
            var userList= state.userList;
            return viewOfRandomUserList(userList);
          }
          return viewOfLoading();
        },
      ),
    );
  }
  Widget viewOfRandomUserList(List<RandomUser> userList){
    return ListView.builder(
      controller: scrollController,
      itemCount: userList.length,
      itemBuilder: (ctx, index){
        return itemOfRandomUser(userList[index], index);
      },
    );
  }
}

