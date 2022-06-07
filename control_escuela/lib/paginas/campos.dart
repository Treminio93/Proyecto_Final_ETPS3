import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_escuela/consultas/consulta_Modificar.dart';
import 'package:control_escuela/consultas/consulta_busqueda.dart';
import 'package:control_escuela/consultas/consultasBDApp.dart';
import 'package:control_escuela/consultas/consuta_insercion.dart';
import 'package:control_escuela/paginas/AdministrarDosentes.dart';
import 'package:control_escuela/paginas/LoginUser.dart';
import 'package:control_escuela/paginas/RegistrarCalificaciones.dart';
import 'package:control_escuela/paginas/menu.dart';
import 'package:control_escuela/paginas/nuevoDocente.dart';
import 'package:control_escuela/paginas/paginaregalumno.dart';
import 'package:control_escuela/paginas/paginasalones.dart';
import 'package:control_escuela/paginas/reportes.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

late Busqueda B = new Busqueda();
late BD bd = new BD();
late modificar m = new modificar();
late insertar i = new insertar();

Widget camposGeneral(
    String Ncampo, TextEditingController textEditingController) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
            labelText: Ncampo,
            hintText: Ncampo,
            fillColor: Colors.white,
            filled: true),
      ));
}

Widget camposGeneralfecha(
    String Ncampo, TextEditingController textEditingController) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextFormField(
        keyboardType: TextInputType.datetime,
        controller: textEditingController,
        decoration: InputDecoration(
            hintText: Ncampo, fillColor: Colors.white, filled: true),
      ));
}

Widget camposGeneralNumeros(
    String Ncampo, TextEditingController textEditingController) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextFormField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        controller: textEditingController,
        decoration: InputDecoration(
            labelText: Ncampo,
            hintText: Ncampo,
            fillColor: Colors.white,
            filled: true),
      ));
}

Widget fechaGeneral(
    String Ncampo, TextEditingController textEditingController) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
            hintText: Ncampo, fillColor: Colors.white, filled: true),
      ));
}

Widget camposRelevo(String campo) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
        decoration: InputDecoration(
            hintText: campo, fillColor: Colors.white, filled: true),
      ));
}

Widget camposPass(String Ncampo, TextEditingController textEditingController) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
        controller: textEditingController,
        obscureText: true,
        decoration: InputDecoration(
            labelText: Ncampo,
            hintText: Ncampo,
            fillColor: Colors.white,
            filled: true),
      ));
}

Widget selecctGeneral(
    BuildContext context,
    String nombre,
    String tabla,
    String campo,
    String campo2,
    TextEditingController CS,
    TextEditingController CIDS) {
  return GestureDetector(
    onTap: () async {
      QuerySnapshot buscado = await B.buscarDatos(tabla);
      List<String> campoSelec = [];
      List<String> idcampo = [];
      List<String> campoSelec2 = [];
      if (buscado.docs.length != 0) {
        for (var bus in buscado.docs) {
          campoSelec.add(bus.get(campo).toString());
          idcampo.add(bus.id);
          campoSelec2.add(bus.get(campo2).toString());
        }
      }
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Seleccionar 1"),
                content: mostrarSelecct(
                    context, campoSelec, campoSelec2, idcampo, CS, CIDS),
              ));
    },
    child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: TextFormField(
          enabled: false,
          controller: CS,
          decoration: InputDecoration(
              labelText: nombre,
              hintText: nombre,
              fillColor: Colors.white,
              filled: true),
        )),
  );
}

