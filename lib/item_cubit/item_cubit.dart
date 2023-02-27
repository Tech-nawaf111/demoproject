import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../model/item_model.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit() : super(ItemListLoaded());

    final BehaviorSubject<List<Item>> products = BehaviorSubject.seeded(
      [
        Item(name: 'Item 1', price: 10.0),
        Item(name: 'Item 2', price: 15.0),
        Item(name: 'Item 3', price: 20.0),
        Item(name: 'Item 4', price: 25.0),
        Item(name: 'Item 5', price: 30.0),
        Item(name: 'Item 6', price: 35.0),
        Item(name: 'Item 7', price: 40.0),
        Item(name: 'Item 8', price: 45.0),
        Item(name: 'Item 9', price: 50.0),
      ]);

  final BehaviorSubject<List<Item>> cart = BehaviorSubject.seeded([]);
  Stream<List<Item>> get itemListStream => products.stream;

  void addToCart(Item item) {

    final updatedList = List<Item>.from(products.value)..remove(item);
    products.add(updatedList);
    emit(CartListLoaded(itemListStream));
   emit(ItemCounterUpdated(cart.value.length));

  }

  // void removeFromCart(Item item) {
  //   products.add(cart.value!..remove(item));
  //   emit(CartListLoaded(cart));
  //   emit(ItemCounterUpdated(cart.length as int));
  // }
}

