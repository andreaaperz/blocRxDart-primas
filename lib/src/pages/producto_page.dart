import 'dart:io';

import 'package:blocpattern/src/models/producto_model.dart';
import 'package:blocpattern/src/providers/productos_provider.dart';
import 'package:blocpattern/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final productoProvider = new ProductosProvider();
  ProductoModel producto = new ProductoModel();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _guardando = false;
  File foto;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      producto = prodData;
      print(producto.toJson());
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(onPressed: _tomarFoto, icon: Icon(Icons.camera_alt))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Producto',
          fillColor: Colors.blue,
          hoverColor: Colors.blue),

      //3
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del prodcuto';
        } else {
          return null;
        }
      },
      // 2
      initialValue: producto.titulo,
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: 'Producto',
          fillColor: Colors.blue,
          hoverColor: Colors.blue),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'solo números';
        }
      },
      initialValue: producto.valor.toString(),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        primary: Colors.blue,
      ),
      label: Text('Guardar', style: TextStyle(color: Colors.white)),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  _crearDisponible() {
    return SwitchListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.blue,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    // Subir imagen
    if (foto != null) {
      producto.fotoUrl = await productoProvider.subirImagen(foto);
    } else if (producto.id == null) {
      // No imagen seleccionada para nuevo producto
      showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return _noImageAlert();
        },
      );
      setState(() {
        _guardando = false;
      });
      return;
    }

    if (producto.id == null) {
      // New Product
      await productoProvider.crearProducto(producto);
      mostrarSnackBar('Registro Guardado');
    } else {
      // Existent Product
      await productoProvider.editarProducto(producto);
      mostrarSnackBar('Registro Actualizado');
    }

    setState(() {
      _guardando = false;
    });

    Navigator.pop(context);
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  _seleccionarFoto() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);
    if (image == null) return;

    foto = File(image.path);
    if (foto != null) {
      //limpieza
    }
    print('fotito seleccionada');
    setState(() {});
    print(foto.path);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  void _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    PickedFile image = await _picker.getImage(source: origen);
    if (image == null) {
      return;
    }
    foto = File(image.path);

    if (foto != null) {
      producto.fotoUrl == null;
    }
    print('fotito seleccionada');
    setState(() {});
    print(foto.path);
  }

  Widget _noImageAlert() {
    return AlertDialog(
      title: Text('Alerta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error,
            color: Colors.yellow[700],
            size: 80.0,
          ),
          SizedBox(height: 10.0),
          Text(
            'No has seleccionado una imagen.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Text(
            'Selecciona una imagen para continuar',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black45),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: Text('OK'))
      ],
    );
  }
}