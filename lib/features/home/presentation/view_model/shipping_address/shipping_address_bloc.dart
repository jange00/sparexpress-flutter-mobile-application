import 'package:flutter_bloc/flutter_bloc.dart';
import 'shipping_address_event.dart';
import 'shipping_address_state.dart';
import 'package:sparexpress/features/home/domin/use_case/shipping/get_all_shipping_addresses_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/shipping/create_shipping_address_usecase.dart';
import 'package:sparexpress/features/home/domin/use_case/shipping/delete_shipping_address_usecase.dart';
import 'package:sparexpress/features/home/domin/entity/shipping_entity.dart';

class ShippingAddressBloc extends Bloc<ShippingAddressEvent, ShippingAddressState> {
  final GetAllShippingAddressUsecase getAllShippingAddressUsecase;
  final CreateShippingAddressUsecase createShippingAddressUsecase;
  final DeleteShippingAddressUsecase deleteShippingAddressUsecase;

  ShippingAddressBloc({
    required this.getAllShippingAddressUsecase,
    required this.createShippingAddressUsecase,
    required this.deleteShippingAddressUsecase,
  }) : super(ShippingAddressInitial()) {
    on<FetchAddresses>(_onFetchAddresses);
    on<AddAddress>(_onAddAddress);
    on<SelectAddress>(_onSelectAddress);
    on<DeleteAddress>(_onDeleteAddress);
  }

  Future<void> _onFetchAddresses(FetchAddresses event, Emitter emit) async {
    emit(ShippingAddressLoading());
    final result = await getAllShippingAddressUsecase(event.userId);
    result.fold(
      (failure) => emit(ShippingAddressError(failure.message)),
      (addresses) => emit(ShippingAddressLoaded(addresses)),
    );
  }

  Future<void> _onAddAddress(AddAddress event, Emitter emit) async {
    emit(ShippingAddressLoading());
    final result = await createShippingAddressUsecase(event.address);
    result.fold(
      (failure) => emit(ShippingAddressError(failure.message)),
      (_) async {
        final addressesResult = await getAllShippingAddressUsecase(event.address.userId);
        addressesResult.fold(
          (failure) => emit(ShippingAddressError(failure.message)),
          (addresses) => emit(ShippingAddressLoaded(addresses)),
        );
      },
    );
  }

  void _onSelectAddress(SelectAddress event, Emitter emit) {
    emit(ShippingAddressSelected(event.address));
  }

  Future<void> _onDeleteAddress(DeleteAddress event, Emitter emit) async {
    emit(ShippingAddressLoading());
    final result = await deleteShippingAddressUsecase(event.addressId);
    result.fold(
      (failure) => emit(ShippingAddressError(failure.message)),
      (_) async {
        // TODO: Pass the correct userId here. This may require storing the last used userId in the bloc state.
        final addressesResult = await getAllShippingAddressUsecase(''); // <-- Fix this by passing the correct userId
        addressesResult.fold(
          (failure) => emit(ShippingAddressError(failure.message)),
          (addresses) => emit(ShippingAddressLoaded(addresses)),
        );
      },
    );
  }
} 