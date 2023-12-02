import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget{
  const FormHeaderWidget({Key? key, required this.size, required this.image, required this.title}): super(key: key);
  final Size size;
  final String image, title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(image),
        height: size.height * 0.2 ,
        ),
        Text(title, style: Theme.of(context).textTheme.headlineLarge,),
      ],
    );
  }

}