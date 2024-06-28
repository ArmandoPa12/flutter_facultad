import 'package:facultad/models/orden_compra.dart';
import 'package:facultad/models/orden_produccion.dart';
import 'package:facultad/pages/CRUD/produccion/produccion_read.dart';
import 'package:facultad/service/orden_compra_service.dart';
import 'package:facultad/widgets/custom_text.dart';
import 'package:facultad/widgets/drawe_list_view.dart';
import 'package:flutter/material.dart';

class OrdenCompraPage extends StatefulWidget {
  const OrdenCompraPage({super.key});

  @override
  State<OrdenCompraPage> createState() => _OrdenProduccionPageState();
}

class _OrdenProduccionPageState extends State<OrdenCompraPage> {
  late Future<List<OrdenCompra>> future;
  final _servicio = OrdenCompraService();
  bool bandera = false;
  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'creado':
        return Colors.blue;
      case 'enviado':
        return Colors.orange;
      case 'recibido':
        return Colors.yellow;
      case 'terminado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    future = _servicio.get();
    // futureRoles = _rolService.get();
    // futurePermisos = _permisosService.get();
    // futurePeriodos = _periodoServive.fecthPeriodo2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(!bandera ? 'Orden de Compra' : 'Orden de Produccion')),
      drawer: const Drawer(
        child: DrawerListView(),
      ),
      body: Column(
        children: [
          Container(
              height: 400,
              child: FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No periods found'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final itemFuture = snapshot.data![index];
                          return ListTile(
                            title: CustomText(
                                labelText:
                                    'Orden de produccion N ${itemFuture.id}'),
                            subtitle: Text(
                              'Estado ${itemFuture.estadoProd}',
                              style: TextStyle(
                                color: Colors.black,
                                backgroundColor:
                                    _getEstadoColor(itemFuture.estadoProd),
                              ),
                            ),
                            onTap: () {
                              print(itemFuture.pdfData);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EstadoProduccionRead(
                                            produccion: OrdenProduccion(
                                                userGen: '',
                                                id: 0,
                                                userTr: '',
                                                estadoProd: '',
                                                fileName: '',
                                                pdfData: '',
                                                fecha: ''),
                                            compra: itemFuture,
                                            esCompra: bandera,
                                          )));
                            },
                          );
                        },
                      );
                    }
                  })),
        ],
      ),
    );
  }
}
