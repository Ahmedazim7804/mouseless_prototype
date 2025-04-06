import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mouseless/core/controller/keys_controller.dart';
import 'package:mouseless/models/keybinding.dart';
import 'package:provider/provider.dart';

class KeysHistoryWidget extends StatefulWidget {
  const KeysHistoryWidget({super.key});

  @override
  State<KeysHistoryWidget> createState() => _KeysHistoryWidgetState();
}

class _KeysHistoryWidgetState extends State<KeysHistoryWidget> {
  late StreamSubscription sub;
  final List<List<String>> history = [];

  @override
  void initState() {
    super.initState();
    sub = Provider.of<KeysController<I3Event>>(
      context,
      listen: false,
    ).keybindingEvents.listen((keybinding) {
      setState(() {
        history.add(keybinding.keys.map((e) => e.keyLabel).toList());
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final processedHistory = history.reversed.take(10).toList();
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("History", style: TextStyle(fontSize: 20)),
          Expanded(
            child: ListView.builder(
              itemCount: history.length.clamp(0, 10),
              itemBuilder: (context, index) {
                return RichText(
                  text: TextSpan(
                    text: "${index + 1}. ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: processedHistory[index].join(" + ").toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
