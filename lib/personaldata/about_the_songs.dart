import 'package:flutter/material.dart';

//About Songs Widget
class AboutSongs extends StatelessWidget {
  final List<String> _personalData = [
    "NCS (NoCopyrightSounds) is a UK-based record label, YouTube channel, and cross-platform creative and music community dedicated to providing opportunity for the next generation of artist and creators.",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    'assets/NCS.jpg',
                    width: MediaQuery.of(context).size.width - 50,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          bodyContent(_personalData[0]),
          const SizedBox(height: 10),
          skills('Page:', 'https://ncs.io'),
          const SizedBox(height: 10),
          skills('Usage Policy:', 'https://ncs.io/usage-policy'),
          const SizedBox(height: 10),
          skills('Youtube:', '@NoCopyrightSounds'),
        ],
      ),
    );
  }

  Widget bodyContent(String content) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget skills(String title, String name, [String? optional]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
