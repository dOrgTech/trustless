import 'dart:convert';
import 'dart:js_util';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:trustless/entities/abis.dart';
import 'package:trustless/entities/project.dart';
import 'package:trustless/entities/user.dart';
import 'package:trustless/main.dart';
import 'human.dart';
int numberOfProjects=0;

const String etherlink_testnet = 'https://node.ghostnet.etherlink.com';
class ContractFunctions{

getProjectsCounter() async {
    var httpClient = Client();
    var ethClient = Web3Client(Human().chain.rpcNode, httpClient);
    final contractSursa = DeployedContract(
      ContractAbi.fromJson(economyAbi, 'Economy'),
      EthereumAddress.fromHex(sourceAddress),
    );
    var getRepToken = contractSursa.function('getNumberOfProjects');
    Uint8List encodedData = getRepToken.encodeCall([]);
    try {
      // Log the RPC request
      print('RPC Request:');
      print(jsonEncode({
        'jsonrpc': '2.0',
        'method': 'eth_call',
        'params': [
          {
            'to': sourceAddress,
            'data': '0x' + bytesToHex(encodedData),
          },
          'latest',
        ],
        'id': 1,
      }));
      var counter = await ethClient.call(
        contract: contractSursa,
        function: getRepToken,
        params: [],
      );
      // Log the RPC response
      print('RPC Response:');
      print(counter.toString());
      int rezultat = int.parse(counter[0].toString()) as int;
      numberOfProjects = rezultat;
      print('$rezultat ${rezultat.runtimeType}');
      return rezultat;
    } catch (e) {
      print('Error: $e');
      // Log the full response body
      print('Response Body:');
      print(httpClient.toString());
      rethrow;
    }
}

getUserRep() async {
  print("getting rep");
  var httpClient = Client();
  var ethClient = Web3Client(Human().chain.rpcNode, httpClient);
  final ethAddress = EthereumAddress.fromHex(Human().address!);
  final contractSursa = DeployedContract(
    ContractAbi.fromJson(economyAbi, 'Economy'),
    EthereumAddress.fromHex(sourceAddress),
  );
  var getRepToken = contractSursa.function('getUserRep');
  print("function found");;
  try {
    var counter = await ethClient.call(
      contract: contractSursa,
      function: getRepToken,
      params: [ethAddress],
    );
    // Log the RPC response
    print('RPC Response:');
    print(counter.toString()+" and type is ${counter.runtimeType}");
    bool changes=false;
    if (!(Human().user!.nativeEarned==counter[0].toString())){Human().user!.nativeEarned=counter[0].toString();changes=true;}
    if (!(Human().user!.nativeSpent==counter[1].toString())){Human().user!.nativeSpent=counter[1].toString();changes=true;}
    if (!(Human().user!.usdtEarned==counter[2].toString())){Human().user!.usdtEarned=counter[2].toString();changes=true;}
    if (!(Human().user!.usdtSpent==counter[3].toString())){Human().user!.usdtSpent=counter[3].toString();changes=true;}
    if (changes){
      print("we have changes");
      User u  = users.firstWhere((user) => user.address.toLowerCase()  == Human().address!.toLowerCase());
      await  usersCollection.doc(u.address).set(Human().user!.toJson());
    }else{print("nothing changed.");}
  } catch (e) {
    print('Error: $e');
    // Log the full response body
    print('Response Body:');
    print(httpClient.toString());
    rethrow;
  }
}

