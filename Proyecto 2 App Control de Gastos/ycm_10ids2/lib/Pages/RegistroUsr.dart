import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ycm_10ids2/Pages/Login.dart';

class RegistroUsr extends StatefulWidget {
  @override
  _RegistroUsrState createState() => _RegistroUsrState();
}

class _RegistroUsrState extends State<RegistroUsr> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;
  String errorMessage = '';

  Future<void> _register() async {
    User? user;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      user = userCredential.user;

      if (user != null) {
        // Registro exitoso, muestra la alerta de éxito
        AlertaBienvenido();


      }
    } on FirebaseAuthException catch (e) {
      // Manejo de errores de FirebaseAuth
      if (e.code == 'weak-password') {
        _showErrorAlert('La contraseña es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorAlert('El correo electrónico ya está en uso.');
      } else if (e.code == 'invalid-email') {
        _showErrorAlert('El formato del correo electrónico no es válido.');
      } else {
        _showErrorAlert('Error desconocido: ${e.message}');
      }
    } catch (e) {
      // Manejo de cualquier otro tipo de error
      _showErrorAlert('Ocurrió un error inesperado: $e');
    }
  }

// Función de alerta de error en el registro
  void _showErrorAlert(String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: message,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

// Función para mostrar la alerta de bienvenida
  void AlertaBienvenido() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: '¡Registro Exitoso!',
      text: 'Redirigiendo al login...',
      autoCloseDuration: const Duration(seconds: 2),
    );
    // Redirige al login después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    Color myColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/registro_img.png"),
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
            Icons.person_add,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "REGISTRAR USUARIO",
            style: TextStyle(
              color: Colors.white,
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
          "Registro",
          style: TextStyle(
              color: myColor, letterSpacing: 3, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Introduce tus datos para registrarte"),
        const SizedBox(height: 60),
        _buildGreyText("Email"),
        _buildInputField(_emailController),
        const SizedBox(height: 40),
        _buildGreyText("Contraseña"),
        _buildInputField(_passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildRegisterButton(),
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
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : const Icon(Icons.account_circle_outlined),
      ),
      obscureText: isPassword && !_isPasswordVisible,
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () async {
        await _register();
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        foregroundColor: Colors.purple.shade900,
        backgroundColor: Colors.white,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("REGISTRARME"),
    );
  }

  // Widget _buildOtherLogin() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         _buildGreyText("Vincular cuenta con"),
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
  //                 height: 30,// Ajusta la altura según tus necesidades
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