Widget selecctAlumnoSalon(
    BuildContext context,
    String nombre,
    TextEditingController CS,
    TextEditingController CIDS,
    TextEditingController CIDSSalones) {
  return GestureDetector(
    onTap: () async {
      if (CIDSSalones.text != "") {
        QuerySnapshot buscado = await B.buscarDatos(bd.tabla_materia_inscripta);
        QuerySnapshot Alumno = await B.buscarDatos(bd.tabla_tablaalumno);
        List<String> campoSelec = [];
        List<String> idcampo = [];
        List<String> campoSelec2 = [];
        String C1 = "";
        String C2 = "";
        String id = "";
        if (Alumno.docs.length != 0) {
          for (var A in Alumno.docs) {
            if (buscado.docs.length != 0) {
              C1 = "";
              C2 = "";
              id = "";
              for (var MI in buscado.docs) {
                if (A.id ==
                    MI.get(bd.campo_tabla_materia_inscripta_id_alumno)) {
                  C1 = A.get(bd.campo_tabla_tablaalumno_nombre);
                  C2 = A.get(bd.campo_tabla_tablaalumno_apellido);
                  id = A.id;
                }
              }
              if (id != "") {
                campoSelec.add(C1);
                campoSelec2.add(C2);
                idcampo.add(id);
              }
            }
          }
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Seleccionar 1"),
                    content: mostrarSelecct(
                        context, campoSelec, campoSelec2, idcampo, CS, CIDS),
                  ));
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text("no hay alumnos es ese salon"),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("CERRAR"))
                    ],
                  ));
        }
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("campo vacio"),
                  content: Text("Seleccionar 1 salon"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("CERRAR"))
                  ],
                ));
      }
    },
    child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: TextFormField(
          enabled: false,
          controller: CS,
          decoration: InputDecoration(
              labelText: nombre,
              hintText: nombre,
              fillColor: Colors.white,
              filled: true),
        )),
  );
}

