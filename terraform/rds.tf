resource "aws_db_subnet_group" "main" {
  name       = "employee-mgmt-db-subnet-group"
  subnet_ids = [aws_subnet.private_db_a.id, aws_subnet.private_db_b.id]

  tags = {
    Name = "employee-mgmt-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier     = "employee-mgmt-db"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "employee_db"
  username = "admin"
  password = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.main.id
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "employee-mgmt-db"
  }
}