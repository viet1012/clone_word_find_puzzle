import 'package:flutter/material.dart';

class Common {
  static void showCompletionDialog(BuildContext context, Function resetGame) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Center(
            child: Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.celebration,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                'You have completed the game.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame(); // Reset the game when the dialog is closed
                },
              ),
            ),
          ],
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, Function resetGame) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 10),
              Text(
                'Incorrect Answer',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'The answer is incorrect. Please try again.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }
}
