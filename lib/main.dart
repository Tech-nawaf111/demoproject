import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    return BlocProvider(
      create: (_) => ItemCubit(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: "Go router",
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const ProductsScreen(),
      routes: [
        GoRoute(
          path: ":itemId",
          builder: (context, state) => const ItemPage(),
        ),
      ],
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
        title: const Text('Cart Page'),
      ),
      body: BlocBuilder<ItemCubit, int>(
        builder: (context, state) {
          final bloc = context.read<ItemCubit>();
          return StreamBuilder<List<Item>>(
            stream: bloc.cart$.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              final results = snapshot.data!;
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  return ListTile(
                    onTap: () {
                      context.push("/${item.name}");
                    },
                    title: Text(item.name),
                    subtitle: Text(item.price.toString()),
                    trailing: IconButton(
                      onPressed: () {
                        bloc.removeFromCart(item);
                      },
                      icon: const Icon(Icons.remove_shopping_cart),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items Page'),
        actions: [
          BlocBuilder<ItemCubit, int>(
            builder: (context, state) {
              if (state > 0) {
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.push("/cart");
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
                          state.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return IconButton(
                  onPressed: () {
                    context.push("/cart");
                  },
                  icon: const Icon(Icons.shopping_cart),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ItemCubit, int>(
        builder: (context, state) {
          final bloc = context.read<ItemCubit>();
          return StreamBuilder<List<Item>>(
            stream: bloc.products$.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              final results = snapshot.data!;
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  return ListTile(
                    onTap: () {
                      context.push("/${index}");
                    },
                    title: Text(item.name),
                    subtitle: Text(item.price.toString()),
                    trailing: IconButton(
                      onPressed: () {
                        bloc.addToCart(item);
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ItemPage extends StatelessWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details Page'),
      ),
      body: const Center(
        child: Text('I am item page'),
      ),
    );
  }
}