Widget botonVerReporte(BuildContext context) {
  return Container(
      width: double.infinity,
      child: MaterialButton(
          color: const Color(0x00ff0069fe),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          onPressed: () {
            Navigator.pop(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: menuapp()));
          },
          child: Text(
            "guardar",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget mostrarSelecct(
    BuildContext context,
    List<String> campoSelec,
    List<String> campoSelec2,
    List<String> idcampo,
    TextEditingController CS,
    TextEditingController CIDS) {
  return Container(
    width: double.infinity,
    child: Column(
      children: List.generate(campoSelec.length, (index) {
        return Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () {
                  CS.text = campoSelec[index] + " " + campoSelec2[index];
                  CIDS.text = idcampo[index];
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.lightGreenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        campoSelec[index] + " " + campoSelec2[index],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )));
      }),
    ),
  );
}

Widget botonIngresarLogin(
    BuildContext context, TextEditingController CU, TextEditingController CP) {
  return Container(
      width: double.infinity,
      child: MaterialButton(
          color: const Color(0x00ff0069fe),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          onPressed: () async {
            if (CU.text == "" || CP.text == "") {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text("llenar los campos vacios"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("ok"))
                        ],
                      ));
            } else {
              String titulA = "";
              String contenidoA = "";
              int R = await B.login(CU.text, CP.text);
              switch (R) {
                case 2:
                  {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade, child: menuapp()));
                  }
                  break;
                case 1:
                  {
                    titulA = "usuario no tiene permiso";
                    contenidoA =
                        "usuario no cuenta con el nivel necesario para ingresar a la app";
                  }
                  break;
                default:
                  {
                    titulA = "usuario no encontrado";
                    contenidoA = "usuario o contraseña incorrectos";
                  }
                  break;
              }
              if (R == 0) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("usuario no encontrado"),
                          content: Text("usuario o contraseña incorrectos"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("ok"))
                          ],
                        ));
              }
            }
          },
          child: Text(
            "iniciar sesion",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget botonGuardarOListo(BuildContext context) {
  return Container(
      width: double.infinity,
      child: MaterialButton(
          color: const Color(0x00ff0069fe),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          onPressed: () {
            Navigator.pop(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: menuapp()));
          },
          child: Text(
            "guardar",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget botonEditarDosente(
    BuildContext context,
    TextEditingController idB,
    TextEditingController nombre,
    TextEditingController direccion,
    TextEditingController apellido,
    TextEditingController clave,
    TextEditingController correo,
    TextEditingController fecha,
    TextEditingController tipo,
    TextEditingController telefono,
    TextEditingController user) {
  return Container(
      child: MaterialButton(
          color: const Color(0x00ff0069fe),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          onPressed: () async {
            //print(idB.text);
            QuerySnapshot dosente = await B.buscarDatos(bd.tabla_docente);
            if (idB.text != "") {
              if (dosente.docs.length != 0) {
                for (var doc in dosente.docs) {
                  if (doc.id == idB.text) {
                    nombre.text =
                        doc.get(bd.campo_tabla_docente_nombre).toString();
                    direccion.text =
                        doc.get(bd.campo_tabla_docente_direccion).toString();
                    apellido.text =
                        doc.get(bd.campo_tabla_docente_apellido).toString();
                    clave.text =
                        doc.get(bd.campo_tabla_docente_clave).toString();
                    correo.text =
                        doc.get(bd.campo_tabla_docente_correo).toString();
                    fecha.text = doc
                        .get(bd.campo_tabla_docente_fecha_Nacimiento)
                        .toString();
                    tipo.text = doc
                        .get(bd.campo_tabla_docente_id_tipo_usuario)
                        .toString();
                    telefono.text =
                        doc.get(bd.campo_tabla_docente_telefon).toString();
                    user.text =
                        doc.get(bd.campo_tabla_docente_usuario).toString();
                    fecha.text = doc
                        .get(bd.campo_tabla_docente_fecha_Nacimiento)
                        .toString();
                  }
                }
              }
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("editar Docente"),
                        content: camposDosentes(
                            context,
                            nombre,
                            direccion,
                            apellido,
                            clave,
                            correo,
                            fecha,
                            tipo,
                            telefono,
                            user),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () async {
                                if (nombre.text == "" ||
                                    direccion.text == "" ||
                                    apellido.text == "" ||
                                    clave.text == "" ||
                                    correo.text == "" ||
                                    tipo.text == "" ||
                                    telefono.text == "" ||
                                    user.text == "" ||
                                    fecha.text == "") {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content:
                                                Text("No dejar campos vacíos"),
                                            actions: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("ok"))
                                            ],
                                          ));
                                } else {
                                  int R = await m.ModificarDosente(
                                      idB,
                                      nombre,
                                      direccion,
                                      apellido,
                                      clave,
                                      correo,
                                      fecha,
                                      tipo,
                                      telefono,
                                      user);
                                  if (R == 1) {
                                    nombre.text =
                                        "Docente modificado con éxito";
                                    idB.text = "";
                                  } else {
                                    nombre.text = "Error no se pudo modificar";
                                    idB.text = "";
                                  }
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text("guardar")),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("canselar"))
                        ],
                      ));
            } else {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text("deve seleccionar 1 opcion"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("ok"))
                        ],
                      ));
            }
          },
          child: Text(
            "Editar",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget camposDosentes(
    BuildContext context,
    TextEditingController nombre,
    TextEditingController direccion,
    TextEditingController apellido,
    TextEditingController clave,
    TextEditingController correo,
    TextEditingController fecha,
    TextEditingController tipo,
    TextEditingController telefono,
    TextEditingController user) {
  final CS = TextEditingController();
  return Container(
    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          camposGeneral("nombre", nombre),
          camposGeneral("apellido", apellido),
          camposGeneral("correo", correo),
          camposGeneral("usuario", user),
          camposGeneral("contraseña", clave),
          camposGeneral("direccion", direccion),
          camposGeneralfecha("fecha de nasimiento", fecha),
          selecctGeneral(
              context,
              tipo.text,
              bd.tabla_tipo_usuario,
              bd.campo_tabla_tipo_usuario_tipo,
              bd.campo_tabla_tipo_usuario_nombre,
              CS,
              tipo),
          camposGeneral("telefono", telefono),
        ],
      ),
    ),
  );
}

