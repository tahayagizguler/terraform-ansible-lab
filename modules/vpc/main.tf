resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # Required for EC2 instances to have public DNS names
  enable_dns_support   = true # same as above, but for DNS resolution

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1) #/24 subnet. cidrsubnet() Fonksiyonu Neden Kullanıldı? esneklik, otomasyon ve insan hatasını önlemektir. CIDR bloklarını manuel olarak hesaplamak yerine, cidrsubnet() fonksiyonu ile otomatik olarak oluşturulabilir. Bu, özellikle büyük ve karmaşık ağ yapılarında hataları azaltır ve yönetimi kolaylaştırır.
  map_public_ip_on_launch = true #Public subnet

  tags = {
    Name        = "${var.environment}-subnet"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_internet_gateway" "main" { # For public subnet to access the internet
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_route_table" "main" { # For routing traffic from the public subnet to the internet gateway
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Route all traffic to the internet
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.environment}-rt"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_route_table_association" "main" { # Associate the route table with the subnet
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}
