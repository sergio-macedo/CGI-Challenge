const express = require('express');
const { exec } = require('child_process');

const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
  // Command to get the number of ready nodes
  exec('aws eks list-clusters --query "clusters" --output text', (error, stdout, stderr) => {
    if (error) {
      console.error(`Error executing command: ${error}`);
      return res.status(500).send('Error checking nodes');
    }

    const clusters = stdout.trim().split('\n');
    
    if (clusters.length > 0) {
      res.send(`Hello, World! EKS clusters found: ${clusters.join(', ')}`);
    } else {
      res.send('Hello, World! No EKS clusters found.');
    }
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
