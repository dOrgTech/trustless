
var orgs=[];
class Human {  
  String? address;
  bool metamask=true;
  Human._internal();
  // Singleton instance
  static final Human _instance = Human._internal();
  // Factory constructor to return the singleton instance
  factory Human() {
    return _instance;
  }
  signIn()async{
    
  //   try{
  //      var cevine= await promiseToFuture(
  //     ethereum!.request(
  //         RequestParams(method: 'eth_requestAccounts'),
  //       ),
  //     );
  //  }
  //  catch(e){
  //     print(e);
  //     return "nogo";
  //  }
  // address=ethereum?.selectedAddress.toString();
  await Future.delayed(const Duration(seconds: 1)).then((value) {
  address="354b4wrtwbn45yne46ug";
  });
  
  }

}
