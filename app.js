const express = require('express');
const os = require('os');
const app = express();
const port = 80;

// Read configuration from environment variables (Default to Blue)
const APP_VERSION = process.env.APP_VERSION || "1.0.0";
const ENV_COLOR = process.env.ENV_COLOR || "BLUE";
const BACKGROUND_COLOR = ENV_COLOR === "BLUE" ? "#3498db" : "#2ecc71";

app.get('/', (req, res) => {
    const hostname = os.hostname();
    const networkInterfaces = os.networkInterfaces();
    let ipAddress = 'Unknown';
    
    // Extract the local private IP address of the EC2 instance
    for (let interfaceName in networkInterfaces) {
        for (let iface of networkInterfaces[interfaceName]) {
            if (iface.family === 'IPv4' && !iface.internal) {
                ipAddress = iface.address;
            }
        }
    }

    res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>POC Blue-Green App</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f6fa; text-align: center; padding-top: 50px; }
            .card { background: white; margin: 0 auto; width: 450px; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
            .badge { background-color: ${BACKGROUND_COLOR}; color: white; padding: 8px 16px; border-radius: 20px; font-weight: bold; font-size: 1.2em; display: inline-block; margin-bottom: 20px; }
            h1 { color: #2c3e50; margin-bottom: 5px; }
            p { color: #7f8c8d; font-size: 1.1em; line-height: 1.6; }
            .footer { margin-top: 20px; font-size: 0.85em; color: #bdc3c7; }
        </style>
    </head>
    <body>
        <div class="card">
            <div class="badge">${ENV_COLOR} ENVIRONMENT ACTIVE</div>
            <h1>Application Upgraded!</h1>
            <p><strong>App Version:</strong> ${APP_VERSION}</p>
            <p><strong>EC2 Instance ID / Hostname:</strong> <br><code>${hostname}</code></p>
            <p><strong>Private IP Address:</strong> <code>${ipAddress}</code></p>
            <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
            <p style="color: #27ae60; font-size: 0.95em; font-weight: bold;">✓ Connection Stable & Seamless</p>
            <div class="footer">AWS Free-Tier Blue-Green Deployment POC</div>
        </div>
    </body>
    </html>
    `);
});

app.listen(port, () => {
    console.log(`Application running dynamically on port ${port}`);
});
