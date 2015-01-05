  $(document).ready(function(){
    var PlayersViewModel = function(data){
      this.id = data.id;
      this.username = data.username;
    };
    var ViewModel = function(){
      var self = this; 
      self.UsersArray = ko.observableArray([]);
      $.getJSON("/players", function(data){
        var mappedPlayers = $.map(data, function(item){ return new PlayersViewModel(item)});
        self.UsersArray(mappedPlayers);
      });
    };
    ko.applyBindings(new ViewModel());
  });