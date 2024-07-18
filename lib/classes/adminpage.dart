//sqflite code
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OrderDetails {
  final int id;
  final String foodName;
  final String foodImage;
  final String foodPrice;
  final String paymentMethod;
  final bool cashOnDelivery;
  final String uniqueCode;

  OrderDetails({
    required this.id,
    required this.foodName,
    required this.foodImage,
    required this.foodPrice,
    required this.paymentMethod,
    required this.cashOnDelivery,
    required this.uniqueCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodName': foodName,
      'foodImage': foodImage,
      'foodPrice': foodPrice,
      'paymentMethod': paymentMethod,
      'cashOnDelivery': cashOnDelivery ? 1 : 0,
      'uniqueCode': uniqueCode,
    };
  }

  factory OrderDetails.fromMap(Map<String, dynamic> map) {
    return OrderDetails(
      id: map['id'],
      foodName: map['foodName'],
      foodImage: map['foodImage'],
      foodPrice: map['foodPrice'],
      paymentMethod: map['paymentMethod'],
      cashOnDelivery: map['cashOnDelivery'] == 1 ? true : false,
      uniqueCode: map['uniqueCode'],
    );
  }
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<OrderDetails> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final Database db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query('orders');
    setState(() {
      _orders = List.generate(maps.length, (i) {
        return OrderDetails.fromMap(maps[i]);
      });
    });
  }

  Future<Database> _openDatabase() async {
    final String path = join(await getDatabasesPath(), 'order_database.db');
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE orders(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          foodName TEXT,
          foodImage TEXT,
          foodPrice TEXT,
          paymentMethod TEXT,
          cashOnDelivery INTEGER,
          uniqueCode TEXT
        )
      ''');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Order ID: ${_orders[index].id.toString()}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Food Name: ${_orders[index].foodName}'),
                Text('Food Image: ${_orders[index].foodImage}'),
                Text('Price: ${_orders[index].foodPrice}'),
                Text('Payment Method: ${_orders[index].paymentMethod}'),
                Text('Cash on Delivery: ${_orders[index].cashOnDelivery ? 'Yes' : 'No'}'),
                Text('Unique Code: ${_orders[index].uniqueCode}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

//firebase code
/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orders = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index].data() as Map<String, dynamic>;

                return ListTile(
                  title: Text(order['foodName']),
                  subtitle: Text(order['foodPrice']),
                  // Display other order details as needed
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
} */
