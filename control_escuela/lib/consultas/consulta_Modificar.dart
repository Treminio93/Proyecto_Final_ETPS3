import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_escuela/consultas/consulta_busqueda.dart';
import 'package:control_escuela/consultas/consultasBDApp.dart';
import 'package:flutter/material.dart';

class modificar {
  late BD bd = new BD();
  late Busqueda b = new Busqueda();
  Future<int> ModificarDosente(
      TextEditingController idB,
      TextEditingController nombre,
      TextEditingController direccion,
      TextEditingController apellido,
      TextEditingController clave,
      TextEditingController correo,
      TextEditingController fecha,
      TextEditingController tipo,
      TextEditingController telefono,
      TextEditingController user) async {
    int respuesta = 0;
    try {
      FirebaseFirestore.instance
          .collection(bd.tabla_docente)
          .doc(idB.text)
          .update({
        bd.campo_tabla_docente_apellido: apellido.text,
        bd.campo_tabla_docente_clave: clave.text,
        bd.campo_tabla_docente_correo: correo.text,
        bd.campo_tabla_docente_direccion: direccion.text,
        bd.campo_tabla_docente_id_tipo_usuario: tipo.text,
        bd.campo_tabla_docente_nombre: nombre.text,
        bd.campo_tabla_docente_telefon: telefono.text,
        bd.campo_tabla_docente_usuario: user.text,
      });
      respuesta = 1;
    } catch (e) {
      respuesta = 0;
    }
    return respuesta;
  }

  Future<int> ModificarNota(
      String idB, double n1, double n2, double n3, double n4, double n5) async {
    int respuesta = 0;
    try {
      FirebaseFirestore.instance.collection(bd.tabla_notas).doc(idB).update({
        bd.campo_tabla_notas_nota1: n1,
        bd.campo_tabla_notas_nota2: n2,
        bd.campo_tabla_notas_nota3: n3,
        bd.campo_tabla_notas_nota4: n4,
        bd.campo_tabla_notas_nota5: n5,
      });
      respuesta = 1;
    } catch (e) {
      respuesta = 0;
    }
    return respuesta;
  }
}
