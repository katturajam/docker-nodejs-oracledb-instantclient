var oracledb = require('oracledb');
var Hapi = require("hapi");
var Joi = require("joi");

oracledb.getConnection(
  {
    user          : "<Username>",
    password      : "<Password>",
    connectString : "<Oracle DB Connection String>"
  },
  function(err, connection) {
    if (err) {
      console.error(err.message);
      return;
      }
    console.log("Oracle DB Connection Established successfully");
	doRelease(connection);
  });

function doRelease(connection) {
  connection.close(
    function(err) {
      if (err)
        console.error(err.message);
    });
}

const server = new Hapi.Server();

server.connection({"port": 3000 });

server.route({
  method: "GET",
  path: "/",
  handler: (request, response) => {
      response("Hello World");
  }
});


server.start(error => {
    if(error) {
        throw error;
    }
    console.log("Listening at " + server.info.uri);
});
