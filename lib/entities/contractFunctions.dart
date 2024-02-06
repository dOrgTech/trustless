
import 'dart:convert';
import 'dart:js_util';

import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:http/http.dart';
import 'package:trustless/entities/abis.dart';
import 'package:trustless/entities/project.dart';
import 'package:trustless/main.dart';
import 'package:web3dart/web3dart.dart';

import 'human.dart';
int numberOfProjects=0;
const String etherlink_testnet = 'https://node.ghostnet.etherlink.com';
class ContractFunctions{
  getProjectsCounter()async{
  print("we are getting the counter baby");
  var httpClient = Client(); 
  var ethClient = Web3Client(Human().chain.rpcNode, httpClient);
  final contractSursa =
          DeployedContract(ContractAbi.fromJson(economyAbi,'Economy'), EthereumAddress.fromHex(sourceAddress));
    var getRepToken = contractSursa.function('getNumberOfProjects');
    var counter = await ethClient
            .call(contract: contractSursa, function: getRepToken, params: []);
      int rezultat= int.parse(counter[0].toString()) as int;
      numberOfProjects=rezultat;
      print(rezultat.toString()+" "+rezultat.runtimeType.toString());
      return rezultat;
    }
    

    createProject(Project project,state)async{
    final BigInt valueInWei = BigInt.from(100);
    final txOptions = project.status == "open" ? {} : jsify({'value': BigInt.from(100).toString()});
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
            }
            
    //  om.setNotBusy();
     return projectAddress;
    }
  } catch (e) {    
      print("nu s-a putut" +e.toString());
      state.setState(() {
                          state.widget.done=true;
                          state.widget.error=true;
                        });
      // om.setNotBusy();
     return "still not ok" ;

    }
}


    setNativeParties(Project project,state)async{
    final BigInt valueInWei = BigInt.from(100);
    final txOptions = jsify({'value': BigInt.from(100).toString()});
    var sourceContract = Contract(project.contractAddress!, nativeProjectAbiString, Human().web3user);
      try {
        sourceContract = sourceContract.connect(Human().web3user!.getSigner());
        print("signed ok");
        final transaction =
          await promiseToFuture(callMethod(sourceContract, "createProject", [
          project.contractor,
          project.arbiter,
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
        return "not ok";
      } else {
        var rezultat=(json.decode(stringify(result)));
        print("a venit si "+rezultat.toString());
        print("e de tipul "+rezultat.runtimeType.toString());
        
        return hash.toString();
    }
  } catch (e) {    
      print("nu s-a putut" +e.toString());
      state.setState(() {
                          state.widget.done=true;
                          state.widget.error=true;
                        });
      // om.setNotBusy();
     return "still not ok" ;

    }
}

getProjectAddress(counter)async{
  var httpClient = Client(); 
  var ethClient = Web3Client(Human().chain.rpcNode, httpClient);
  final contractSursa =
        DeployedContract(ContractAbi.fromJson(economyAbi,'Economy'), EthereumAddress.fromHex(sourceAddress!));
  var getRepToken = contractSursa.function('deployedProjects');
  print("intainte de marea functie");
  var counter = await ethClient
          .call(contract: contractSursa, function: getRepToken, params: [BigInt.from(numberOfProjects!-1)]);
    String rezultat= counter[0].toString();
    print("rezultat"+rezultat);
    print(rezultat.toString()+" "+rezultat.runtimeType.toString());
    return rezultat;
}


}