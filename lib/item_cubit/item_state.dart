part of 'item_cubit.dart';

@immutable
abstract class ItemState {}

class ItemListLoaded extends ItemState {}

class CartListLoaded extends ItemState {
  final Stream<List<Item>> listVal ;

  CartListLoaded(this.listVal);
}

class ItemCounterUpdated extends ItemState {
  final int itemCount;

  ItemCounterUpdated(this.itemCount);
}
