void main() {
  // bool model;
  // List modelSize = [199.45046615600586, 188.0849380493164, 125.4409637451172];
  // String modelSize1 = "200,200,200";
  // List newModelSize = modelSize1.split(",");
  // String a = "11.4";
  // // print("double ? ${double.tryParse(a) is double}" );

  // var b = newModelSize.map((value) {
  //   return double.tryParse(value);
  // }).toList();


  // // print("单独来${newModelSize[1] is String}");

  // for (int i = 0; i < b.length; i++) {
  //   print("这下是了么 ${b[i] is double}");
  //   if (modelSize[i] < b[i]) {
  //     model = true;
  //   } else {
  //     model = false;
  //   }
  // }

  // print(model);

  // List strList = [150.0, 150.0, 150.0];
  // List strList2 = [119.72801208496094, 205.63400268554688, 10];
  // bool flag = false;
  // for( int i = 0;i < strList.length;i++){
  //   // print("${strList[i]}?${strList2[i]}");
  //   // print(strList[i]>strList2[i]);
  //   if(strList[i] >strList2[i] ){

  //     flag = false;
  //     break;
  //   }else{
  //     flag = true;
  //   }
  // }
  // print("?${flag}");
  Map s ={"id":123,"icon":"xxczx"};
  List list  = [{"id":56,"icon":"xxczx"},{"id":323,"icon":"xxczx"},{"id":223,"icon":"xxczx"},{"id":123,"icon":"xxczx"},];
  for(int i = 0; i<list.length; i++){
    if(list[i]["id"]==123){
      print("有");
      break;
    }else{
      print("没有");
    }
  }
}
