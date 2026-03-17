const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('bankAPI', {
  // Get all data
  getAllData: async () => {
    return ipcRenderer.invoke('bank-api:getAllData');
  },

  // Get current account
  getCurrentAccount: async () => {
    return ipcRenderer.invoke('bank-api:getCurrentAccount');
  },

  // Switch account
  switchAccount: async (accountId) => {
    return ipcRenderer.invoke('bank-api:switchAccount', accountId);
  },

  // Add transaction
  addTransaction: async (transaction) => {
    return ipcRenderer.invoke('bank-api:addTransaction', transaction);
  },

  // Create savings goal
  createSavingsGoal: async (name, target) => {
    return ipcRenderer.invoke('bank-api:createSavingsGoal', name, target);
  },

  // Add to savings goal
  addToSavingsGoal: async (goalId, amount) => {
    return ipcRenderer.invoke('bank-api:addToSavingsGoal', goalId, amount);
  },

  // Create virtual card
  createVirtualCard: async (name, accountId) => {
    return ipcRenderer.invoke('bank-api:createVirtualCard', name, accountId);
  },

  // Toggle dark mode
  toggleDarkMode: async () => {
    return ipcRenderer.invoke('bank-api:toggleDarkMode');
  },

  // Lock/unlock account
  toggleAccountLock: async () => {
    return ipcRenderer.invoke('bank-api:toggleAccountLock');
  },

  // Reset account
  resetAccount: async () => {
    return ipcRenderer.invoke('bank-api:resetAccount');
  }
});
