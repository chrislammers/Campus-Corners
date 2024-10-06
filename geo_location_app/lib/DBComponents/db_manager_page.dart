import 'package:flutter/material.dart';
import 'loc_model.dart';
import 'geo_location.dart';
import 'package:geo_location_app/Pages/add_location.dart';

class DBManager extends StatefulWidget {
  const DBManager({super.key});


  @override
  State<DBManager> createState() => _DBManagerState();
}

class _DBManagerState extends State<DBManager> {
  final _model = LocModel();
  var _selected;
  int? listLen;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database Manager"),
        actions: [
          IconButton(onPressed: _deleteLoc, icon: const Icon(Icons.delete)),
        ],
        backgroundColor: const Color(0xFF7AA095), // Adjust the color as needed
      ),
      body: listLocs(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addLoc(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF7AA095), // Adjust the color as needed
      ),
    );
  }

  Future _addLoc(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateLocation()));
  }

  void _deleteLoc() {
    if (_selected != null) {
      setState(() {
        _model.deleteLocWithId(_selected);
      });
    }
  }

  Widget listLocs(BuildContext context) {
    Future<List<GeoLocation>> _locList = _model.getAllLocs();

    return FutureBuilder(
      future: _locList,
      builder: (BuildContext context, AsyncSnapshot<List<GeoLocation>> snapshot) {
        Widget locListOutput;
        if (snapshot.hasData) {
          locListOutput = listBuilder(context, snapshot.data!);
        } else if (snapshot.hasError) {
          locListOutput = Text("Error: ${snapshot.error}");
        } else {
          locListOutput = const Text("No Data");
        }
        return locListOutput;
      },
    );
  }

  ListView listBuilder(BuildContext context, List<GeoLocation> snapshot) {
    listLen = snapshot.length;
    return ListView.builder(
      itemCount: snapshot.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selected = snapshot[index].id;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: snapshot[index].id == _selected ? const Color(0xFF7AA095).withOpacity(0.5) : Colors.white,
            ),
            child: ListTile(
              title: Text("${snapshot[index].imgLink}"),
              subtitle: Text("Lat: ${snapshot[index].lat}, Long: ${snapshot[index].long}"),
            ),
          ),
        );
      },
    );
  }
}
