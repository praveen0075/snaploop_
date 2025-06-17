
import 'package:flutter/material.dart';
import 'package:snap_loop/features/auth/presentation/pages/login_page.dart';
import 'package:snap_loop/features/auth/presentation/pages/register_page.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
   // initially login page will show
    bool isLoginPage = true;

    // changing auth pages 
    void changeAuthPage(){
      setState(() {
        isLoginPage = !isLoginPage;
      });
    }
  @override
  Widget build(BuildContext context){
    return Builder(
      builder:
          (BuildContext context) {
            if(isLoginPage){
              return LoginPage(ontap: changeAuthPage,);
            }else{
              return RegisterPage(ontap: changeAuthPage,);
            }
          },
    );
  }
}
