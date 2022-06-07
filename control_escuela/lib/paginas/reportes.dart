import 'package:control_escuela/paginas/campos.dart';
import 'package:flutter/material.dart';

class reporte extends StatefulWidget {
  const reporte({ Key? key }) : super(key: key);

  @override
  State<reporte> createState() => _reporteState();
}

class _reporteState extends State<reporte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: baseRCalificacion(context),
    );
  }
  Widget baseRCalificacion(BuildContext context){
    final controlerAlum=TextEditingController();
    final controlerIDAlum=TextEditingController();
    final controlerSalon=TextEditingController();
    final controlerIDSalon=TextEditingController();
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
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("reportes", style: TextStyle(fontSize: 30),),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          selecctGeneral(context, "salon", bd.tabla_salones, bd.campo_tabla_salones_nombre, bd.campo_tabla_salones_direccion, controlerSalon, controlerIDSalon),
                          selecctAlumnoSalon(context, "alumno", controlerAlum, controlerIDAlum, controlerIDSalon),
                          botonMostrarReporte(context, controlerIDAlum),
                        ],
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
                  botonGuardarOListo(context),
                  SizedBox(
                    height: 10,
                  ),
                  botonCancelar(context, "cancelar"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}