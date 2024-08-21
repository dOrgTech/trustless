// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//token address 0x7f0aE0670AeA108158512880A78165eF8b5Ea79F

contract TestUSDT is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }
        // Override decimals function to set 6 decimals
    function decimals() public view virtual override returns (uint8) {
        return 6;
    }
}

contract USDTEconomy {
    // Array to hold addresses of deployed projects
    address[] public deployedProjects;
    IERC20 usdt;
    address public usdtAddress;
    address payable admin;
    mapping(address => bool) public isProjectContract;
    uint public arbitrationFee=1000000000;
    mapping (address => uint) public nativeEarned;
    mapping (address => uint) public nativeSpent;
    mapping (address => uint) public usdtEarned;
    mapping (address => uint) public usdtSpent;
    constructor(
        // address _usdtAddress
        ){
        admin = payable(msg.sender); 
        // usdtAddress=_usdtAddress; 
        // usdt=IERC20(usdtAddress);
        usdt = new TestUSDT("TestUSDT", "USDT", 100_000_000 * 10**6);
        usdtAddress=address(usdt);
        }

    event TokensReceived(address from, uint256 amount);
    function onTokenReceived(address from, uint256 amount) external {
        // Custom logic to handle the received tokens
        emit TokensReceived(from, amount);
    }
    //ONLY FOR TESTING PURPOSES
    function sendTestUSDT(address _to, uint256 _amount) public {
        // TODO send rep from source.
        usdt.transfer(_to, _amount);
    }
f
    function getUSDTBalance() external view returns (uint256) {
        return usdt.balanceOf(address(this));
    }

    event InboundValue();
    fallback() external payable {
        emit InboundValue();
    }

    receive() external payable {
        emit InboundValue();
    }

    function getNumberOfProjects() public view returns (uint) {
        return deployedProjects.length;
    }

    function getUserRep(address userAddress) public view returns (uint, uint, uint, uint) {
        return (nativeEarned[userAddress], nativeSpent[userAddress], usdtEarned[userAddress], usdtSpent[userAddress]);
    }

    event NewProject(address contractAddress);
    function createProject(
    string memory name, 
    address contractor,
    address arbiter, 
    string memory termsHash,
    string memory repo
    ) public payable {
    USDTProject newProject;
    if (contractor != address(0) && arbiter != address(0)) {
        require(usdt.transferFrom(msg.sender, address(this), arbitrationFee / 2), "Must stake half the arbitration fee." );
        newProject = (new USDTProject){value: msg.value}(
           usdtAddress, payable(address(this)),name,msg.sender,contractor,arbiter,termsHash,repo,arbitrationFee
        );
    } else {
        // If the contractor is not specified, the project is in "open" stage 
        newProject = new USDTProject(
            usdtAddress,payable(address(this)),
            name, msg.sender, address(0), address(0), termsHash, repo, arbitrationFee
            );
        }
        deployedProjects.push(address(newProject));
        isProjectContract[address(newProject)] = true;
        emit NewProject(address(newProject));
    }

    function updateEarnings(address user, uint amount, bool native) external {
        require(isProjectContract[msg.sender], "Only Project contracts can call this function.");
        if (native){nativeEarned[user] += amount;}else{usdtEarned[user] += amount;}
    }

    function updateSpendings(address user, uint amount,bool native) external {
        require(isProjectContract[msg.sender], "Only Project contracts can call this function.");
         if (native){nativeSpent[user] += amount;}else{usdtSpent[user] += amount;}
    }

    function withdrawNative()  public payable {
        require(msg.sender == admin, "Only the contract owner can withdraw Ether");
        payable(msg.sender).transfer(address(this).balance);
    }
}

