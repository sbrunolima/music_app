import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../languages/app_language.dart';

class EmptyDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Take locale of Tablet and Smartphone
    final locale = Provider.of<LanguageProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 600,
          width: double.infinity,
        ),
        const Icon(
          Icons.music_note_outlined,
          color: Colors.white38,
          size: 40,
        ),
        Text(
          (locale.language[0].locale!.isNotEmpty &&
                  locale.language[0].locale! == 'pt_BR')
              ? 'Você ainda não tem músicas.'
              : "You don't have songs yet.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white38,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
