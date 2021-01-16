App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }

    return App.initContract();
  },

  initContract: function() {
    $.getJSON("LogsStorage.json", function(logs) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.LogsStorage = TruffleContract(logs);
      // Connect provider to interact with contract
      App.contracts.LogsStorage.setProvider(App.web3Provider);
    return App.render();
    });
  },

  render: function(){
    var logsinstance;
    
    web3.eth.getCoinbase(function(err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    App.contracts.LogsStorage.deployed().then(function(instance) {
      logsinstance = instance;
      return logsinstance.getNumberOfLogs();
    }).then(function(count) {
      var logsTab = $("#logs");
      logsTab.empty();

      for (var i = 1; i <= count; i++) {
        logsinstance.Document(i).then(function(doc) {
          var id = doc[0][0];
          var content = doc[0][1];
          var time = doc[0][2];

          // Render candidate Result
          var row = "<tr><th>" + id + "</th><td>" + content + "</td><td>" + time + "</td></tr>"
          logsTab.append(row);
        });
      }

    }).catch(function(error) {
      console.warn(error);
    });
  
  }  

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