contract USDTProject {
    IERC20 usdt;
    USDTEconomy public economy;
    uint public coolingOffPeriodEnds;
    uint public disputeStarted;
    string public name;
    address public author;
    address public contractor;
    address public admin;
    address public arbiter;
    string public termsHash;
    string public repo;
    address[] public backers;
    mapping (address => uint) public contributors;
    mapping (address => uint) public contributorsReleasing;
    mapping (address => uint) public contributorsDisputing;
    uint public availableToContractor;
    uint public totalVotesForRelease;
    uint public totalVotesForDispute;
    uint public projectValue;
    uint public disputeResolution;
    string public ruling_hash;
    bool fundsReleased;
    string public stage;
    uint public arbitrationFee;
    bool public arbitrationFeePaidOut = false;
    bool public contractorWithdrawnArbitrationFee = false;
    bool public authorWithdrawnArbitrationFee = false;
    // constructor
    constructor(
        address _usdtAddress,
        address payable _economy,
        string memory _name,
        address _author,
        address _contractor,
        address _arbiter,
        string memory _termsHash,
        string memory _repo,
        uint _arbitrationFee)
        payable
        {
        usdt=IERC20(_usdtAddress);
        economy = USDTEconomy(_economy);
        fundsReleased=false;
        name = _name;
        author = _author;
        contractor = _contractor;
        arbiter = _arbiter;
        termsHash = _termsHash;
        repo = _repo;
        availableToContractor = 0;
        totalVotesForRelease=0;
        totalVotesForDispute=0;
        projectValue=0;
        disputeResolution = 0;
        arbitrationFee = _arbitrationFee;
        ruling_hash = "";
        if (contractor != address (0) && arbiter != address (0)) { // check if the contractor and arbiter are assigned.
            require(msg.value >= arbitrationFee / 2, "Must stake half of the arbitration fee");
            stage = "pending"; // assign "pending" to the stage variable
        } else {
            stage = "open"; // assign "open" to the stage variable
        }
    }

    function getInfo1() public view returns (string memory){
        return string(abi.encodePacked(
            "{",
            '"coolingOffPeriodEnds":', uintToString(coolingOffPeriodEnds), ",",
            '"stage":"', stage, '",',
            '"repo":"', repo, '",',
            '"projectValue":"', uintToString(projectValue), '",',
            '"disputing":"', uintToString(totalVotesForDispute), '",',
            '"releasing":"', uintToString(totalVotesForRelease), '",',
            "}"
        ));
    }
    
    function getUSDTBalance() external view returns (uint256) {
        return usdt.balanceOf(address(this));
    }

    function arbitrationPeriodExpired() public payable {
        require(keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("dispute"))
        &&
        disputeStarted + 150 days > block.timestamp, 
        "This can only be called if the arbiter doesn't rule within 150 days after dispute started");
        stage = "closed";
        emit ProjectClosed(msg.sender);
    }
   
    event SetParties(address _contractor, address _arbiter, string _termsHash);
    function setParties(address _contractor, address _arbiter, string memory _termsHash, uint256 fee) public payable{
        require(keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("open")) || 
        keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("pending")), 
        "Parties can be set only in 'open' or 'pending' stage.");
        require (msg.sender==author,"Only the Project's Author can set the other parties.");
        if (keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("open")))
        {
        require(fee >= arbitrationFee / 2, "Must stake half of the arbitration fee.");
        require(usdt.transferFrom(msg.sender, address(this), fee), "Fee transfer failed");
        }
        coolingOffPeriodEnds = block.timestamp + 2 minutes;
        contractor=_contractor;
        arbiter=_arbiter;
        termsHash=_termsHash;
        emit SetParties(_contractor, _arbiter, _termsHash);
        stage="pending";
    }

    event SendFunds(address who, uint256 howMuch);
    function sendFunds(uint256 amount) external {
        require(keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("open")) ||
         keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("pending")),
          "Funding is only allowed when the project is in 'open' or 'pending' stage.");
        require(usdt.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        backers.push(msg.sender);
        contributors[msg.sender] += amount;
        emit SendFunds(msg.sender, amount);
        projectValue += amount;
    }

    event ContractorPaid(address contractor);
    function withdrawAsContractor() external{
        require(
            keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("closed")),
            "The contractor can only withdraw once the project is closed.");
        require(msg.sender == contractor, "Only the contractor can withdraw.");
        require(availableToContractor>0,"Nothing to withdraw");
        uint256 amountToWithdraw = (availableToContractor / 100) * 99 ;
        uint256 platformFee = availableToContractor / 100 ;
        availableToContractor = 0; // Prevent re-entrancy by zeroing before transfer
        economy.updateEarnings(contractor, amountToWithdraw, true);
        usdt.transfer(contractor, amountToWithdraw);
        usdt.transfer(address(economy), platformFee);
        emit ContractorPaid(contractor);
    }
    
    function updateContributorSpendings()public{
        require(disputeResolution < 100, "on disputed projects, spendings are updated in the withdraw function.");
        require(
            keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("closed")),
            "Stats can be updated once the project is closed.");
        uint expenditure=contributors[msg.sender];
        if (expenditure>0){
        contributors[msg.sender]=0;
        economy.updateSpendings(msg.sender,expenditure,true);
        }
    }

    function reclaimArbitrationFee()public{
        require(
            keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("closed")) ,
            "Arbitration fee can be reclaimed once the project is closed.");
        require (arbitrationFeePaidOut==false, "The fee has been paid out to the Arbiter (because there was a dispute).");
        require (msg.sender==author||msg.sender==contractor, "Arbitration fee can only be returned to the parties.");
        if (msg.sender==author){
            require(authorWithdrawnArbitrationFee==false, "You have already claimed this back.");
            authorWithdrawnArbitrationFee=true;
            uint amountToWithdraw=arbitrationFee/2;
            bool sent = usdt.transfer(author, amountToWithdraw);
            require(sent, "Failed to withdraw.");
        }
        if (msg.sender==contractor){
            require(contractorWithdrawnArbitrationFee==false, "You have already claimed this back.");
            contractorWithdrawnArbitrationFee=true;
            uint amountToWithdraw=arbitrationFee/2;
            bool sent = usdt.transfer(contractor, amountToWithdraw);
            require(sent, "Failed to withdraw.");
        }
    }

    function withdrawAsContributor() public {
        require(
            keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("open"))||
            keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("pending"))||
            keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("closed")) ,
         "Withdrawals only allowed when the project is open, pending or closed.");
        uint256 contributorAmount = contributors[msg.sender];
        uint256 exitAmount = (contributorAmount / 100 ) * (100-disputeResolution);
        uint256 expenditure = contributorAmount - exitAmount;
        if (disputeResolution>0){
            economy.updateSpendings(msg.sender,expenditure,true);
        }
        contributors[msg.sender] = 0;
        bool sent = usdt.transfer(msg.sender, exitAmount);
        require(sent, "Failed to send Ether");
        projectValue=projectValue-exitAmount;
    }

    event ContractSigned(address contractor);
    function signContract(uint256 fee) public payable {
        // Check if the caller is the designated contractor
        require(msg.sender == contractor, "Only the designated contractor can sign the contract");
        // Check if the project is in the "pending" stage
        require(keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("pending")), "The project can only be signed while in `pending` stage.");
        require(block.timestamp > coolingOffPeriodEnds, "Contract signing is blocked during the cooling-off period.");
        // Update the stage to "ongoing"
        require(fee >= arbitrationFee / 2, "Must stake half of the arbitration fee.");
        require(usdt.transferFrom(msg.sender, address(this), fee), "Fee transfer failed");
        require(projectValue > 0, "Can't sign a contract with no funds in it.");
        stage = "ongoing";
        emit ContractSigned(msg.sender);
    }

    event ProjectClosed(address by);
    function reimburse() public {
        // Ensure that only the contractor can call this function
        require(msg.sender == contractor, "Only the contractor can call this function.");
        // Check that the project is currently in the "ongoing" stage
        require(keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("ongoing")), "This action can only be performed while the project is ongoing.");
        // Move the project to "closed" mode
        stage = "closed";
        emit ProjectClosed(msg.sender);
    }

    // Function to vote for releasing payment to the contractor
    function voteToReleasePayment() public {
        require(keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("ongoing")), "Project must be ongoing to vote");
        // Directly reset dispute vote and adjust total votes
        totalVotesForDispute -= contributorsDisputing[msg.sender];
        contributorsDisputing[msg.sender] = 0;
        // Update release vote if not already voted
        if (contributorsReleasing[msg.sender] == 0) {
            totalVotesForRelease += contributors[msg.sender];
        }
        contributorsReleasing[msg.sender] = contributors[msg.sender];
        // Check if the threshold for releasing the payment is met
        if (totalVotesForRelease >projectValue * 70 / 100) {
            stage = "closed";
            availableToContractor = projectValue;
            fundsReleased = true;
            emit ProjectClosed(msg.sender);
        }
    }

    event ProjectDisputed(address by);
    // Function to vote to dispute the project
    function voteToDispute() public {
        require(keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("ongoing")), "Project must be ongoing to vote");
        // Directly reset release vote and adjust total votes
        totalVotesForRelease -= contributorsReleasing[msg.sender];
        contributorsReleasing[msg.sender] = 0;
        // Update dispute vote if not already voted
        if (contributorsDisputing[msg.sender] == 0) {
            totalVotesForDispute += contributors[msg.sender];
        }
        contributorsDisputing[msg.sender] = contributors[msg.sender];
        // Check if the threshold for disputing the project is met
        if (totalVotesForDispute > projectValue * 70 / 100) {
            stage = "dispute";
            emit ProjectDisputed(msg.sender);
        }
    }

    function disputeAsContractor() public {
        require(msg.sender == contractor, "Only the designated Contractor can call this function");
        require(keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("ongoing")), "This can only be called while the project is ongoing");
        stage = "dispute";
        disputeStarted = block.timestamp;
        emit ProjectDisputed(msg.sender);
    }

    function arbitrate(uint256 percent, string memory rulingHash) public {
        require(keccak256(abi.encodePacked(stage)) == keccak256(abi.encodePacked("dispute")), "Arbitration can only occur if the project is in dispute.");
        require(msg.sender == arbiter, "Only the Arbiter can call this function");
        require(percent >= 0 && percent <= 100, "Resolution needs to be a number between 0 and 100");
        availableToContractor = (projectValue / 100) * percent;
        disputeResolution=percent;
        ruling_hash = rulingHash;
        usdt.transfer( arbiter, arbitrationFee);
        arbitrationFeePaidOut = true;
        stage = "closed";
        economy.updateEarnings(arbiter, arbitrationFee,true);
        emit ProjectClosed(msg.sender);
    }

        // Helper function to convert uint to string
    function uintToString(uint value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint temp = value;
        uint digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + value % 10));
            value /= 10;
        }
        return string(buffer);
    }

    // Helper function to convert address to string
   function addressToString(address addr) internal pure returns (string memory) {
    bytes32 value = bytes32(uint256(uint160(addr)));
    bytes memory alphabet = "0123456789abcdef";
    bytes memory str = new bytes(42);
    str[0] = "0";
    str[1] = "x";
    for (uint256 i = 0; i < 20; i++) {
        str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
        str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
    }
    return string(str);
}

}