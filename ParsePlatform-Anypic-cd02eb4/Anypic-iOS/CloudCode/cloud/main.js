// Make sure all installations point to the current user
Parse.Cloud.beforeSave(Parse.Installation, function(request, response) {
  Parse.Cloud.useMasterKey();
  request.object.set('user', request.user);
  response.success();
});

Parse.Cloud.beforeSave('Photo', function(request, response) {
  var currentUser = request.user;
  var objectUser = request.object.get('user');

  if(!currentUser || !objectUser) {
    response.error('A Photo should have a valid user.');
  } else if (currentUser.id === objectUser.id) {
    response.success();
  } else {
    response.error('Cannot set user on Photo to a user other than the current user.');
  }
});

Parse.Cloud.beforeSave('Activity', function(request, response) {
  var currentUser = request.user;
  var objectUser = request.object.get('fromUser');

  if(!currentUser || !objectUser) {
    response.error('An Activity should have a valid fromUser.');
  } else if (currentUser.id === objectUser.id) {
    response.success();
  } else {
    response.error('Cannot set fromUser on Activity to a user other than the current user.');
  }
});

Parse.Cloud.afterSave('Activity', function(request) {
  // Only send push notifications for new activities
  if (request.object.existed()) {
    return;
  }

  var toUser = request.object.get("toUser");
  if (!toUser) {
    throw "Undefined toUser. Skipping push for Activity " + request.object.get('type') + " : " + request.object.id;
    return;
  }

  if (request.object.get("type") === "comment") {
    // Send comment push

    var message = "";
    if (request.user.get('displayName')) {
      message = request.user.get('displayName') + ': ' + request.object.get('content').trim();
    } else {
      message = "Someone commented on your photo.";
    }

    // Trim our message to 100 characters.
    if (message.length > 100) {
      message = message.substring(0, 99);
    }

    var query = new Parse.Query(Parse.Installation);
    query.equalTo('user', toUser);

    Parse.Push.send({
      where: query, // Set our Installation query.
      data: {
        alert: message, // Set our alert message.
        badge: 'Increment', // Increment the target device's badge count.
        // The following keys help Anypic load the correct photo in response to this push notification.
        p: 'a', // Payload Type: Activity
        t: 'c', // Activity Type: Comment
        fu: request.object.get('fromUser').id, // From User
        pid: request.object.id // Photo Id
      }
    }, {
      success: function() {
        // Push was successful
        console.log('Successful push.');
      },
      error: function(error) {
        throw "Push Error " + error.code + " : " + error.message;
      }
    });
  } else if (request.object.get("type") === "like") {
    // Send like push
    
    var message = "";
    if (request.user.get('displayName')) {
      message = request.user.get('displayName') + ' likes your photo.';
    } else {
      message = 'Someone likes your photo.';
    }

    // Trim our message to 100 characters.
    if (message.length > 100) {
      message = message.substring(0, 99);
    }

    var query = new Parse.Query(Parse.Installation);
    query.equalTo('user', toUser);

    Parse.Push.send({
      where: query, // Set our Installation query.
      data: {
        alert: message, // Set our alert message.
        // The following keys help Anypic load the correct photo in response to this push notification.
        p: 'a', // Payload Type: Activity
        t: 'l', // Activity Type: Like
        fu: request.object.get('fromUser').id, // From User
        pid: request.object.id // Photo Id
      }
    }, {
      success: function() {
        // Push was successful
        console.log('Successful push.');
      },
      error: function(error) {
        throw "Push Error " + error.code + " : " + error.message;
      }
    });
  } else if (request.object.get("type") === "follow") {
    // Send following push
    var message = "";
    if (request.user.get('displayName')) {
      message = request.user.get('displayName') + ' is now following you.';
    } else {
      message = "You have a new follower.";
    }

    // Trim our message to 100 characters.
    if (message.length > 100) {
      message = message.substring(0, 99);
    }

    var query = new Parse.Query(Parse.Installation);
    query.equalTo('user', toUser);

    Parse.Push.send({
      where: query, // Set our Installation query.
      data: {
        alert: message, // Set our alert message.
        // The following keys help Anypic load the correct photo in response to this push notification.
        p: 'a', // Payload Type: Activity
        t: 'f', // Activity Type: Follow
        fu: request.object.get('fromUser').id // From User
      }
    }, {
      success: function() {
        // Push was successful
        console.log('Successful push.');
      },
      error: function(error) {
        throw "Push Error " + error.code + " : " + error.message;
      }
    });
  }
});
