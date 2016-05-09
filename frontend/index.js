'use strict';

require('bootstrap');
// Require index.html so it gets copied to dist
require('./index.html');


var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

// The third value on embed are the initial values for incomming ports into Elm
var app = Elm.embed(Elm.Main, mountNode);
