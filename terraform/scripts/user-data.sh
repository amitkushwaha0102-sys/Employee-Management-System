#!/bin/bash
set -e

# Log everything
exec > >(tee /var/log/user-data.log) 2>&1

echo "Starting setup..."

# Update system
apt update -y

# Install curl
apt install -y curl

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Install Nginx
apt install -y nginx

# Install PM2
npm install -g pm2

# Create application directory
mkdir -p /home/ubuntu/employee-app
cd /home/ubuntu/employee-app

# Create package.json
cat > package.json << 'PACKAGE_EOF'
{
  "name": "employee-app",
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "express": "^5.2.1",
    "mysql2": "^3.0.0",
    "@aws-sdk/client-secrets-manager": "^3.0.0"
  }
}
PACKAGE_EOF

# Create index.js
cat > index.js << 'INDEX_EOF'

const express = require('express');
const mysql = require('mysql2/promise');
const {
  SecretsManagerClient,
  GetSecretValueCommand
} = require('@aws-sdk/client-secrets-manager');

const app = express();

app.use(express.json());

let pool;

async function initDatabase() {

  const client = new SecretsManagerClient({
    region: "ap-south-1"
  });

  const command = new GetSecretValueCommand({
    SecretId: "employee-mgmt-db-credentials"
  });

  const response = await client.send(command);

  const secret = JSON.parse(response.SecretString);

  pool = mysql.createPool({

    host: process.env.DB_HOST,

    user: secret.username,

    password: secret.password,

    database: "employee_db",

    waitForConnections: true,

    connectionLimit: 5
  });

  await pool.query(`
    CREATE TABLE IF NOT EXISTS employees (

      id INT AUTO_INCREMENT PRIMARY KEY,

      name VARCHAR(100) NOT NULL,

      email VARCHAR(100) NOT NULL,

      department VARCHAR(100),

      designation VARCHAR(100)

    )
  `);

  console.log("Database connected and table ready");
}


/* Health Check */

app.get('/health', (req, res) => {

  res.json({
    status: 'ok',
    message: 'Employee Management System API is running'
  });

});


/* GET All Employees */

app.get('/api/employees', async (req, res) => {

  const [rows] = await pool.query(
    'SELECT * FROM employees'
  );

  res.json(rows);

});


/* GET Employee By ID */

app.get('/api/employees/:id', async (req, res) => {

  const [rows] = await pool.query(
    'SELECT * FROM employees WHERE id = ?',
    [req.params.id]
  );

  if (rows.length === 0) {

    return res.status(404).json({
      error: 'Employee not found'
    });

  }

  res.json(rows[0]);

});


/* CREATE Employee */

app.post('/api/employees', async (req, res) => {

  const {
    name,
    email,
    department,
    designation
  } = req.body;

  const [result] = await pool.query(

    `INSERT INTO employees
    (name, email, department, designation)
    VALUES (?, ?, ?, ?)`,

    [
      name,
      email,
      department,
      designation
    ]

  );

  res.status(201).json({

    id: result.insertId,

    name,

    email,

    department,

    designation

  });

});


/* UPDATE Employee */

app.put('/api/employees/:id', async (req, res) => {

  const {
    name,
    email,
    department,
    designation
  } = req.body;

  await pool.query(

    `UPDATE employees
     SET name=?,
         email=?,
         department=?,
         designation=?
     WHERE id=?`,

    [
      name,
      email,
      department,
      designation,
      req.params.id
    ]

  );

  res.json({
    message: 'Employee updated'
  });

});


/* DELETE Employee */

app.delete('/api/employees/:id', async (req, res) => {

  await pool.query(

    'DELETE FROM employees WHERE id=?',

    [req.params.id]

  );

  res.json({
    message: 'Employee deleted'
  });

});


/* Start Server */

initDatabase()

  .then(() => {

    app.listen(3000, () => {

      console.log(
        'Server running on port 3000'
      );

    });

  })

  .catch(err => {

    console.error(
      'Failed to connect to database:',
      err
    );

    process.exit(1);

  });

INDEX_EOF


# Fix ownership
chown -R ubuntu:ubuntu /home/ubuntu/employee-app


# Install dependencies
sudo -u ubuntu bash -c \
"cd /home/ubuntu/employee-app && npm install"


# Set DB_HOST
export DB_HOST="${db_host}"


# Start application with PM2
sudo -u ubuntu bash -c \
"cd /home/ubuntu/employee-app && \
DB_HOST=$DB_HOST pm2 start index.js --name employee-app"


# Save PM2 process
sudo -u ubuntu pm2 save


# Configure PM2 startup
env PATH=$PATH:/usr/bin pm2 startup systemd \
-u ubuntu \
--hp /home/ubuntu


# Configure Nginx
cat > /etc/nginx/sites-available/default << 'NGINX_EOF'

server {

    listen 80 default_server;

    listen [::]:80 default_server;

    server_name _;

    location / {

        proxy_pass http://localhost:3000;

        proxy_http_version 1.1;

        proxy_set_header Host $host;

        proxy_set_header X-Real-IP $remote_addr;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_set_header X-Forwarded-Proto $scheme;

    }

}

NGINX_EOF


# Test Nginx configuration
nginx -t


# Restart Nginx
systemctl restart nginx


echo "Setup complete! Thank You"