Widget botonagregarGuardar(BuildContext context) {
  return Container(
      width: double.infinity,
      child: MaterialButton(
          color: const Color(0x00ff0069fe),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: agregarDosente()));
          },
          child: Text(
            "agregar docente",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget botonGuardarNuevoDocente(
    BuildContext context,
    TextEditingController nombre,
    TextEditingController direccion,
    TextEditingController apellido,
    TextEditingController clave,
    TextEditingController correo,
    TextEditingController fecha,
    TextEditingController tipo,
    TextEditingController telefono,
    TextEditingController user) {
  return Container(
      width: double.infinity,
      child: MaterialButton(
          color: const Color(0x00ff0069fe),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          onPressed: () async {
            if (nombre.text == "" ||
                direccion.text == "" ||
                apellido.text == "" ||
                clave.text == "" ||
                correo.text == "" ||
                tipo.text == "" ||
                telefono.text == "" ||
                user.text == "" ||
                tipo.text == "") {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text("No dejar campos vacíos"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("ok"))
                        ],
                      ));
            } else {
              int R = await i.AgregarDosente(nombre, direccion, apellido, clave,
                  correo, fecha, tipo, telefono, user);
              if (R == 1) {
                nombre.text = "Docente agregado con éxito";
              } else {
                nombre.text = "Error no se pudo agregar";
              }
              Navigator.of(context).pop();
            }
          },
          child: Text(
            "agregar docente",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget botonesMenuNavigator(
    BuildContext context, String varTexto, int rutaBoton) {
  return Container(
      width: double.infinity,
      child: MaterialButton(
          color: const Color(0x00ff0069fe),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: getPaginas(rutaBoton)));
          },
          child: Text(
            varTexto,
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget getPaginas(int rutaBoton) {
  return IndexedStack(
    index: rutaBoton,
    children: [
      pagina(),
      AdminSalones(),
      adminDosente(),
      login(),
      RegistroCalificacion(),
      reporte(),
    ],
  );
}

Widget botonCancelar(BuildContext context, String texto) {
  return Container(
      width: double.infinity,
      child: MaterialButton(
          color: const Color(0x00fff44336),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            texto,
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget botonCerrarSecion(BuildContext context) {
  return Container(
      width: double.infinity,
      child: MaterialButton(
          color: const Color(0x00fff44336),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => login(),
              ),
              (route) => false,
            );
          },
          child: Text(
            "Cerrar Sesion",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget botonMostrarnotas(BuildContext context, TextEditingController idDosente,
    TextEditingController idMateria) {
  return Container(
      width: double.infinity,
      child: MaterialButton(
          color: Color.fromARGB(255, 26, 223, 4),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: () async {
            List<String> listaFiltradaNombre = [];
            String NombreA = "";
            List<String> listaFiltradaNotaID = [];
            String notaID = "";
            List<String> listaFiltradaNotas = [];
            String notas = "";
            List<double> listaFiltradaNota1 = [];
            double nota1 = 0;
            List<double> listaFiltradaNota2 = [];
            double nota2 = 0;
            List<double> listaFiltradaNota3 = [];
            double nota3 = 0;
            List<double> listaFiltradaNota4 = [];
            double nota4 = 0;
            List<double> listaFiltradaNota5 = [];
            double nota5 = 0;
            List<double> listaFiltradapromedios = [];
            double promedio = 0.0;
            List<String> listaFiltradaMateria = [];
            String materia = "";
            List<String> listaFiltradaDosente = [];
            String dosente = "";
            QuerySnapshot MateriasIncritas =
                await B.buscarDatos(bd.tabla_materia_inscripta);
            if (MateriasIncritas.docs.length != 0) {
              if (idDosente.text != "" || idMateria.text != "") {
              } else {
                for (var MI in MateriasIncritas.docs) {
                  NombreA = "sin resultados";
                  QuerySnapshot alumno =
                      await B.buscarDatos(bd.tabla_tablaalumno);
                  if (alumno.docs.length != 0) {
                    for (var A in alumno.docs) {
                      if (A.id ==
                          MI.get(bd.campo_tabla_materia_inscripta_id_alumno)) {
                        NombreA = A.get(bd.campo_tabla_tablaalumno_nombre) +
                            " " +
                            A.get(bd.campo_tabla_tablaalumno_apellido);
                      }
                    }
                  }
                  notas = "sin resultados";
                  promedio = 0.0;
                  QuerySnapshot notaAlum = await B.buscarDatos(bd.tabla_notas);
                  if (notaAlum.docs.length != 0) {
                    for (var NA in notaAlum.docs) {
                      if (NA.id ==
                          MI.get(bd.campo_tabla_materia_inscripta_id_nota)) {
                        notaID = NA.id;
                        nota1 = NA.get(bd.campo_tabla_notas_nota1).toDouble();
                        nota2 = NA.get(bd.campo_tabla_notas_nota2).toDouble();
                        nota3 = NA.get(bd.campo_tabla_notas_nota3).toDouble();
                        nota4 = NA.get(bd.campo_tabla_notas_nota4).toDouble();
                        nota5 = NA.get(bd.campo_tabla_notas_nota5).toDouble();
                        notas = nota1.toString() +
                            ", " +
                            nota2.toString() +
                            ", " +
                            nota3.toString() +
                            ", " +
                            nota4.toString() +
                            ", " +
                            nota5.toString();
                        promedio = (nota1 + nota2 + nota3 + nota4 + nota5);
                        if (promedio != 0) {
                          promedio = promedio / 5;
                        }
                      }
                    }
                  }
                  materia = "sin resultados";
                  QuerySnapshot materiaAlum =
                      await B.buscarDatos(bd.tabla_materia);
                  if (materiaAlum.docs.length != 0) {
                    for (var MA in materiaAlum.docs) {
                      if (MA.id ==
                          MI.get(bd.campo_tabla_materia_inscripta_id_materia)) {
                        materia = MA.get(bd.campo_tabla_materia).toString();
                      }
                    }
                  }
                  dosente = "sin resultados";
                  QuerySnapshot DosenteAlum =
                      await B.buscarDatos(bd.tabla_docente);
                  if (DosenteAlum.docs.length != 0) {
                    for (var DA in DosenteAlum.docs) {
                      if (DA.id ==
                          MI.get(bd.campo_tabla_materia_inscripta_id_docente)) {
                        dosente =
                            DA.get(bd.campo_tabla_docente_nombre).toString() +
                                " " +
                                DA.get(bd.campo_tabla_docente_apellido);
                      }
                    }
                  }
                  listaFiltradaNombre.add(NombreA);
                  listaFiltradaNotas.add(notas);
                  listaFiltradaNotaID.add(notaID);
                  listaFiltradaNota1.add(nota1);
                  listaFiltradaNota2.add(nota2);
                  listaFiltradaNota3.add(nota3);
                  listaFiltradaNota4.add(nota4);
                  listaFiltradaNota5.add(nota5);
                  listaFiltradapromedios.add(promedio);
                  listaFiltradaMateria.add(materia);
                  listaFiltradaDosente.add(dosente);
                }
              }
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                        title: Text("alunnos"),
                        content: filtroNotas(
                            context,
                            listaFiltradaNombre,
                            listaFiltradaNotas,
                            listaFiltradaNotaID,
                            listaFiltradaNota1,
                            listaFiltradaNota2,
                            listaFiltradaNota3,
                            listaFiltradaNota4,
                            listaFiltradaNota5,
                            listaFiltradapromedios,
                            listaFiltradaMateria,
                            listaFiltradaDosente),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("CERRAR"))
                        ],
                      ));
            }
          },
          child: Text(
            "ver listado",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget botonMostrarReporte(
    BuildContext context, TextEditingController idAlumno) {
  return Container(
      width: double.infinity,
      child: MaterialButton(
          color: Color.fromARGB(255, 26, 223, 4),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: () async {
            List<String> listaFiltradaNombre = [];
            String NombreA = "";
            List<String> listaFiltradaNotaID = [];
            String notaID = "";
            List<String> listaFiltradaNotas = [];
            String notas = "";
            List<double> listaFiltradaNota1 = [];
            double nota1 = 0;
            List<double> listaFiltradaNota2 = [];
            double nota2 = 0;
            List<double> listaFiltradaNota3 = [];
            double nota3 = 0;
            List<double> listaFiltradaNota4 = [];
            double nota4 = 0;
            List<double> listaFiltradaNota5 = [];
            double nota5 = 0;
            List<double> listaFiltradapromedios = [];
            double promedio = 0.0;
            List<String> listaFiltradaMateria = [];
            String materia = "";
            List<String> listaFiltradaDosente = [];
            String dosente = "";
            QuerySnapshot MateriasIncritas =
                await B.buscarDatos(bd.tabla_materia_inscripta);
            if (MateriasIncritas.docs.length != 0) {
              if (idAlumno.text == "") {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                          title: Text("alunnos"),
                          content: Text("seleccinar los campos"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("cerrar")),
                          ],
                        ));
              } else {
                for (var MI in MateriasIncritas.docs) {
                  if (MI.get(bd.campo_tabla_materia_inscripta_id_alumno) ==
                      idAlumno.text) {
                    NombreA = "sin resultados";
                    QuerySnapshot alumno =
                        await B.buscarDatos(bd.tabla_tablaalumno);
                    if (alumno.docs.length != 0) {
                      for (var A in alumno.docs) {
                        if (A.id ==
                            MI.get(
                                bd.campo_tabla_materia_inscripta_id_alumno)) {
                          NombreA = A.get(bd.campo_tabla_tablaalumno_nombre) +
                              " " +
                              A.get(bd.campo_tabla_tablaalumno_apellido);
                        }
                      }
                    }
                    notas = "sin resultados";
                    promedio = 0.0;
                    QuerySnapshot notaAlum =
                        await B.buscarDatos(bd.tabla_notas);
                    if (notaAlum.docs.length != 0) {
                      for (var NA in notaAlum.docs) {
                        if (NA.id ==
                            MI.get(bd.campo_tabla_materia_inscripta_id_nota)) {
                          notaID = NA.id;
                          nota1 = NA.get(bd.campo_tabla_notas_nota1).toDouble();
                          nota2 = NA.get(bd.campo_tabla_notas_nota2).toDouble();
                          nota3 = NA.get(bd.campo_tabla_notas_nota3).toDouble();
                          nota4 = NA.get(bd.campo_tabla_notas_nota4).toDouble();
                          nota5 = NA.get(bd.campo_tabla_notas_nota5).toDouble();
                          notas = nota1.toString() +
                              ", " +
                              nota2.toString() +
                              ", " +
                              nota3.toString() +
                              ", " +
                              nota4.toString() +
                              ", " +
                              nota5.toString();
                          promedio = (nota1 + nota2 + nota3 + nota4 + nota5);
                          if (promedio != 0) {
                            promedio = promedio / 5;
                          }
                        }
                      }
                    }
                    materia = "sin resultados";
                    QuerySnapshot materiaAlum =
                        await B.buscarDatos(bd.tabla_materia);
                    if (materiaAlum.docs.length != 0) {
                      for (var MA in materiaAlum.docs) {
                        if (MA.id ==
                            MI.get(
                                bd.campo_tabla_materia_inscripta_id_materia)) {
                          materia = MA.get(bd.campo_tabla_materia).toString();
                        }
                      }
                    }
                    dosente = "sin resultados";
                    QuerySnapshot DosenteAlum =
                        await B.buscarDatos(bd.tabla_docente);
                    if (DosenteAlum.docs.length != 0) {
                      for (var DA in DosenteAlum.docs) {
                        if (DA.id ==
                            MI.get(
                                bd.campo_tabla_materia_inscripta_id_docente)) {
                          dosente =
                              DA.get(bd.campo_tabla_docente_nombre).toString() +
                                  " " +
                                  DA.get(bd.campo_tabla_docente_apellido);
                        }
                      }
                    }
                    listaFiltradaNombre.add(NombreA);
                    listaFiltradaNotas.add(notas);
                    listaFiltradaNotaID.add(notaID);
                    listaFiltradaNota1.add(nota1);
                    listaFiltradaNota2.add(nota2);
                    listaFiltradaNota3.add(nota3);
                    listaFiltradaNota4.add(nota4);
                    listaFiltradaNota5.add(nota5);
                    listaFiltradapromedios.add(promedio);
                    listaFiltradaMateria.add(materia);
                    listaFiltradaDosente.add(dosente);
                  }
                }
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                          title: Text("alumnos"),
                          content: filtroNotas(
                              context,
                              listaFiltradaNombre,
                              listaFiltradaNotas,
                              listaFiltradaNotaID,
                              listaFiltradaNota1,
                              listaFiltradaNota2,
                              listaFiltradaNota3,
                              listaFiltradaNota4,
                              listaFiltradaNota5,
                              listaFiltradapromedios,
                              listaFiltradaMateria,
                              listaFiltradaDosente),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("crear PDF")),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("cerrar")),
                          ],
                        ));
              }
            }
          },
          child: Text(
            "ver listado",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
}

Widget filtroNotas(
    BuildContext context,
    List<String> listaFiltradaNombre,
    List<String> listaFiltradaNotas,
    List<String> listaFiltradaNotaID,
    List<double> Nota1,
    List<double> Nota2,
    List<double> Nota3,
    List<double> Nota4,
    List<double> Nota5,
    List<double> listaFiltradaPromedios,
    List<String> listaFiltradaMateria,
    List<String> listaFiltradaDosente) {
  return Container(
    width: double.infinity,
    child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Column(
              children: List.generate(listaFiltradaNombre.length, (index) {
                return Padding(
                    padding: EdgeInsets.all(5),
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: Modificar_nota(
                                        context,
                                        listaFiltradaNombre[index],
                                        listaFiltradaNotaID[index],
                                        Nota1[index],
                                        Nota2[index],
                                        Nota3[index],
                                        Nota4[index],
                                        Nota5[index]),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("cancelar"))
                                    ],
                                  ));
                        },
                        child: Center(
                          child: Container(
                            color: Color.fromARGB(210, 12, 97, 189),
                            child: Column(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      "NOMBRE",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      listaFiltradaNombre[index],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      "MATERIA",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      listaFiltradaMateria[index],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      "DOCENTE",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      listaFiltradaDosente[index],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      "NOTAS",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      listaFiltradaNotas[index],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      "PROMEDIO",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      listaFiltradaPromedios[index].toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )));
              }),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    ),
  );
}

