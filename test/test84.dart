import 'dart:io';

Future<InternetAddress> getIPv4Address() async {
  // Get the IP address of the computer
  List<NetworkInterface> interfaces = await NetworkInterface.list();
  for (NetworkInterface interface in interfaces) {
    for (InternetAddress address in interface.addresses) {
      if (!address.isLinkLocal && address.type == InternetAddressType.IPv4) {
        return address;
      }
    }
  }
  throw Exception('No IPv4 address found');
}

Future<String> getAdr() async {
  try {
    InternetAddress address = await getIPv4Address();
    String ipv4Address = address.address;
    return ipv4Address;
  } catch (e) {
    print('Error: $e');
  }
  return "";
}

void main()async {
  var adr = await getAdr();
  print(adr);
}