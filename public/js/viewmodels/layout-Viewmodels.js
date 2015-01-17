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

    var ViewModel = function(){
      var self = this; 
      self.UsersArray = ko.observableArray([]);
      self.games = ko.observableArray([]);
      $.getJSON("/players", function(data){
        var mappedPlayers = $.map(data, function(item){ return new PlayersViewModel(item)});
        self.UsersArray= mappedPlayers;
      });

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
          console.log(n);
        });

      });
    };

    var elem = new ViewModel();


    ko.applyBindings(elem);
  });