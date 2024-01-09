import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const  Text("Profile"),
        ),
      body: SingleChildScrollView(
        child: Padding(padding:const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  TextButton(onPressed: (){}, child: const Text('Change Profile Picture')),
                ],
              ),
            ),
            const SizedBox(
              height: 16.0, 
            ),
            const Divider(),
            const SizedBox(height: 16.0,),
            const Text("Profile Information",  style: TextStyle(fontSize: 18, fontWeight:FontWeight.bold,
            letterSpacing: 1,
              ),
            ),
            const Gap(10),

            Column(
              children: [
                Expanded(flex: 3, child: Text("Name", style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis,)
                ,),
                Expanded(flex: 5, child: Text("Sadman", style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis,)
                ),
                const Expanded(child: Icon(Icons.arrow_right, size: 18, )),
                const Gap(10.0),
                Expanded(flex:5, child: Text("Food Preference", style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis,),
                ),
                const Expanded(child: Icon(Icons.arrow_right, size: 18, )),
                const Gap(10.0),
                Expanded(flex:5, child: Text("App Settings", style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis,),
                ),
                const Expanded(child: Icon(Icons.arrow_right, size: 18, )),
                const Gap(10.0),
                 Expanded(flex:5, child: Text("FAQ", style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis,),
                ),
                const Expanded(child: Icon(Icons.arrow_right, size: 18, )),
                const Gap(10.0),
                 Expanded(flex:5, child: Text("Contact Us", style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis,),
                ),
                const Expanded(child: Icon(Icons.arrow_right, size: 18, )),
              ],
            )
          ],
        ),
        ),
      ),
    );
  }

}