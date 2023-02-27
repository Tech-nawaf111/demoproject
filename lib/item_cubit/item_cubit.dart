import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../model/item_model.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<int> {
  ItemCubit() : super(0);

  final BehaviorSubject<List<Item>> products$ = BehaviorSubject.seeded([
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

  final BehaviorSubject<List<Item>> cart$ = BehaviorSubject.seeded([]);

  void addToCart(Item item) {
    final items = products$.valueOrNull;
    if (items == null) return;
    items.removeWhere((element) => element.name == item.name);
    products$.add(items);

    final cart = cart$.valueOrNull;
    if (cart == null) return;
    cart.add(item);
    cart$.add(cart);
    emit(cart.length);
  }

  void removeFromCart(Item item) {
    final cart = cart$.valueOrNull;
    if (cart == null) return;
    cart.removeWhere((element) => element.name == item.name);
    cart$.add(cart);
    final items = products$.valueOrNull;
    if (items == null) return;
    items.add(item);
    products$.add(items);
    emit(cart.length);
  }
}
