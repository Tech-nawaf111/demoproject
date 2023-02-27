import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';

import 'item_cubit/item_cubit.dart';
import 'model/item_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: "Go router",
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
      path: "/cart",
      builder: (context, state) => const CartPage(),
    )
  ],
);

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Cart Page"),
      ),
      body: const Center(
        child: Text("Cart Page"),
      ),
    );
  }
}


class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemCubit(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Items Page'),
            actions: [
              BlocBuilder<ItemCubit, ItemState>(
                builder: (context, state) {
                  if (state is ItemCounterUpdated) {
                    return Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.go("/cart");
                          },
                          icon: const Icon(Icons.shopping_cart),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              state.itemCount.toString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return IconButton(
                      onPressed: () {
                        context.go("/cart");
                      },
                      icon: const Icon(Icons.shopping_cart),
                    );
                  }
                },
              ),
            ],
          ),
          body: BlocBuilder<ItemCubit, ItemState>(
            builder: (context, state) {
              if (state is ItemListLoaded) {
                return StreamBuilder<List<Item>>(
                    stream: context.read<ItemCubit>().itemListStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      final results = snapshot.data;
                      return ListView.builder(
                        itemCount: results?.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(results?[index].name == null
                                ? ""
                                : results?[index].name as String),
                            subtitle: Text(results?[index].price == null
                                ? ""
                                : results?[index].price.toString() as String),
                            trailing: IconButton(
                              onPressed: () {
                                context
                                    .read<ItemCubit>()
                                    .addToCart(results?[index] as Item);
                              },
                              icon: const Icon(Icons.add_shopping_cart),
                            ),
                          );
                        },
                      );
                    });
              } else {
                return Container();
              }
            },
          )),
    );
  }
}
