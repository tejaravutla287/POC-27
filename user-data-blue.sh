#!/bin/bash
# Update OS packages
yum update -y

# Install Node.js setup repo and engine
curl -sL https://nodesource.com | bash -
yum install -y nodejs

# Setup application directory
mkdir -p /app
cd /app

# Generate application files inline
cat << 'EOF' > package.json
{
  "name": "poc-blue-green-app",
  "version": "1.0.0",
  "main": "app.js",
  "dependencies": { "express": "^4.19.2" }
}
EOF

cat << 'EOF' > app.js
const express = require('express');
const os = require('os');
const app = express();
const port = 80;
const APP_VERSION = process.env.APP_VERSION || "1.0.0";
const ENV_COLOR = process.env.ENV_COLOR || "BLUE";
const BACKGROUND_COLOR = ENV_COLOR === "BLUE" ? "#3498db" : "#2ecc71";
app.get('/', (req, res) => {
    const hostname = os.hostname();
    const networkInterfaces = os.networkInterfaces();
    let ipAddress = 'Unknown';
    for (let name in networkInterfaces) {
        for (let iface of networkInterfaces[name]) {
            if (iface.family === 'IPv4' && !iface.internal) ipAddress = iface.address;
        }
    }
    res.send(`<!DOCTYPE html><html><head><title>POC Blue-Green App</title><style>body { font-family: sans-serif; background-color: #f5f6fa; text-align: center; padding-top: 50px; }.card { background: white; margin: 0 auto; width: 450px; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }.badge { background-color: ${BACKGROUND_COLOR}; color: white; padding: 8px 16px; border-radius: 20px; font-weight: bold; display: inline-block; }h1 { color: #2c3e50; }</style></head><body><div class="card"><div class="badge">${ENV_COLOR} ENVIRONMENT ACTIVE</div><h1>Application Serving Traffic</h1><p><strong>Version:</strong> ${APP_VERSION}</p><p><strong>IP Address:</strong> ${ipAddress}</p></div></body></html>`);
});
app.listen(port);
EOF

# Install dependencies
npm install

# Start process using environment context safely on Port 80
export APP_VERSION="1.0.0"
export ENV_COLOR="BLUE"
node app.js > app.log 2>&1 &
