pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;



contract LogsStorage
{
    struct DocumentDetails
    {
        log[] logs;
    }
    
    struct log
    {
        string logContent;
        string logTime;
    }
    
    mapping (uint=>DocumentDetails) Document;
    uint count;
    
    function writeLogsOnBlockchain(uint256 documentID, string memory logData,string memory logTime) public
    {
        
        log memory l;
        l.logContent=logData;
        l.logTime=logTime;
    
        Document[documentID].logs.push(l);
        count++;
    }
    function getLogsFromBlockchain( uint256 documentID) public view returns(log[] memory)
    {
        uint numberOfLogs=Document[documentID].logs.length;
        log[] memory actualLogs=new log[](numberOfLogs);
        
        for (uint i = 0; i < numberOfLogs; i++) {
          log storage people = Document[documentID].logs[i];
          actualLogs[i] = people;
      }
        return (actualLogs);
    }
    
   function getNumberOfLogs( uint256 documentID) public view returns(uint)
    {
        uint numberOfLogs=Document[documentID].logs.length;
        return (numberOfLogs);
    }
    
    
    function compareStrings(string memory a, string memory b) public view returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
    
    function getTypesOfLogsCount( uint256 documentID) public view returns(uint,uint,uint)
    {
        uint numberOfLogs=Document[documentID].logs.length;
        uint readLogCount=0;
        uint writeLogCount=0;
        uint deleteLogCount=0;
        
        
        log[] memory actualLogs=new log[](numberOfLogs);
        
        for (uint i = 0; i < numberOfLogs; i++) 
        {
          log storage people = Document[documentID].logs[i];
          actualLogs[i] = people;
          
          if(compareStrings(actualLogs[i].logContent,"r"))
          {
              readLogCount+=1;
          }
          else if(compareStrings(actualLogs[i].logContent,"w"))
          {
              writeLogCount+=1;
          }
          else
          {
              deleteLogCount+=1;
          }
      }
        return (readLogCount,writeLogCount,deleteLogCount);
    }

    
}