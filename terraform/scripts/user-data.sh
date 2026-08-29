#!/bin/bash
set -e

# Log everything for debugging
exec > >(tee /var/log/user-data.log) 2>&1

echo "Starting setup..."

# Update system
apt update -y

# Install Node.js via NodeSource (system-wide, consistent version)
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Install Nginx
apt install -y nginx

# Install PM2 globally
npm install -g pm2

# Create app directory
mkdir -p /home/ubuntu/employee-app
cd /home/ubuntu/employee-app

# Create package.json
cat > package.json << 'PACKAGE_EOF'
{
  "name": "employee-app",
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "express": "^5.2.1"
  }
}
PACKAGE_EOF

# Create index.js
cat > index.js << 'INDEX_EOF'
const express = require('express');
const app = express();

app.use(express.json());

let employees = [
  { id: 1, name: "Amit Kushwaha", email: "amit@company.com", department: "Engineering", designation: "DevOps Engineer" },
  { id: 2, name: "Raj Sharma", email: "raj@company.com", department: "HR", designation: "HR Manager" }
];
let nextId = 3;

app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Employee Management System API is running' });
});

app.get('/api/employees', (req, res) => {
  res.json(employees);
});

app.get('/api/employees/:id', (req, res) => {
  const employee = employees.find(e => e.id === parseInt(req.params.id));
  if (!employee) return res.status(404).json({ error: 'Employee not found' });
  res.json(employee);
});

app.post('/api/employees', (req, res) => {
  const newEmployee = {
    id: nextId++,
    name: req.body.name,
    email: req.body.email,
    department: req.body.department,
    designation: req.body.designation
  };
  employees.push(newEmployee);
  res.status(201).json(newEmployee);
});

app.put('/api/employees/:id', (req, res) => {
  const employee = employees.find(e => e.id === parseInt(req.params.id));
  if (!employee) return res.status(404).json({ error: 'Employee not found' });
  Object.assign(employee, req.body);
  res.json(employee);
});

app.delete('/api/employees/:id', (req, res) => {
  employees = employees.filter(e => e.id !== parseInt(req.params.id));
  res.json({ message: 'Employee deleted' });
});

app.listen(3000, () => {
  console.log('Server running on port 3000');
});
INDEX_EOF

# Fix ownership (script runs as root, app should belong to ubuntu user)
chown -R ubuntu:ubuntu /home/ubuntu/employee-app

# Install npm dependencies as ubuntu user
sudo -u ubuntu bash -c "cd /home/ubuntu/employee-app && npm install"

# Start app with PM2 as ubuntu user
sudo -u ubuntu bash -c "cd /home/ubuntu/employee-app && pm2 start index.js --name employee-app"
sudo -u ubuntu bash -c "pm2 save"

# Setup PM2 startup for ubuntu user
env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu

# Configure Nginx as reverse proxy
cat > /etc/nginx/sites-available/default << 'NGINX_EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
NGINX_EOF

nginx -t
systemctl reload nginx

echo "Setup complete!Thank You"