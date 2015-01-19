  $(document).ready(function(){
    var PlayersViewModel = function(data){
      this.id = data.id;
      this.username = data.username;
    };

    var GameViewModel = function(data){
      this.id = data.id;
      this.username1 = data.user1.username;
      this.username2 = data.user2.username;
      this.status = data.status.description
    };
    
    var SizesViewModel = function(data){
      this.sizeText = data.size;
    };

    var SizeModel = function(){
      var self = this; 
      self.Sizes = ko.observableArray([]);
      $.getJSON("/sizes", function(data){
        var mappedSizes = $.map(data, function(item){ return new SizesViewModel(item)});
        self.Sizes(mappedSizes);
      });
      self.selectedSize = ko.observable();
    };

    var GameModel = function(){
      var self = this;
      self.games = ko.observableArray([]);
      $.getJSON("/games", function(data){

        var mappedGames = $.map(data, function(item){ return new GameViewModel(item)});
        self.games = mappedGames;
        $.map(self.games, function(n){
          n.statusLabel = ko.pureComputed(function(){
            switch(n.status) {
            case 'Iniciado.': 
              return 'label-info';
              break;
            case 'Jugando.': 
              return 'label-success';
              break;
            case'Terminado.':
              return 'label-warning';
              break;
            }
          }, n); 
        });
        $("#table-games").DataTable({
          "dom": '<"top"f>rt<"bottom"p><"clear">'
        }); 

      });
    };

    var UsersModel = function(){
      var self = this;
      self.UsersArray = ko.observableArray([]);
      $.getJSON("/players", function(data){
        var mappedPlayers = $.map(data, function(item){ return new PlayersViewModel(item)});
        self.UsersArray(mappedPlayers);
      });
    }


    var gamesModel = new GameModel();
    var usersModel = new UsersModel();
    var sizeModel = new SizeModel();
    var AllModels = {
      gamesModel : gamesModel,
      usersModel : usersModel,
      sizeModel : sizeModel
    }
    
    /*
      Para agregar atributos al AllModels 
      AllModels.attr = value; => supongo.
    */
    ko.applyBindings(AllModels);
  });