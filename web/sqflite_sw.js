// Sqflite Web Worker Stub - Minimal implementation for development
// This is a placeholder for the actual sqflite worker

importScripts('flutter_service_worker.js');

self.addEventListener('message', (event) => {
  console.log('sqflite_sw.js: received message', event.data);
  // Echo back to indicate worker is running
  self.postMessage({
    type: 'ready',
    data: 'sqflite_sw worker initialized'
  });
});
