const electron = require('electron');
console.log('Type of electron:', typeof electron);
console.log('Keys in electron:', Object.keys(electron).slice(0, 5));
const app = electron.app;
console.log('App:', app);