Widget Modificar_nota(BuildContext context, String nombre, String ID, double N1,
    double N2, double N3, double N4, double N5) {
  final id = TextEditingController();
  final nota1 = TextEditingController();
  final nota2 = TextEditingController();
  final nota3 = TextEditingController();
  final nota4 = TextEditingController();
  final nota5 = TextEditingController();
  id.text = ID;
  nota1.text = N1.toString();
  nota2.text = N2.toString();
  nota3.text = N3.toString();
  nota4.text = N4.toString();
  nota5.text = N5.toString();
  return Column(
    children: <Widget>[
      Center(
        child: Text(
          "ALUMNO: " + nombre,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      camposGeneralNumeros("nota 1", nota1),
      camposGeneralNumeros("nota 2", nota2),
      camposGeneralNumeros("nota 3", nota3),
      camposGeneralNumeros("nota 4", nota4),
      camposGeneralNumeros("nota 5", nota5),
      MaterialButton(
          color: const Color(0x00ff0069fe),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          onPressed: () async {
            try {
              String mensage = "";
              double n1 = double.parse(nota1.text);
              double n2 = double.parse(nota2.text);
              double n3 = double.parse(nota3.text);
              double n4 = double.parse(nota4.text);
              double n5 = double.parse(nota5.text);
              if (n1 != null ||
                  n2 != null ||
                  n3 != null ||
                  n4 != null ||
                  n5 != null) {
                int R = await m.ModificarNota(ID, n1, n2, n3, n4, n5);
                if (R == 1) {
                  mensage = "notas modificado con éxito";
                } else {
                  mensage = "Error no se pudo modificar";
                }
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                          content: Text(mensage),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          menuapp(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: Text("OK")),
                          ],
                        ));
              }
            } catch (e) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("error"),
                        content: Text(
                            "Por favor colocar solo números: " + e.toString()),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"))
                        ],
                      ));
            }
          },
          child: Text(
            "guardar",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
    ],
  );
}
