import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/profile/domain/repositories/userprofile_repo.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';

class ProfileCubit extends Cubit <ProfileState>{
  final UserprofileRepo userprofileRepo;

  ProfileCubit({required this.userprofileRepo}) : super(IntialProfileState());

  Future<void> fetchUserProfile(String userId) async{
    try {
      emit(UserProfileUserDetailsLoadingState());
      final user = await userprofileRepo.getuserProfile(userId);

      if(user != null){
        emit(UserProfileUserDetailsLoadedState(user));

      }else{
        emit(UserProfileUserDetailsFailedState("No user found"));
      }
    } catch (e) {
      emit(UserProfileUserDetailsFailedState(e.toString()));
    }
  }
}