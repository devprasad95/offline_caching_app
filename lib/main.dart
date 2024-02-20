import 'package:flutter/material.dart';
import 'package:offline_caching_app/random_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (_) => RandomProvider(),
        ),
      ], child: const HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final randomProvider = Provider.of<RandomProvider>(context);
    randomProvider.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<RandomProvider>(builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemCount: provider.randomDatas.length,
              itemBuilder: (context, index) {
                final randomData = provider.randomDatas[index];
                return ListTile(
                  title: Text("${randomData.id} ${randomData.title}"),
                  subtitle: Text(randomData.body ?? ''),
                );
              });
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          Provider.of<RandomProvider>(context, listen: false).fetchDatas();
        },
      ),
    );
  }
}
