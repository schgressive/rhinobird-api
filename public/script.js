var serverUrl = "/";
var localStream, room;


$(function () {
  console.log("Starting Lynckia Application");

  $('#streams').on("click", "a.watch", function() {
    var item = $(this).parent();
    $('#selected_stream').html("Conntect to " + item.html() )
    joinRoom(item.data('id'), item.data('token'), 1);
  });

  $('#streams').on("click", "a.delete-stream", function() {
    var item = $(this).parent();
    var streamId = item.data('id');
    var url = serverUrl + "streams/" +  streamId;
    $.ajax({
      type: "delete",
      url: url
    }).done(function(stream) {
      item.remove();
    });
  });

  $('#new_stream').on("click", function() {
    var name = $('#stream_name').val();
    var url = serverUrl + "streams";


    $.ajax({
      type: "POST",
      data: {title: name},
      url: url
    }).done(function(stream) {

      var roomList = $('#streams');
      roomList.append("<li data-id='" + stream.id + "' data-token='"+  stream.token + "'>" + stream.title + " <a href='#' class='watch'>Watch</a> <a href='#' class='delete-stream'>Delete</a></li>")
      joinRoom(stream.id, stream.token, 0);

    });
  });

  var getStreams = function() {
    var url = serverUrl + "streams";

    $.ajax({
      type: "GET",
      url: url
    }).done(function(live_streams) {

      var roomList = $('#streams');
      $.each(live_streams, function (index, room) {
        roomList.append("<li data-id='" + room.id + "' data-token='"+  room.token + "'>" + room.title + " <a href='#' class='watch'>Watch</a> <a href='#' class='delete-stream'>Delete</a></li>")
      });

    });

  }

  var joinRoom = function(roomId, token, users) {
    if (users > 0) {
      localStream = Erizo.Stream({audio: false, video: false, data: true});
    } else {
      localStream = Erizo.Stream({audio: true, video: true, data: true});
    }
    console.log("Connecting to room, token: " + token);
    room = Erizo.Room({token: token});

    localStream.addEventListener("access-accepted", function () {

      var subscribeToStreams = function (streams) {
        for (var index in streams) {
          var stream = streams[index];
          if (localStream.getID() !== stream.getID()) {
            room.subscribe(stream);
          } 
        }
      };

      room.addEventListener("room-connected", function (roomEvent) {

        room.publish(localStream);
        subscribeToStreams(roomEvent.streams);
      });

      room.addEventListener("stream-subscribed", function(streamEvent) {
        var stream = streamEvent.stream;
        var div = document.createElement('div');
        div.setAttribute("style", "width: 320px; height: 240px;");
        div.setAttribute("id", "test" + stream.getID());

        document.body.appendChild(div);
        stream.show("test" + stream.getID());

      });

      room.addEventListener("stream-added", function (streamEvent) {
        var streams = [];
        streams.push(streamEvent.stream);
        subscribeToStreams(streams);
      });

      room.addEventListener("stream-removed", function (streamEvent) {
        // Remove stream from DOM
        var stream = streamEvent.stream;
        if (stream.elementID !== undefined) {
          var element = document.getElementById(stream.elementID);
          document.body.removeChild(element);
        }
      });

      room.connect();

      localStream.show("myVideo");

    });
    localStream.init();

  };


  getStreams();
});
