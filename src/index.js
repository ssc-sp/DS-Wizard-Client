'use strict';


// initialize elm app
var program = require('./elm/Main.elm');

var registerChartPorts = require('./ports/chart');
var registerImportPorts = require('./ports/import');
var registerPageUnloadPorts = require('./ports/page-unload');
var registerScrollPorts = require('./ports/scroll');
var registerSessionPorts = require('./ports/session');

var app = program.Elm.Main.init({
    node: document.body,
    flags: {
        seed: Math.floor(Math.random() * 0xFFFFFFFF),
        session: JSON.parse(localStorage.session || null),
        apiUrl: 'http://localhost:3000'
    }
});

registerChartPorts(app);
registerImportPorts(app);
registerPageUnloadPorts(app);
registerScrollPorts(app);
registerSessionPorts(app);
