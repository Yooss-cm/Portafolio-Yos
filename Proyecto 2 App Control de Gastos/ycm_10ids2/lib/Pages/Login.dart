import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ycm_10ids2/Pages/Home.dart';
import 'package:ycm_10ids2/Pages/RegistroUsr.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = '';
  bool _isPasswordVisible = false;

  // Función para validar el login
  Future<void> _login() async {
    try {
      // Autenticación con Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Mostrar alerta de Bienvenida
      AlertaBienvenido();
      // Si el inicio de sesión es exitoso, redirigir a Home
      if (userCredential.user != null) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      // Mostrar errores de autenticación
      if (e.code == 'user-not-found') {
        _showErrorAlert('No se encontró un usuario con ese correo.');
      } else if (e.code == 'wrong-password') {
        _showErrorAlert('Contraseña incorrecta.');
      } else {
        _showErrorAlert('Error: ${e.message}');
      }
    }
  }

  // Función para mostrar la alerta de bienvenida
  void AlertaBienvenido() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: '¡Bienvenido!',
      text: '¡Redirigiendo!',
      autoCloseDuration: const Duration(seconds: 2),
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Cerrar la alerta
      },
    );
  }

  // Función para mostrar alertas de error
  void _showErrorAlert(String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    Color myColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/fondo_shop.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(myColor.withOpacity(0.3), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 80, child: _buildTop()),
            Positioned(bottom: 0, child: _buildBottom(mediaSize, myColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_sharp,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "Control financiero",
            style: TextStyle(
              color: Colors.white,
              //fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: 3,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom(Size mediaSize, Color myColor) {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(myColor),
        ),
      ),
    );
  }

  Widget _buildForm(Color myColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bienvenido",
          style: TextStyle(
              color: myColor, letterSpacing: 3, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Introduce tu información por favor"),
        const SizedBox(height: 60),
        _buildGreyText("Email"),
        _buildInputField(_emailController),
        const SizedBox(height: 40),
        _buildGreyText("Contraseña"),
        _buildInputField(_passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildLoginButton(),
        const SizedBox(height: 20),
        _buildRegisterButton(), // Botón para registrar usuario
        // const SizedBox(height: 20),
        // _buildOtherLogin(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildInputField(TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible; // Cambiar la visibilidad de la contraseña
            });
          },
        )
            : const Icon(Icons.account_circle_outlined),
      ),
      obscureText: isPassword && !_isPasswordVisible, // Si es un campo de contraseña y está oculta, obscurece el texto
    );
  }

  // Botón de Login
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login, // Función de login
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        foregroundColor: Colors.purple.shade900,
        backgroundColor: Colors.white,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("LOGIN"),
    );
  }

  // Botón para registrar nuevo usuario
  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistroUsr(), // Navegar a registro de usuario
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple.shade900,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("REGISTRARME"),
    );
  }

  // Widget _buildOtherLogin() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         _buildGreyText("Ó inicia sesión con"),
  //         const SizedBox(height: 10),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Tab(
  //               icon: Image.asset(
  //                 "assets/images/facebook.png",
  //                 width: 30, // Ajusta el ancho según tus necesidades
  //                 height: 30, // Ajusta la altura según tus necesidades
  //               ),
  //             ),
  //             Tab(
  //               icon: Image.asset(
  //                 "assets/images/gmail.png",
  //                 width: 30, // Ajusta el ancho según tus necesidades
  //                 height: 30, // Ajusta la altura según tus necesidades
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
