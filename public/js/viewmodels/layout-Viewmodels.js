  $(document).ready(function(){
    var PlayersViewModel = function(data){
      this.id = data.id;
      this.username = data.username;
    };

    var GameViewModel = function(data){
      this.id = data.id;
      this.username1 = data.board1.user.username;
      this.username2 = data.board2.user.username;
      this.status = data.status.description
    };
    
    var SizesViewModel = function(data){
      this.sizeText = data.size;
      this.countShips = data.count_ships;
      this.id = data.id
    };

    var SizeModel = function(){
      var self = this; 
      self.Sizes = ko.observableArray([]);
      $.getJSON("/sizes", function(data){
        var mappedSizes = $.map(data, function(item){ return new SizesViewModel(item)});
        self.Sizes(mappedSizes);
      });
      self.selectedSize = ko.observableArray([]);
    };

    var GameModel = function(){
      var self = this;
      self.games = ko.observableArray([]);
      $.getJSON("/games/json", function(data){
        var mappedGames = $.map(data, function(item){ return new GameViewModel(item)});
        $.map(mappedGames, function(n){
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
        self.games(mappedGames);
        $("#table-games").DataTable({
          "dom": '<"top"f>rt<"bottom"p><"clear">',
          "aoColumns": [
            null,
            null,
            null,
            { "bSortable": false },
            ],
          "language": {
            "url": "https://cdn.datatables.net/plug-ins/3cfcc339e89/i18n/Spanish.json"
          }
        });
      });
    };

    var UsersModel = function(){
      var self = this;
      self.UsersArray = ko.observableArray([]);
      $.getJSON("/players/json", function(data){
        var mappedPlayers = $.map(data, function(item){ return new PlayersViewModel(item)});
        self.UsersArray(mappedPlayers);
      });
    }

    var gamesModel = new GameModel();
    var usersModel = new UsersModel();
    var sizeModel = new SizeModel();
    var ViewModel = {};
    ViewModel.usersModel = usersModel;
    ViewModel.gamesModel = gamesModel;
    ViewModel.sizeModel = sizeModel;
    /*
      Para agregar atributos al AllModels 
      AllModels.attr = value; => supongo.
    */

    ko.applyBindings(ViewModel);   

    $("[data-toggle=tooltip]").tooltip();
  });