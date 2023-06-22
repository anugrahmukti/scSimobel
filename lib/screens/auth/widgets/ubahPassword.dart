import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simobel/controllers/ubah_passwordController.dart';

class UbahPassword extends StatefulWidget {
  late final dynamic username;
  UbahPassword(this.username);

  @override
  State<UbahPassword> createState() => _UbahPasswordState();
}

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController konfirmasiPasswordController = TextEditingController();
final _formKey = GlobalKey<FormState>();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class _UbahPasswordState extends State<UbahPassword> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usernameController.text = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    void submit() async {
      if (_formKey.currentState!.validate()) {
        print('submit');
        print(usernameController.text);
        print(passwordController.text);
        UbahPasswordController()
            .ubahPasssword(usernameController.text, passwordController.text);

        usernameController.clear();
        passwordController.clear();
        konfirmasiPasswordController.clear();
        Get.back();
        print('sukses');
      }
    }

    final List<Widget> aksi = [
      TextButton(
        child: const Text(
          'Batal',
          style: TextStyle(color: Color(0xffB54542)),
        ),
        onPressed: () {
          // print(selectedMapel);
          Get.back();
        },
      ),
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  const MaterialStatePropertyAll(Color(0xFF1363DF)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ))),
          onPressed: () {
            submit();
            // Get.back();
          },
          child: const Text('Simpan')),
    ];

    final heightApp = MediaQuery.of(context).size.height;
    final widthApp = MediaQuery.of(context).size.width;
    var isKonfirmasiPasswordHiden = true.obs;
    var isPasswordHiden = true.obs;

    return AlertDialog(
      actions: aksi,
      title: const Text(
        'Ubah Username dan Password',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding:
          EdgeInsets.only(top: heightApp * 0.05, left: 20, right: 20),
      content: SizedBox(
        width: widthApp * 0.6,
        height: heightApp * 0.35,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Masukan username baru anda !';
                    } else if (value.contains(' ')) {
                      return 'Password tidak boleh mengandung spasi';
                    }
                    return null;
                  },
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    labelText: 'Username',
                  ),
                ),
              ),
              SizedBox(
                height: heightApp * 0.02,
              ),
              Container(
                child: Obx(() => Container(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Masukan password baru anda !';
                          } else if (value.contains(' ')) {
                            return 'Password tidak boleh mengandung spasi';
                          } else if (value.length < 8) {
                            return 'Password harus memiliki minimal 8 karakter';
                          }
                          return null;
                        },
                        obscureText: isPasswordHiden.value,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          labelText: 'Ubah Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              isPasswordHiden.value = !isPasswordHiden.value;
                            },
                            icon: Icon(
                              isPasswordHiden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: heightApp * 0.02,
              ),
              Container(
                child: Obx(() => Container(
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Masukan konfirmasi password baru anda !';
                          } else if (value != passwordController.text) {
                            return 'Konfirmasi password tidak cocok';
                          } else if (value.contains(' ')) {
                            return 'Password tidak boleh mengandung spasi';
                          } else if (value.length < 8) {
                            return 'Password harus memiliki minimal 8 karakter';
                          }
                          return null;
                        },
                        obscureText: isKonfirmasiPasswordHiden.value,
                        controller: konfirmasiPasswordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          labelText: 'Konfirmasi Ubah Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              isKonfirmasiPasswordHiden.value =
                                  !isKonfirmasiPasswordHiden.value;
                            },
                            icon: Icon(
                              isKonfirmasiPasswordHiden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
