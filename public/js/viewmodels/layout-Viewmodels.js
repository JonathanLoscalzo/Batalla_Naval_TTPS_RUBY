  $(document).ready(function(){
    $("#table-games").DataTable({
      "dom": '<"top"f>rt<"bottom"p><"clear">'
    });
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

    var ViewModel = function(){
      var self = this; 
      self.UsersArray = ko.observableArray([]);
      $.getJSON("/players", function(data){
        var mappedPlayers = $.map(data, function(item){ return new PlayersViewModel(item)});
        self.UsersArray(mappedPlayers);
      });

      
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
          console.log(n);
        });

      });

      self.Sizes = ko.observableArray([]);
      $.getJSON("/sizes", function(data){
        var mappedSizes = $.map(data, function(item){ return new SizesViewModel(item)});
        self.Sizes(mappedSizes);
      });
      self.selectedSize = ko.observable();
    };

    var elem = new ViewModel();


    ko.applyBindings(elem);
  });