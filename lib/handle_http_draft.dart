import 'package:dartpy/dartpy.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

void http(String qu) {
  dartpyc.Py_Initialize();
  String start = """import requests 
    def find():
query =""" +
      qu;
  final python = start +
      """
    api_url = 'https://api.api-ninjas.com/v1/nutrition?query={}'.format(query)
    response = requests.get(api_url, headers={'X-Api-Key': 'FJnvyvhmnBeRNhDaNq9/QQ==DudESE1KlDAfjt1h'})
    if response.status_code == requests.codes.ok:
        cal_str = ""
        prot_str = ""
        name = ""
        for i in range(len(response.text)):
            if response.text[i:i+4] == "name":
                k = i+4+2
                while response.text[k] != ",":
                    name += response.text[k]
                    k += 1
                print(name)
            if response.text[i:i+8] == "calories":
                k = i+8+2
                while response.text[k] != ",":
                    cal_str += response.text[k]
                    k += 1
                print(cal_str)
            if response.text[i:i+7] == "protein":
                k = i+7+4
                while response.text[k] != ",":
                    prot_str += response.text[k]
                    k += 1
                print(prot_str)
    else:
        print("Error:", response.status_code, response.text)
   """;
  final pystring = python.toNativeUtf8();
  dartpyc.PyRun_SimpleString(pystring.cast<Int8>());
  malloc.free(pystring);
  print(dartpyc.Py_FinalizeEx());
}

void main() {
  http("11lb brisket and 25gr fries");
}
