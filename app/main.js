var electron = require('electron');
const {
  app,
  BrowserWindow,
  Menu,
  //dialog,
  //ipcMain
} = electron;
//console.log(Object.keys(electron));

const windows = [];

function createWindow() {
  const menu = Menu.buildFromTemplate([
    {
      label: 'File',
      submenu: [{ role: 'quit' }
      ]
    },
    {
      label: 'View',
      submenu: [
        { role: 'toggleDevTools' },
        { type: 'separator' },
        { role: 'resetZoom' },
        { role: 'zoomIn' },
        { role: 'zoomOut' },
        { type: 'separator' },
        { role: 'toggleFullScreen' }
      ]
    },
    {
      label: 'Window',
      submenu: [
        { role: 'minimize' },
        { role: 'close' }
      ]
    }
  ]);
  Menu.setApplicationMenu(menu);

  // Create the browser window.
  var win = new BrowserWindow({
    //icon: 'ace-logo.png',
    title: 'WebGL Workspace',
    width: 800,
    height: 600
  });

  // and load the index.html of the app.
  win.loadFile('index.html');
  win.maximize();

  // Open the DevTools.
  // mainWindow.webContents.openDevTools()

  win.on('closed', function() {
    var i = windows.indexOf(win);
    windows.splice(i, 1);
  });
}

app.on('ready', createWindow);

// Quit when all windows are closed.
app.on('window-all-closed', function() {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', function() {
  if (!windows.length) {
    createWindow();
  }
});
