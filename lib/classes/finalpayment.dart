//sqflite code
import 'dart:math';
import 'dart:ui' show BuildContext;
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

class PaymentPage1 extends StatefulWidget {
  final String foodName;
  final String foodImage;
  final String foodPrice;

  PaymentPage1({
    required this.foodName,
    required this.foodImage,
    required this.foodPrice,
  });

  @override
  _PaymentPage1State createState() => _PaymentPage1State();
}

class _PaymentPage1State extends State<PaymentPage1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'Credit Card';
  bool _cashOnDelivery = false;
  String _uniqueCode = '';

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

  Future<void> _insertOrder(OrderDetails order) async {
    final Database db = await _openDatabase();
    await db.insert('orders', order.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void _confirmPayment(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _uniqueCode = Random().nextInt(100).toString();

      OrderDetails order = OrderDetails(
        id: 0,
        foodName: widget.foodName,
        foodImage: widget.foodImage,
        foodPrice: widget.foodPrice,
        paymentMethod: _paymentMethod,
        cashOnDelivery: _cashOnDelivery,
        uniqueCode: _uniqueCode,
      );

      await _insertOrder(order);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Food Name: ${widget.foodName}'),             
              Text('Food Image: ${widget.foodImage}'),
              Text('Price: ${widget.foodPrice}'),
              Text('Payment Method: $_paymentMethod'),
              Text('Cash on Delivery: ${_cashOnDelivery ? 'Yes' : 'No'}'),
              Text('Unique Code: $_uniqueCode'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Amount: ${widget.foodPrice}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Credit Card',
                    child: Text('Credit Card'),
                  ),
                  DropdownMenuItem(
                    value: 'Debit Card',
                    child: Text('Debit Card'),
                  ),
                  DropdownMenuItem(
                    value: 'Net Banking',
                    child: Text('Net Banking'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _cashOnDelivery,
                    onChanged: (value) {
                      setState(() {
                        _cashOnDelivery = value!;
                      });
                    },
                  ),
                  Text('Cash on Delivery'),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () => _confirmPayment(context),
                child: Text('Confirm Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

             


// firebase code 
/*import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentPage1 extends StatefulWidget {
  final String foodName;
  final String foodImage;
  final String foodPrice;

  PaymentPage1({
    required this.foodName,
    required this.foodImage,
    required this.foodPrice,
  });

  @override
  _PaymentPage1State createState() => _PaymentPage1State();
}

class _PaymentPage1State extends State<PaymentPage1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'Credit Card';
  bool _cashOnDelivery = false;
  String _uniqueCode = '';

  void _confirmPayment() {
    if (_formKey.currentState!.validate()) {
      // Generate a unique code
      _uniqueCode = Random().nextInt(100).toString();

      // Store the order details in Firebase
      FirebaseFirestore.instance.collection('orders').add({
        'foodName': widget.foodName,
        'foodImage': widget.foodImage,
        'foodPrice': widget.foodPrice,
        'paymentMethod': _paymentMethod,
        'cashOnDelivery': _cashOnDelivery,
        'uniqueCode': _uniqueCode,
        'timestamp': FieldValue.serverTimestamp(),
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Food Name: ${widget.foodName}'),
              Text('Food Image: ${widget.foodImage}'),
              Text('Price: ${widget.foodPrice}'),
              Text('Payment Method: $_paymentMethod'),
              Text('Cash on Delivery: ${_cashOnDelivery ? 'Yes' : 'No'}'),
              Text('Unique Code: $_uniqueCode'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Amount: ${widget.foodPrice}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Credit Card',
                    child: Text('Credit Card'),
                  ),
                  DropdownMenuItem(
                    value: 'Debit Card',
                    child: Text('Debit Card'),
                  ),
                  DropdownMenuItem(
                    value: 'Net Banking',
                    child: Text('Net Banking'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _cashOnDelivery,
                    onChanged: (value) {
                      setState(() {
                        _cashOnDelivery = value!;
                      });
                    },
                  ),
                  Text('Cash on Delivery'),
                ],
              ),
             Spacer(),
ElevatedButton(
onPressed: _confirmPayment,
child: Text('Confirm Payment'),
),
],
),
),
),
);
}
}
*/
// old code
/*import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PaymentPage1 extends StatefulWidget {
  final String foodName;
  final String foodImage;
  final String foodPrice;

  PaymentPage1({
    required this.foodName,
    required this.foodImage,
    required this.foodPrice,
  });

  @override
  _PaymentPage1State createState() => _PaymentPage1State();
}

class _PaymentPage1State extends State<PaymentPage1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'Credit Card';
  bool _cashOnDelivery = false;
  String _uniqueCode = '';

  void _confirmPayment() {
    if (_formKey.currentState!.validate()) {
      // Generate a unique code
      _uniqueCode = Random().nextInt(100).toString();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Food Name: ${widget.foodName}'),
              Text('Food Image: ${widget.foodImage}'),
              Text('Price: ${widget.foodPrice}'),
              Text('Payment Method: $_paymentMethod'),
              Text('Cash on Delivery: ${_cashOnDelivery ? 'Yes' : 'No'}'),
              Text('Unique Code: $_uniqueCode'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Amount: ${widget.foodPrice}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Credit Card',
                    child: Text('Credit Card'),
                  ),
                  DropdownMenuItem(
                    value: 'Debit Card',
                    child: Text('Debit Card'),
                  ),
                  DropdownMenuItem(
                    value: 'Net Banking',
                    child: Text('Net Banking'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _cashOnDelivery,
                    onChanged: (value) {
                      setState(() {
                        _cashOnDelivery = value!;
                      });
                    },
                  ),
                  Text('Cash on Delivery'),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _confirmPayment,
                child: Text('Confirm Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */
/*import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';

class PaymentPage1 extends StatefulWidget {
  final String foodName;
  final String foodImage;
  final String foodPrice;

  PaymentPage1({
    Key? key,
    required this.foodName,
    required this.foodImage,
    required this.foodPrice,
  }) : super(key: key);

  @override
  _PaymentPage1State createState() => _PaymentPage1State();
}

class _PaymentPage1State extends State<PaymentPage1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'Credit Card';
  bool _cashOnDelivery = false;
  String _uniqueCode = '';

  void _confirmPayment() {
    if (_formKey.currentState!.validate()) {
      // Generate a unique code
      _uniqueCode = Random().nextInt(1000000).toString();
      DatabaseReference dbRef = FirebaseDatabase.instance.reference();
    dbRef.child('orders').push().set({
      'foodName': widget.foodName,
      'foodImage': widget.foodImage,
      'foodPrice': widget.foodPrice,
      'paymentMethod': _paymentMethod,
      'cashOnDelivery': _cashOnDelivery,
      'uniqueCode': _uniqueCode,
    }); 
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Food Name: ${widget.foodName}'),
              Image.asset(
                widget.foodImage,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              Text('Price: ${widget.foodPrice}'),
              Text('Payment Method: $_paymentMethod'),
              Text('Cash on Delivery: ${_cashOnDelivery ? 'Yes' : 'No'}'),
              Text('Unique Code: $_uniqueCode'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = double.parse(widget.foodPrice);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Credit Card',
                    child: Text('Credit Card'),
                  ),
                  DropdownMenuItem(
                    value: 'Debit Card',
                    child: Text('Debit Card'),
                  ),
                  DropdownMenuItem(
                    value: 'Net Banking',
                    child: Text('Net Banking'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _cashOnDelivery,
                    onChanged: (value) {
                      setState(() {
                        _cashOnDelivery = value!;
                      });
                    },
                  ),
                  Text('Cash on Delivery'),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _confirmPayment,
                child: Text('Confirm Payment'),
              ),
            ],
      ),
    ),
  ),
);
}
}
*/


/*import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PaymentPages extends StatefulWidget {
  
  final String foodName;
  final String foodImage;
  final String foodPrice;

  const PaymentPages({
    Key? key,
    required this.foodName,
    required this.foodImage,
    required this.foodPrice,
  }) : super(key: key);



  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPages> {
  String token = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Price: \$${widget.foodPrice}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  token = Uuid().v4();
                });
              },
              child: Text('Finish Order'),
            ),
            SizedBox(height: 20),
            Text(
              'Token: $token',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}   */
