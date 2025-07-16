import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:sparexpress/features/auth/domain/entity/customer_entity.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:sparexpress/features/auth/domain/use_case/customer_get_current_usecase.dart';
import 'package:sparexpress/core/error/failure.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final CustomerGetCurrentUseCase getCurrentCustomer;

  ProfileBloc({required this.getCurrentCustomer}) : super(ProfileInitial()) {
    on<FetchCustomerProfile>((event, emit) async {
      emit(ProfileLoading());

      final Either<Failure, CustomerEntity> result = await getCurrentCustomer();

      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (customer) => emit(ProfileLoaded(customer)),
      );
    });
  }
}
