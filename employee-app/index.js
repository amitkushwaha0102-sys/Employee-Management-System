const { SNSClient, PublishCommand } = require('@aws-sdk/client-sns');
const snsClient = new SNSClient({ region: "ap-south-1" });
const SNS_TOPIC_ARN = process.env.SNS_TOPIC_ARN;

const express = require('express');
const mysql = require('mysql2/promise');
const multer = require('multer');
const { SecretsManagerClient, GetSecretValueCommand } = require('@aws-sdk/client-secrets-manager');
const { S3Client, PutObjectCommand } = require('@aws-sdk/client-s3');

const app = express();
app.use(express.json());

const upload = multer({ storage: multer.memoryStorage() });
const s3Client = new S3Client({ region: "ap-south-1" });
const BUCKET_NAME = process.env.S3_BUCKET_NAME;

let pool;

async function initDatabase() {
  const client = new SecretsManagerClient({ region: "ap-south-1" });
  const command = new GetSecretValueCommand({ SecretId: "employee-mgmt-db-credentials" });
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

app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'Employee Management System API is running' });
});

app.get('/api/employees', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM employees');
  res.json(rows);
});

app.get('/api/employees/:id', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM employees WHERE id = ?', [req.params.id]);
  if (rows.length === 0) return res.status(404).json({ error: 'Employee not found' });
  res.json(rows[0]);
});

app.post('/api/employees', async (req, res) => {
  const { name, email, department, designation } = req.body;
  const [result] = await pool.query(
    'INSERT INTO employees (name, email, department, designation) VALUES (?, ?, ?, ?)',
    [name, email, department, designation]
  );

  const newEmployee = { id: result.insertId, name, email, department, designation };

  // SNS ko notification bhejo — fail ho toh bhi employee creation fail na ho
  try {
    await snsClient.send(new PublishCommand({
      TopicArn: SNS_TOPIC_ARN,
      Message: JSON.stringify(newEmployee),
      Subject: 'New Employee Onboarded'
    }));
  } catch (err) {
    console.error('SNS publish failed:', err.message);
  }

  res.status(201).json(newEmployee);
});

app.put('/api/employees/:id', async (req, res) => {
  const { name, email, department, designation } = req.body;
  await pool.query(
    'UPDATE employees SET name=?, email=?, department=?, designation=? WHERE id=?',
    [name, email, department, designation, req.params.id]
  );
  res.json({ message: 'Employee updated' });
});

app.delete('/api/employees/:id', async (req, res) => {
  await pool.query('DELETE FROM employees WHERE id=?', [req.params.id]);
  res.json({ message: 'Employee deleted' });
});

app.post('/api/employees/:id/photo', upload.single('photo'), async (req, res) => {
  const key = `profile-photos/employee-${req.params.id}.jpg`;

  await s3Client.send(new PutObjectCommand({
    Bucket: BUCKET_NAME,
    Key: key,
    Body: req.file.buffer,
    ContentType: req.file.mimetype
  }));

  res.json({ message: 'Photo uploaded', key: key });
});

initDatabase().then(() => {
  app.listen(3000, () => {
    console.log('Server running on port 3000');
  });
}).catch(err => {
  console.error('Failed to connect to database:', err);
  process.exit(1);
});