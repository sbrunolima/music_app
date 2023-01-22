import 'package:flutter/material.dart';

//Return the error while trying to connect with the database
void errorDialog(String title, String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          height: 40,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white, fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.transparent),
              backgroundColor: Colors.purple.shade800,
            ),
          ),
        ),
      ],
    ),
  );
}
