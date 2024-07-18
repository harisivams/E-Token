import 'package:flutter/material.dart';

import 'orderpage.dart';

class PaymentPage extends StatefulWidget {
  final String image;
  final String name;
  final String price;

  PaymentPage({
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.image,
              width: 200,
              height: 130,
            ),
            SizedBox(height: 20),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.price,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<int>(
              value: quantity,
              items: List.generate(10, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('${index + 1}'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  quantity = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              '\$${(double.parse(widget.price.substring(1)) * quantity).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(
foodName: widget.name,
foodImage: widget.image,
foodPrice: '${(double.parse(widget.price.substring(1)) * quantity).toStringAsFixed(2)}', // use the calculated total price here
),
),
);
},
child: Text('Place Order'),
),
],
),
),
);
}
}


/*class PaymentPage extends StatelessWidget {
  final String image;
  final String name;
  final String price;

  PaymentPage({
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 200,
              height: 130,
            ),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
Text(
price,
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 20),
ElevatedButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => OrderPage(
foodName: name,
foodImage: image,
foodPrice: price,
),
),
);
},
child: Text('Place Order'),
),
],
),
),
);
}
}
*/


/*class PaymentPage extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Payment'),
),
body: Center(
child: Text('Payment Page'),
),
);
}
} */