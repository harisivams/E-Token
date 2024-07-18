
import 'package:flutter/material.dart';

import 'adminpage.dart';
import 'foodcard.dart';
import 'payment.dart';
import 'screen1.dart';
import 'screen2.dart';
class FoodCourt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Court'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Screen 1'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminPage()));
              },
            ),
            ListTile(
              title: Text('Screen 2'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => screen2()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            FoodCard(
              image: 'assets/images/eggrice.jpg',
              imageWidth: 200,
              imageHeight: 130,
              name: 'Egg Rice',
              price: '\$40.00',
              
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (cntext) => PaymentPage(
                       image: 'assets/images/eggrice.jpg',
                      name: 'Egg Rice',
                      price: '\$40.00',
                    )));
              },
            ),
            FoodCard(
              image: 'assets/images/rice.jpg',
              name: 'Rice',
              price: '\$50.00',
              imageWidth: 200,
              imageHeight: 130,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentPage(
                      image: 'assets/images/rice.jpg',
                      name: 'Rice',
                      price: '\$50.00',
                    )));
              },
            ),
            FoodCard(
              image: 'assets/images/porotta.png',
              name: 'Porotta',
              price: '\$30.00',
              imageWidth: 200,
              imageHeight: 130,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentPage(
                       image: 'assets/images/porotta.png',
                       
                       name: 'Porotta',
                       price: '\$30.00',
                    )));
              },
            ),
            FoodCard(
              image: 'assets/images/vegrice.jpg',
              imageWidth: 200,
              imageHeight: 130,
              name: 'Veg Rice',
              price: '\$35.00',
              
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentPage(
                       image: 'assets/images/vegrice.jpg',
                      name: 'Veg Rice',
                      price: '\$35.00',
                    )));
              },
            ),
            FoodCard(
              image: 'assets/images/chicken.jpg',
              imageWidth: 200,
              imageHeight: 130,
              name: 'Chilli Chicken',
              price: '\$35.00',
              
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentPage(
                       image: 'assets/images/chicken.jpg',
                      name: 'Chilli Chicken',
                      price: '\$35.00',
                    )));
              },
            ),
            FoodCard(
              image: 'assets/images/rice.jpg',
              imageWidth: 200,
              imageHeight: 130,
              name: 'Rice',
              price: '\$50.00',
              
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentPage(
                       image: 'assets/images/rice.jpg',
                      name: 'Rice',
                      price: '\$50.00',
                    )));
              },
            ),
           /* FoodCard(
              image: 'assets/images/hamburger.jpg',
              imageWidth: 200,
              imageHeight: 130,
              name: 'Burger',
              price: '\$5.00',
              
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentPage(
                       image: 'assets/images/hamburger.jpg',
                      name: 'Burger',
                      price: '\$5.00',
                    )));
                    
              },
            ),
            FoodCard(
              image: 'assets/images/hamburger.jpg',
              imageWidth: 200,
              imageHeight: 130,
              name: 'Burger',
              price: '\$5.00',
              
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentPage(
                       image: 'assets/images/hamburger.jpg',
                      name: 'Burger',
                      price: '\$5.00',
                    )));
              },
            ),
            FoodCard(
              image: 'assets/images/hamburger.jpg',
              imageWidth: 200,
              imageHeight: 130,
              name: 'Burger',
              price: '\$5.00',
              
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentPage(
                       image: 'assets/images/hamburger.jpg',
                      name: 'Burger',
                      price: '\$5.00',
                    )));
              },
            ), */
          ],
        ),
      ),
    );
  }
}