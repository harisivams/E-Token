
import 'package:flutter/material.dart';
class FoodCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final double imageWidth;
  final double imageHeight;
  final VoidCallback onTap;

  FoodCard({required this.image, required this.name, required this.price, required this.onTap, this.imageWidth = 50,
    this.imageHeight = 50,});
  @override
Widget build(BuildContext context) {
return GestureDetector(
onTap: onTap,
child: Card(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: <Widget>[
Container(
width: imageWidth,
height: imageHeight,
decoration: BoxDecoration(
image: DecorationImage(
image: AssetImage(image),
fit: BoxFit.cover,
),
),
),
SizedBox(height: 8),
Padding(
padding: EdgeInsets.symmetric(horizontal: 16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: <Widget>[
Text(
name,
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 8),
Text(
price,
style: TextStyle(
fontSize: 16,
color: Colors.grey,
),
),
],
),
),
],
),
),
);
}
}
