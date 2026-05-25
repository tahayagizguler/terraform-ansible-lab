resource "aws_security_group" "main" {
  name        = "${var.environment}-sg"
  description = "Security group for ${var.environment}"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Ofis ya da VPN IP adresinizle sınırlandırmanız önerilir.
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { # Varsayılan olarak tüm çıkış trafiğine izin verir, ancak güvenlik gereksinimlerinize göre özelleştirebilirsiniz.
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
