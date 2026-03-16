console.log('Global properties:', Object.keys(global).filter(k => k.toLowerCase().includes('electron')));
console.log('process.versions:', process.versions);
