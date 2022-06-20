// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;


contract CreditTracker{

    struct UserCreditScore{
        address userAddress;
        uint myCreditScore;
        uint numberOfLoansTaken;
    }


    struct UserInfo{
        address addr;
        uint amount;
        uint loanDate;
        uint repaymentDate;
        bool repaid;
    }

    uint loanIndex = 1;
    mapping(address => UserCreditScore) public Tracklog;
    mapping(uint => UserInfo) public Tracker;
    mapping(address => UserInfo) public trackLoan;
    mapping(address => mapping(uint => UserInfo)) public LoanTracker;


    
    function borrowedAmount(uint amountForCollateral, address _addr) private returns(uint){
        uint amountGiven = loanLogic(amountForCollateral, msg.sender);
        return amountGiven;
    }
    

    function takeLoan(address _addr, uint _amountGiven, uint _loanDate, uint _repaymentDate) public {
        UserInfo storage tloan = trackLoan[msg.sender];
        tloan.amount = borrowedAmount(_amountGiven, msg.sender);
        tloan.addr = msg.sender;
        tloan.loanDate = _loanDate;
        tloan.repaymentDate = _repaymentDate; 
        loanIndex++;
    }

    //function creditScore assigns a score for each loan of an address.

    function creditScore(address addr, uint amount, uint startDate, uint endDate, uint repaymentDate) private {

        UserCreditScore storage userCredit = Tracklog[msg.sender];
        if(repaymentDate < endDate){
            userCredit.myCreditScore = userCredit.myCreditScore + 2;
        }
        else if(repaymentDate == endDate){
            userCredit.myCreditScore = userCredit.myCreditScore + 1;
        }
        else{
            userCredit.myCreditScore = userCredit.myCreditScore;
        }

        userCredit.userAddress = addr;
        userCredit.numberOfLoansTaken++;
    }

   
    //This contains the logic for the cummulativeCredit function.

    function cummulativeCreditLogic() internal view returns (uint){
        UserCreditScore storage user = Tracklog[msg.sender];
        uint loanTaken = user.numberOfLoansTaken;
        uint cumLoanScore = user.myCreditScore;
        uint loanPercent = ((loanTaken * 200) / cumLoanScore);
        return loanPercent;
    }

    //This calculates the percentage score of a user/address.

    function cummulativeCredit(address addr) private view returns(uint){
        addr = msg.sender;
        UserCreditScore storage user = Tracklog[msg.sender];
        if (user.numberOfLoansTaken < 9){
            return 0;
        }
        else{
            cummulativeCreditLogic();
        }
    }

    function calculateCollateral(address addr) view public returns (uint){

        addr = msg.sender;
        if (cummulativeCredit(addr) >= 80){
            return 1;
        }
        else{
            return 0;
        }
    }

    function loanLogic (uint _amount, address addr) view internal returns(uint){
        uint amountGiven;
        addr = msg.sender;
        if(calculateCollateral(addr) == 1){
            amountGiven = 1 * _amount;
            return amountGiven;
        }
        else {
            amountGiven = ((80 * _amount) / 100);
            return amountGiven;
        }
    }

}