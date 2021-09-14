App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    // Load pets.
   

    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('PetFactory.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with @truffle/contract
      var PetFactoryArtifact = data;
      App.contracts.PetFactory = TruffleContract(PetFactoryArtifact);
    
      // Set the provider for our contract
      App.contracts.PetFactory.setProvider(App.web3Provider);

    
      // init logs
      //App.LogCheck();

      return false;
    });

    return App.bindEvents();
  },

  
  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleAdopt);
    $(document).on('click', '.btn-checkStatus', App.checkStatus);
    $(document).on('click', '.btn-feedPet', App.feedPet);
  },

  checkStatus: function(event) {

    event.preventDefault();

    //var petId = parseInt($(event.target).data('id'));

    var petFactoryInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.PetFactory.deployed().then(function(instance) {
        petFactoryInstance = instance;

        // Execute adopt as a transaction by sending account
        return petFactoryInstance.checkPetInfo({from: account});
      }).then(function(result) {
        console.log(result);
        console.log(result.logs[0].args.petOwner);
        console.log(result.logs[0].args.status);
        console.log(result.logs[0].args.nextFeed.c[0]);
        console.log(result.logs[0].args.petId.c[0]);

        var text = `Pet ID: ` + result.logs[0].args.petId.c[0];
        $('#PetInfo').find('.PetID').text(text);

        text =  `Pet Owner: ` + result.logs[0].args.petOwner ;
        $('#PetInfo').find('.PetOwner').text(text);

        text =  `Pet Status: ` + result.logs[0].args.status ;
        $('#PetInfo').find('.PetStatus').text(text);

        var date = new Date(result.logs[0].args.nextFeed.c[0] * 1000);
        
        text =  `Next Feed: ` + date.toString();

        $('#PetInfo').find('.PetNextFeed').text(text);

        
        return true;

      }).catch(function(err) {
        console.log(err.message);
      });
    });

  },

  handleAdopt: function(event) {
    event.preventDefault();

    //var petId = parseInt($(event.target).data('id'));

    var petFactoryInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.PetFactory.deployed().then(function(instance) {
        petFactoryInstance = instance;

        // Execute adopt as a transaction by sending account
        return petFactoryInstance.generatePet({from: account});
      }).then(function(result) {
        return App.LogCheck();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  feedPet: function(event) {

    event.preventDefault();

    //var petId = parseInt($(event.target).data('id'));

    var petFactoryInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.PetFactory.deployed().then(function(instance) {
        petFactoryInstance = instance;

        // Execute adopt as a transaction by sending account
        return petFactoryInstance.feedPet(+new Date, {from: account});
      }).then(function(result) {
        console.log(result);
        console.log(result.logs[0].args.petOwner);
        console.log(result.logs[0].args.nextFeed.c[0]);
        console.log(result.logs[0].args.petId.c[0]);

        var text = `Pet ID: ` + result.logs[0].args.petId.c[0];
        $('#PetInfo').find('.PetID').text(text);

        text =  `Pet Owner: ` + result.logs[0].args.petOwner ;
        $('#PetInfo').find('.PetOwner').text(text);

        text =  `Pet Status: ` + result.logs[0].args.status ;
        $('#PetInfo').find('.PetStatus').text(text);

        var date = new Date(result.logs[0].args.nextFeed.c[0] * 1000);
        
        text =  `Next Feed: ` + date.toString();

        $('#PetInfo').find('.PetNextFeed').text(text);

        
        return true;

      }).catch(function(err) {
        console.log(err.message);
      });
    });

  },

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
