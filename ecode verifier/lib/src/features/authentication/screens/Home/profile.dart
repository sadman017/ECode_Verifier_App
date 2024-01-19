import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatelessWidget{
 const ProfileScreen({super.key});

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("Profile"),
       backgroundColor: Colors.blue,
     ),
     body: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             CircleAvatar(
               radius: 50,
               backgroundImage: AssetImage('assets/images/profile_picture.png'), // replace with your image path
             ),
             const SizedBox(height: 16.0),
             TextButton(
               onPressed: () {},
               child: const Text('Change Profile Picture'),
               style: TextButton.styleFrom(
                primary: Colors.blue,
                onSurface: Colors.grey,
               ),
             ),
             const SizedBox(height: 30.0),
             const Text("Profile Information", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
             const Gap(10),
             ListTile(
               leading: Icon(Icons.fastfood, color: Colors.green),
               title: Text("Food Preference", style: Theme.of(context).textTheme.headline6),
               trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
             ),
             ListTile(
               leading: Icon(Icons.settings, color: Colors.purple),
               title: Text("App Settings", style: Theme.of(context).textTheme.headline6),
               trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
             ),
             ListTile(
               leading: Icon(Icons.contact_mail, color: Colors.orange),
               title: Text("Contact Us", style: Theme.of(context).textTheme.headline6),
               trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
             ),
           ],
         ),
       ),
     ),
   );
 }
}
