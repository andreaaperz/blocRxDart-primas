import 'package:blocpattern/src/models/producto_model.dart';
import 'package:blocpattern/src/providers/productos_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productosProvider = new ProductosProvider();

  Future<List<ProductoModel>> fetchingProducts;

  @override
  void initState() {
    super.initState();
    fetchingProducts = productosProvider.cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.purple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: fetchingProducts,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return RefreshIndicator(
            onRefresh: () async {
              fetchingProducts = productosProvider.cargarProductos();
              setState(() {});
              await fetchingProducts;
            },
            child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (contex, i) => _crearItem(context, productos[i])),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          productosProvider.borrarProducto(producto.id);
        },
        /* Widget productDetails = Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0), */
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.purple, width: 5),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10)),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: (producto.fotoUrl == null)
                    ? Image(image: AssetImage('assets/no-image.png'))
                    : FadeInImage(
                        placeholder: AssetImage('assets/no-image.png'),
                        image: NetworkImage(producto.fotoUrl),
                        height: 200,
                        width: 350,
                        fit: BoxFit.cover,
                        )
              ),
              ListTile(
                title: Text(
                  '${producto.titulo} - ${producto.valor.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)
                ),
                onTap: () => Navigator.pushNamed(context, 'producto',
                    arguments: producto),
              )
            ],
          ),
        )
        /*  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${producto.titulo}',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Expanded(child: Container()),
          Text(
            '\$${producto.valor.toStringAsFixed(2)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ), */
        );

    /*  Widget _crearItem(BuildContext context, ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          productosProvider.borrarProducto(producto.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(producto.fotoUrl),
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.titulo} -${producto.valor}'),
                subtitle: Text(producto.id),
                /* onTap: ()=>Navigator.pushNamed(context, 'producto'), */
                onTap: () => Navigator.pushNamed(context, 'producto',
                    arguments: producto),
              )
            ],
          ),
        ));
  } */

    /* Widget _productImage() {
      if (producto.fotoUrl == null) {
        return Image(image: AssetImage('assets/no-image.png'));
      }

      return Container(
        child: ClipRect(
          child: FadeInImage(
            image: NetworkImage(producto.fotoUrl),
            placeholder: AssetImage('assets/jar-loading.gif'),
            height: 80,
            alignment: Alignment.center,
            width: 150.0,
            fit: BoxFit.cover,
          ),
        ),
      );
    } */

    /* Widget cardContent = Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF463FAF),
          width: 2,
        ),
      ),
      height: 150.0,
      padding: EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _productImage(),
          Expanded(
            child: productDetails,
          )
        ],
      ),
    ); */

    /* return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion) {
        productosProvider.borrarProducto(producto.id);
      },
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () =>
            Navigator.pushNamed(context, 'Productos', arguments: producto),
        child: Card(
          child: Ink(
            child: cardContent,
          ),
        ),
      ),
    ); */
  }
}
