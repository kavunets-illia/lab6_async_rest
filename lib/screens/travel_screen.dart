import 'package:flutter/material.dart';
import '../models/travel_destination.dart';
import '../services/api_service.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  late Future<List<TravelDestination>> _destinationsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _destinationsFuture = _apiService.getDestinations();
  }

  void _refreshData() {
    setState(() {
      _destinationsFuture = _apiService.getDestinations();
    });
  }

  Stream<int> discountTimerStream() async* {
    int secondsLeft = 120;
    while (secondsLeft > 0) {
      await Future.delayed(const Duration(seconds: 1));
      secondsLeft--;
      yield secondsLeft;
    }
  }

  Future<void> _addNewDestination() async {
    try {
      final created = await _apiService.createDestination(
        'Карпати: Говерла та Буковель',
        'Екскурсійний тур вихідного дня з трансфером та гідом.',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Створено тур: ${created.title} (ID: ${created.id})')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка створення: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Туристичний додаток'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Додати тур (POST)',
            onPressed: _addNewDestination,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.amber.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, color: Colors.deepOrange),
                const SizedBox(width: 8),
                StreamBuilder<int>(
                  stream: discountTimerStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Ініціалізація акції...');
                    }
                    return Text(
                      'Гаряча пропозиція діє ще: ${snapshot.data} сек.',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshData();
                await _destinationsFuture;
              },
              child: FutureBuilder<List<TravelDestination>>(
                future: _destinationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${snapshot.error}', textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _refreshData,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Туристичні напрямки відсутні.'));
                  } else {
                    final items = snapshot.data!;
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${item.id}')),
                            title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                            trailing: Text('${item.price.toStringAsFixed(0)} \$'),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