  // Helper function to convert Uint8List to hex string
  String bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }


  getNativeBalance(String address) async {
    var httpClient = Client(); 
    var ethClient = Web3Client(Human().chain.rpcNode, httpClient);
    final ethAddress = EthereumAddress.fromHex(address);
    final balance = await ethClient.getBalance(ethAddress);
     // Close the HTTP client
    httpClient.close();
    return balance.getInWei.toString();
  }

  getUSDTBalance(){
    //TODO: implement this
  }

  getStage(String address) async {
    var httpClient = Client(); 
    var ethClient = Web3Client(Human().chain.rpcNode, httpClient);
    final deployedContract =
            DeployedContract(ContractAbi.fromJson(nativeProjectAbi,'NativeProject'), EthereumAddress.fromHex(address));
    var getRepToken = deployedContract.function('stage');
    var counter = await ethClient
            .call(contract: deployedContract, function: getRepToken, params: []);
    String rezultat= counter[0];
    print( rezultat.toString()+" "+rezultat.runtimeType.toString());
    httpClient.close();
    return rezultat;
  }
  
  getNativeEarned(String address)async{
    var httpClient = Client(); 
    var ethClient = Web3Client(Human().chain.rpcNode, httpClient);
    final contractSursa =
            DeployedContract(ContractAbi.fromJson(economyAbi,'Economy'), EthereumAddress.fromHex(sourceAddress));
    var getRepToken = contractSursa.function('nativeEarned');
    var counter = await ethClient
            .call(contract: contractSursa, function: getRepToken, params: [
             EthereumAddress.fromHex(address)
            ]);
    int rezultat= int.parse(counter[0].toString()) as int;
    numberOfProjects=rezultat;
    print("Avem așa ceva: ");
    print( rezultat.toString()+" "+rezultat.runtimeType.toString());
    return rezultat;
  }

  getNativeSpent(String address)async{
    var httpClient = Client(); 
    var ethClient = Web3Client(Human().chain.rpcNode, httpClient);
    final contractSursa =
            DeployedContract(ContractAbi.fromJson(economyAbi,'Economy'), EthereumAddress.fromHex(sourceAddress));
    var getRepToken = contractSursa.function('nativeSpent');
    var counter = await ethClient
            .call(contract: contractSursa, function: getRepToken, params: [
             EthereumAddress.fromHex(address)
            ]);
    String rezultat= counter[0].toString();
    // numberOfProjects=rezultat;
    print("Avem așa ceva: ");
    print( rezultat.toString()+" "+rezultat.runtimeType.toString());
    return rezultat;
  }
  
  createProject(Project project,state)async{
    final BigInt valueInWei = BigInt.from(100);
    // final txOptions = project.status == "open" ? {} : jsify({'value': BigInt.from(100).toString()});

    Map<String, dynamic> txOptions = project.status == "open" 
        ? {} 
        : {'value': BigInt.from(500000000000000000).toString()};

    var sourceContract = Contract(sourceAddress, sourceAbiString, Human().web3user);
      try {
        print("web3 is of type "+Human().web3user.toString());
        sourceContract = sourceContract.connect(Human().web3user!.getSigner());
        print("signed ok");
        final transaction =
          await promiseToFuture(callMethod(sourceContract, "createProject", [
          project.name,
          project.status=="open"?"0x0000000000000000000000000000000000000000":project.contractor,
          project.status=="open"?"0x0000000000000000000000000000000000000000":project.arbiter,
          project.termsHash,
          project.repo,
          jsify(txOptions)
          ],
          ));
            print("facuram tranzactia");

      final hash = json.decode(stringify(transaction))["hash"];
      print("hash " + hash.toString());
      final result = await promiseToFuture(
          callMethod(Human().web3user!, 'waitForTransaction', [hash]));
      if (json.decode(stringify(result))["status"] == 0) {
      print("nu merge eroare de greseala");
        return "not ok";
      } else {
        var rezultat=(json.decode(stringify(result)));
        print("a venit si "+rezultat.toString());
        print("e de tipul "+rezultat.runtimeType.toString());
        await getProjectsCounter();
        print("got the counter and it's " + numberOfProjects.toString());
        String projectAddress=await getProjectAddress(numberOfProjects);
        if (projectAddress.length>20){
                project.contractAddress=projectAddress;
                project.creationDate=DateTime.now();
                print("added project");
                print("suntem inainte de pop");
        print ("projectAddress "+ projectAddress.toString());
        TTransaction t= TTransaction(
              contractAddress:projectAddress,
              functionName: 'createProject',
              params: 'params',
              sender: Human().address!,
              hash: hash,
              time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
         actions.insert(0,t);
            }
        return projectAddress;
        
        }
      } catch (e) {    
          print("nu s-a putut" +e.toString());
          // state.setState(() {
          //                     state.widget.done=true;
          //                     state.widget.error=true;
          //                   });
        return "still not ok" ;
        }
    }


  setNativeParties(Project project,state)async{
      
      final txOptions = jsify({'value': BigInt.from(
        project.status=="open"?
        500000000000000000:0
        ).toString()});
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction =
            await promiseToFuture(callMethod(sourceContract, "setParties", [
            project.contractor,
            project.arbiter,
            project.termsHash,
            txOptions
            ],
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash " + hash.toString());
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
        //  om.setNotBusy();
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'setParties',
              params: 'params',
              sender: Human().address!,
              hash: hash,
              time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
            actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {
        print("nu merge c nu s-a putut" +e.toString());
        // om.setNotBusy();
      return "nu merge final" ;
      }
  }

String weiToEth(String amount){
      String ethAmount = EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(amount)).
                                getValueInUnit(EtherUnit.ether).
                                toStringAsFixed(2);

      if(BigInt.parse(amount) < BigInt.parse("10")){ethAmount="0.00";}
      return ethAmount;
}

BigInt ethToWei(double ethAmount) {
  // Convert the double to a string representation
  String ethString = ethAmount.toStringAsFixed(18);
  
  // Split the string at the decimal point
  List<String> parts = ethString.split('.');
  
  // If there's no decimal part, simply append 18 zeros
  if (parts.length == 1) {
    return BigInt.parse(parts[0]) * BigInt.from(pow(10, 18));
  }

  // Combine the integer and decimal parts, and adjust the exponent
  String integerPart = parts[0];
  String decimalPart = parts[1].substring(0, 18); // Ensure 18 digits
  String combined = integerPart + decimalPart;
  
  // Parse to BigInt
  BigInt weiAmount = BigInt.parse(combined);
  
  return weiAmount;
}

  sendFunds(Project project, amount)async{
      print("sending funds");
      Human().busy=true;
      BigInt weiAmount=ethToWei(double.parse(amount));
      final txOptions = jsify({'value':weiAmount.toString()});
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction = await promiseToFuture(callMethod(
              sourceContract, 
              "sendFunds", 
              [txOptions], // No other arguments to sendFunds method
               // Pass txOptions correctly
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash " + hash.toString());
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
          Human().busy=false;
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          Human().busy=false;
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'sendFunds',
              params: 'params',
              sender: Human().address!,
              hash: hash,
              time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
           actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {   
         Human().busy=false;
          print("nu merge c nu s-a putut" +e.toString());
        return "nu merge final" ;
      }
  }

  sign(Project project)async{
      print("signing...");
  
      final txOptions = jsify({'value': "500000000000000000"});
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction = await promiseToFuture(callMethod(
              sourceContract, 
              "signContract",
              [txOptions], 
            ));
            Human().busy=true;
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash " + hash.toString());
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
          Human().busy=false;
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          Human().busy=false;
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'sign',
              params: 'params',
              sender: Human().address!,
              hash: hash,time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
           actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {    
          print("nu merge c nu s-a putut" +e.toString());
        return "nu merge final" ;
      }
  }

  reimburse(Project project)async{
      print("signing...");
      Human().busy=true;
      Human().notifyListeners();
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction = await promiseToFuture(callMethod(
              sourceContract, 
              "reimburse",
              [],
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash $hash");
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
          Human().busy=false;
          Human().notifyListeners();
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          Human().busy=false;
          Human().notifyListeners();
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'reimburse',
              params: 'params',
              sender: Human().address!,
              hash: hash,time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
           actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {    
          print("nu merge c nu s-a putut" +e.toString());
        return "nu merge final" ;
      }
  }

 

  withdrawAsContributor(Project project)async{
      print("signing... on withdraw as contributor");
      Human().busy=true;
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction = await promiseToFuture(callMethod(
              sourceContract, 
              "withdrawAsContributor",
              [],
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash $hash");
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
          Human().busy=false;
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          Human().busy=false;
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'withdraw',
              params: 'params',
              sender: Human().address!,
              hash: hash,time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
           actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {    
          print("nu merge c nu s-a putut" +e.toString());
          Human().busy=false;
        return "nu merge final" ;
      }
  }

  withdrawAsContractor(Project project)async{
      print("signing... on withdraw as contributor");
      Human().busy=true;
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction = await promiseToFuture(callMethod(
              sourceContract, 
              "withdrawAsContractor",
              [],
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash $hash");
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
          Human().busy=false;
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          Human().busy=false;
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'withdraw',
              params: 'params',
              sender: Human().address!,
              hash: hash,time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
           actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {    
          print("nu merge c nu s-a putut" +e.toString());
          Human().busy=false;
        return "nu merge final" ;
      }
  }


  voteToReleasePayment(Project project)async{
      print("signing...");
      Human().busy=true;
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction = await promiseToFuture(callMethod(
              sourceContract, 
              "voteToReleasePayment",
              [],
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash $hash");
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
          Human().busy=false;
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          Human().busy=false;
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'voteToRelease',
              params: 'params',
              sender: Human().address!,
              hash: hash,time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
           actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {    
          print("nu merge c nu s-a putut" +e.toString());
          Human().busy=false;
        return "nu merge final" ;
      }
  }

  voteToDispute(Project project)async{
      print("signing...");
      Human().busy=true;
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction = await promiseToFuture(callMethod(
              sourceContract, 
              "voteToDispute",
              [],
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash $hash");
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
          Human().busy=false;
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          Human().busy=false;
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'voteToDispute',
              params: 'params',
              sender: Human().address!,
              hash: hash,time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
            actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {    
          print("nu merge c nu s-a putut" +e.toString());
          Human().busy=false;
        return "nu merge final" ;
      }
  }

  disputeAsContractor(Project project)async{
        print("signing...");
      Human().busy=true;
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction = await promiseToFuture(callMethod(
              sourceContract, 
              "disputeAsContractor",
              [],
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash $hash");
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
          Human().busy=false;
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          Human().busy=false;
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'dispute',
              params: 'params',
              sender: Human().address!,
              hash: hash,time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
           actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {    
          print("nu merge c nu s-a putut" +e.toString());
          Human().busy=false;
        return "nu merge final" ;
      }
    }
  
    reclaimFee(Project project)async{
        print("signing...");
      Human().busy=true;
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction = await promiseToFuture(callMethod(
              sourceContract, 
              "reclaimArbitrationFee",
              [],
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash $hash");
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
          Human().busy=false;
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          Human().busy=false;
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'reclaimFee',
              params: 'params',
              sender: Human().address!,
              hash: hash,time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
            actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {    
          print("nu merge c nu s-a putut" +e.toString());
          Human().busy=false;
        return "nu merge final" ;
      }
  }
  
  updateContributorSpendings(Project project)async{
        print("signing...");
      Human().busy=true;
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction = await promiseToFuture(callMethod(
              sourceContract, 
              "updateContributorSpendings",
              [],
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash $hash");
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
          Human().busy=false;
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          Human().busy=false;
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'updateRep',
              params: 'params',
              sender: Human().address!,
              hash: hash,time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
            actions.insert(0,t);
          return hash.toString();
        } 
      } catch (e) {    
          print("nu merge c nu s-a putut" +e.toString());
          Human().busy=false;
        return "nu merge final" ;
      }
  }

  

  arbitrate(Project project, percentage, rulingHash)async{
      var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
        try {
          sourceContract = sourceContract.connect(Human().web3user!.getSigner());
          print("signed ok");
          final transaction =
            await promiseToFuture(callMethod(sourceContract, "arbitrate", [
            percentage,
            rulingHash,
            ],
            ));
              print("facuram tranzactia");
        final hash = json.decode(stringify(transaction))["hash"];
        print("hash " + hash.toString());
        final result = await promiseToFuture(
            callMethod(Human().web3user!, 'waitForTransaction', [hash]));
        if (json.decode(stringify(result))["status"] == 0) {
        print("nu merge eroare de greseala");
        //  om.setNotBusy();
          return "nu merge";
        } else {
          var rezultat=(json.decode(stringify(result)));
          print("a venit si "+rezultat.toString());
          print("e de tipul "+rezultat.runtimeType.toString());
          TTransaction t= TTransaction(
              contractAddress:project.contractAddress!,
              functionName: 'arbitrate',
              params: 'params',
              sender: Human().address!,
              hash: hash,time: DateTime.now()
              );
              await transactionsCollection.doc(hash).set(t.toJson());
          actions.insert(0,t);
          return hash.toString();
        }
      } catch (e) {
        print("nu merge c nu s-a putut" +e.toString());
        // om.setNotBusy();
      return "nu merge final" ;
      }
  }

  getProjectAddress(counter)async{
  var httpClient = Client(); 
  var ethClient = Web3Client(Human().chain.rpcNode, httpClient);
  final contractSursa =
        DeployedContract(ContractAbi.fromJson(economyAbi,'Economy'), EthereumAddress.fromHex(sourceAddress));
  var getRepToken = contractSursa.function('deployedProjects');
  print("intainte de marea functie");
  var counter = await ethClient
          .call(contract: contractSursa, function: getRepToken, params: [BigInt.from(numberOfProjects-1)]);
    String rezultat= counter[0].toString();
    print("rezultat"+rezultat);
    print(rezultat.toString()+" "+rezultat.runtimeType.toString());
    return rezultat;
}

}