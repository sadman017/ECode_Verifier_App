import 'package:ecode_verifier/src/common_widgets/form/form_header.dart';
import 'package:ecode_verifier/src/constants/image_strings.dart';
import 'package:ecode_verifier/src/constants/size.dart';
import 'package:ecode_verifier/src/constants/text_string.dart';
import 'package:flutter/material.dart';

class ForgetPasswordMail extends StatelessWidget{
  const ForgetPasswordMail({super.key});

  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
   return SafeArea(
     child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            children:[
              const SizedBox(height: defaultSize*4,),
               FormHeaderWidget(size: size,
                    image: forgetPassImg,
                    title: resetViaEmail,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    heightBetween: 30.0,
                    textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: formHeight,),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text(email),
                              hintText: email,
                              prefixIcon: Icon(Icons.mail_outline_outlined),
                            ),
                          ),
                          const SizedBox(height: 20.0,),
                          SizedBox(width: double.infinity,
                          child: ElevatedButton(onPressed: (){}, child: const Text("Next")),
                          )
                        ],
                    )
                    )
            ],
          ),
         ),
      ),
     ),
   ); 
  }

}