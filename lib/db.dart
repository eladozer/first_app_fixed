import 'dart:io';
import 'dart:typed_data';

void main() async {
  while (true) {
    final server = await ServerSocket.bind('10.0.0.21', 5555);
    server.listen((client) {
      handleConnection(client);
    });
  }
}

void handleConnection(Socket client) {
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}');
  // listen for events from the client
  client.listen(
    // handle data from the client
    (Uint8List data) async {
      await Future.delayed(Duration(seconds: 1));
      final message = String.fromCharCodes(data);
      print(message);
    },

    // handle errors
    onError: (error) {
      print(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () {
      print('Client left');
      client.close();
    },
  );
}
