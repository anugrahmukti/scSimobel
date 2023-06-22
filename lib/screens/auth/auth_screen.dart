import 'package:simobel/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  LoginController loginController = Get.put(LoginController());

  // var isLogin = false.obs;
  @override
  Widget build(BuildContext context) {
    final heightApp = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: heightApp * 0.3,
                child: Image.asset("assets/images/logo.png"),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: heightApp * 0.6,
                decoration: const BoxDecoration(
                    color: Color(0xFFf8fbfd),
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(50))),
                // padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientText(
                        'SIMOBEL',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                        colors: const [
                          Color.fromARGB(255, 33, 86, 243),
                          Colors.red,
                          Color.fromARGB(255, 216, 142, 23),
                        ],
                        textScaleFactor: 1.3,
                      ),
                      const Text('Masuk ke Akun Anda'),
                      loginWidget()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginWidget() {
    final heightApp = MediaQuery.of(context).size.height;
    final widthApp = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: heightApp * 0.02),
          child: InputUsernameFieldWidget(
              loginController.usernameController, 'Username'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: heightApp * 0.02),
          child: InputPasswordFieldText(
              loginController.passwordController, 'Password'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: heightApp * 0.05),
          child: SizedBox(
            // height: heightApp * 0.055,
            width: widthApp * 0.8,
            child: ElevatedButton(
              onPressed: () => _submit(),
              style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFF1363DF)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ))),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: heightApp * 0.015),
                child: const Text(
                  'MASUK',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      loginController.login();
    }
  }
}

class InputUsernameFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  InputUsernameFieldWidget(this.textEditingController, this.hintText);

  @override
  State<InputUsernameFieldWidget> createState() =>
      _InputUsernameFieldWidgetState();
}

class _InputUsernameFieldWidgetState extends State<InputUsernameFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Mohon masukan Nomor Induk anda';
          }
          return null;
        },
        controller: widget.textEditingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          labelText: widget.hintText,
        ),
      ),
    );
  }
}

class InputPasswordFieldText extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;

  InputPasswordFieldText(this.textEditingController, this.hintText);

  @override
  State<InputPasswordFieldText> createState() => _InputPasswordFieldTextState();
}

class _InputPasswordFieldTextState extends State<InputPasswordFieldText> {
  var isPasswordHiden = true.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Obx(() => Container(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mohon masukan password anda';
                  }
                  return null;
                },
                obscureText: isPasswordHiden.value,
                controller: widget.textEditingController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    labelText: widget.hintText,
                    suffixIcon: IconButton(
                      onPressed: () {
                        isPasswordHiden.value = !isPasswordHiden.value;
                      },
                      icon: Icon(
                        isPasswordHiden.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    )),
              ),
            )));
  }
}
