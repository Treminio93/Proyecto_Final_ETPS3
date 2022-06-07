
import 'dart:async';

import 'package:control_escuela/consultas/consultasBDApp.dart';
import 'package:control_escuela/paginas/campos.dart';
import 'package:flutter/material.dart';

class RegistroCalificacion extends StatefulWidget {
  const RegistroCalificacion({ Key? key }) : super(key: key);

  @override
  State<RegistroCalificacion> createState() => _RegistroCalificacionState();
}

class _RegistroCalificacionState extends State<RegistroCalificacion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: baseRCalificacion(context),
    );
  }
  String valorInicial = 'Item1';

  Widget baseRCalificacion(BuildContext context){
    final controlerA=TextEditingController();
    final controlerP=TextEditingController();
    final controlerSDosente=TextEditingController();
    final controlerIDSDosente=TextEditingController();
    final controlerSMateria=TextEditingController();
    final controlerIDSMateria=TextEditingController();
    final _keyForm=GlobalKey<FormState>();
    late BD bd=new BD();
    return Container(
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: AssetImage("imagenes/fondo.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("registro de nota", style: TextStyle(fontSize: 30),),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _keyForm,
                        child: Column(
                          children: <Widget>[
                            selecctGeneral(context, "todos los docentes", bd.tabla_docente, bd.campo_tabla_docente_nombre, bd.campo_tabla_docente_apellido, controlerSDosente, controlerIDSDosente),
                            selecctGeneral(context, "todos los salones",bd.tabla_materia, bd.campo_tabla_materia_codigo_materia, bd.campo_tabla_materia, controlerSMateria, controlerIDSMateria),
                            botonMostrarnotas(context, controlerIDSDosente, controlerIDSMateria),
                          ],
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFD6D6D6),
                      border: Border.all(width: 5.0, color: const Color(0xFF000000), style: BorderStyle.solid),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  botonCancelar(context,"cancelar"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}