import 'package:flutter/material.dart';

import 'package:pv_analizer/logic/repositories/location_service_repo.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  HomeScreen({key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  List<String> predictionsOriginList = [];
  List<String> predictionsDestinationList = [];
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final LocationService ls = LocationService();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Google Maps'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: widget.originController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(hintText: 'Origin'),
                      onChanged: (value) async {
                        final result = await ls.getAutocompleteLocation(value);
                        setState(() {
                          widget.predictionsOriginList = result;
                        });
                      },
                    ),
                    TextFormField(
                      controller: widget.destinationController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(hintText: 'Destination'),
                      onChanged: (value) async {
                        var result = await ls.getAutocompleteLocation(value);

                        setState(() {
                          widget.predictionsDestinationList = result;
                        });
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        ls.getAutocompleteLocation('Rzeszow Zimowit');
                      },
                      icon: const Icon(
                        Icons.search,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          widget.predictionsOriginList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: widget.predictionsOriginList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          widget.originController.text = widget.predictionsOriginList[index];

                          setState(() {
                            widget.predictionsOriginList = [];
                          });
                        },
                        child: ListTile(
                          title: Text(
                            widget.predictionsOriginList[index],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox(),
          widget.predictionsDestinationList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: widget.predictionsDestinationList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          widget.destinationController.text = widget.predictionsDestinationList[index];

                          setState(() {
                            widget.predictionsDestinationList = [];
                          });
                        },
                        child: ListTile(
                          title: Text(
                            widget.predictionsDestinationList[index],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
