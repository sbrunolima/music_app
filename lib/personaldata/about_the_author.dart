import 'package:flutter/material.dart';

//About Author Widget
class AboutAuthor extends StatelessWidget {
  final List<String> _personalData = [
    "sbrunolima",
    "Flutter Engineer",
    "Bruno L. Santos",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              Card(
                color: Colors.white,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.grey,
                    )),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profile('Name:', _personalData[2]),
                  const SizedBox(height: 10),
                  profile('Role:', _personalData[1]),
                  const SizedBox(height: 10),
                  profile('GitHub:', _personalData[0]),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          titles('SKILLS:'),
          skills('Programming:', 'Dart, C#, SQL, Java'),
          skills('Frameworks:', 'Flutter, Unity'),
          skills('Tools:', 'Git, GitHub, Firebase, Google Play'),
          skills('Spoken Languages:', 'Portuguese, English'),
        ],
      ),
    );
  }

  Widget profile(String title, String name) {
    return Row(
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
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget bodyContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  Widget skills(String title, String name, [String? optional]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
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

  Widget titles(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
