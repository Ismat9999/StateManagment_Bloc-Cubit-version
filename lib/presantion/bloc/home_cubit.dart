import 'package:bloc/bloc.dart';
import 'package:smbloccubit/data/datasources/remote/http_service.dart';
import 'package:smbloccubit/data/models/random_user_list_res.dart';
import 'package:smbloccubit/presantion/bloc/home_state.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit() : super(HomeInitialState());

  List<RandomUser> userList= [];
  int currentPage= 0;

  Future<void>onloadRandomUserList()async{
    emit(HomeLoadingState());
    var response=  await Network.GET(Network.API_RANDOM_USER_LIST, Network.paramsRandomUserList(currentPage));
    if(response! == null){
      var results =Network.parseRandomUserList(response).results;
      userList.addAll(results);
      currentPage++;
      emit(HomeRandomUserListState(userList));
    }else{
      emit(HomeErrorState("Couldn't fetch posts"));
    }
  }
}