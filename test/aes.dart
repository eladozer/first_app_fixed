String xorEncrypt(String text, String key) {
  List<int> encrypted = [];
  for (int i = 0; i < text.length; i++) {
    int charCode = text.codeUnitAt(i) ^ key.codeUnitAt(i % key.length);
    encrypted.add(charCode);
  }
  return String.fromCharCodes(encrypted);
}

void main() {
  String plaintext = 'Hello, world!';
  String key = 'secret';
  String encryptedText = xorEncrypt(plaintext, key);
  print('Encrypted: $encryptedText');
  print('Decrypted: ${xorEncrypt(encryptedText, key)}');
}