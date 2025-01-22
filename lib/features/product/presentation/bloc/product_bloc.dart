import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:ecommerce/features/product/domain/usecases/add_to_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/fetch_prouct_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/get_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/remove_from_cart_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProuctUseCase getProducts;
 
   
  List<ProductModel> _productModel = [];
  List<Map<String,dynamic>> _cachedCart= [];

  ProductBloc(this.getProducts) : super(ProductInitial()) {

    on<GetProductEvent>((event, emit) async {
      emit(ProductLoading());

    if(_productModel.isNotEmpty){
      emit(ProductLoaded(_productModel));
      return ;
    }


      final result = await getProducts();
      result.fold(
        (failure) => emit(ProductError("failed to fetch product")),
        (products) => emit(ProductLoaded(products)),
      );
    });
    
  }
}


