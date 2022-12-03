import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leggo/bloc/bloc/auth/bloc/auth_bloc.dart';
import 'package:leggo/repository/database/database_repository.dart';
import 'package:leggo/repository/purchases_repository.dart';

import 'package:meta/meta.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'purchases_event.dart';
part 'purchases_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  Package? selectedPackage;
  final PurchasesRepository _purchasesRepository;
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;

  StreamSubscription? authStateStream;
  PurchasesBloc(
      {required PurchasesRepository purchasesRepository,
      required AuthBloc authBloc,
      required DatabaseRepository databaseRepository})
      : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        _purchasesRepository = purchasesRepository,
        super(PurchasesLoading()) {
    print(state.toString());
    authStateStream = _authBloc.stream.listen((state) async {
      if (state.status == AuthStatus.authenticated) {
        add(LoadPurchases());
      }
    });
    on<PurchasesEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is LoadPurchases) {
        print('LOADING PURCHASES***');
        if (state is PurchasesLoading == false) {
          emit(PurchasesLoading());
        }

        // * Check Revenue Cat for Subscription Status
        CustomerInfo? customerInfo =
            await _purchasesRepository.getCustomerInfo();
        bool? isSubscribed =
            await _purchasesRepository.getSubscriptionStatus(customerInfo!);

        // * Fetch offerings & products
        Offerings? offerings = await _purchasesRepository.getOfferings();
        List<StoreProduct>? products;

        products = await _purchasesRepository
            .getProducts(customerInfo.allPurchasedProductIdentifiers);
        print('Products: ${products!.first.toString()}');
        emit(PurchasesLoaded(
            offerings: offerings,
            isSubscribed: isSubscribed,
            customerInfo: customerInfo,
            products: products));
      }
      if (event is AddPurchase) {
        emit(PurchasesLoading());
        await _purchasesRepository.makePurchase(event.package);
        emit(PurchasesUpdated());

        add(LoadPurchases());
      }
      if (event is EditPurchase) {}
      if (event is RemovePurchase) {}
      if (event is RestorePurchases) {
        emit(PurchasesLoading());
        CustomerInfo? customerInfo =
            await _purchasesRepository.restorePurchases();
        emit(PurchasesUpdated());
        add(LoadPurchases());
      }
      if (event is SelectPackage) {
        selectedPackage = event.package;
      }
    });
  }
  @override
  Future<void> close() {
    // TODO: implement close
    authStateStream?.cancel();
    return super.close();
  }
}
