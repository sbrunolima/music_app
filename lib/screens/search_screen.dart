import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/finded_trak_widget.dart';

//Providers
import '../providers/tracks_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final trackData = Provider.of<TracksProvider>(context, listen: false);
    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                onChanged: (value) {
                  trackData.findTrack(value.toString());
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  hintText: 'Search Track',
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                ),
              ),
            )
          ],
        ),
        const Divider(color: Colors.white54),
        const SizedBox(height: 10),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              FindedTrackWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
