import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:ecommerce/features/product/domain/usecases/fetch_prouct_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProuctUseCase getProducts;

  ProductBloc(this.getProducts) : super(ProductInitial()) {
    on<GetProductEvent>((event, emit) async {
      emit(ProductLoading());
      final result = await getProducts();
      result.fold(
        (failure) => emit(ProductError("failed to fetch product")),
        (products) => emit(ProductLoaded(products)),
      );
    });
  }
}

