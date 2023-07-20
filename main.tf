
# NETWORKING #

resource "aws_vpc" "project_vpc" {
    cidr_block = var.vpc_cidr
	  enable_dns_hostnames = true
    enable_dns_support   = true
	  tags = {
      "Name" = "${var.project_name}-vpc"
    }
}

resource "aws_internet_gateway" "igw_public" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
      "Name" = "${var.project_name}-igw"
    }
}

resource "aws_subnet" "private_subnet" {
  count                   = "${length(var.private_subnet)}"
  vpc_id                  =  aws_vpc.project_vpc.id
  cidr_block              = "${var.private_subnet[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags = {
    "Name" = "${var.project_name}-private-subnet${count.index + 1}-${regex(".$", data.aws_availability_zones.available.names[count.index])}"
    "kubernetes.io/cluster/hila-eks-kanduhila" = "shared"
    "kubernetes.io/cluster/hila-eks-kanduhila" = "shared"
    "kubernetes.io/role/internal-elb"             = "1" 
    }
}


resource "aws_subnet" "public_subnet" {
  count                   = "${length(var.public_subnet)}"
  vpc_id                  =  aws_vpc.project_vpc.id
  cidr_block              = "${var.public_subnet[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.project_name}-public-subnet${count.index + 1}-${regex(".$", data.aws_availability_zones.available.names[count.index])}"
    "kubernetes.io/cluster/hila-eks-kanduhila" = "shared"
    "kubernetes.io/cluster/hila-eks-kanduhila" = "shared"
    "kubernetes.io/role/elb"                      = "1"

    }
}

# Allocate Elastic IP Address

resource "aws_eip" "eip_nat_gateway" {
  vpc    = true
  count = 1 #length(var.public_subnet)

  tags = {
      "Name" = "${var.project_name}-eip-nat-gateway-${regex(".$", data.aws_availability_zones.available.names[count.index])}"
    }
  depends_on = [aws_internet_gateway.igw_public]
}

# Create Nat Gateway

resource "aws_nat_gateway" "nat_gateway" {
  count         = 1 #length(var.public_subnet)
  allocation_id = aws_eip.eip_nat_gateway.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]

  tags = {
      "Name" = "${var.project_name}-nat-gateway-${regex(".$", data.aws_availability_zones.available.names[count.index])}"
    }
}

resource "aws_route_table" "rtb" {
  count  = length(var.route_tables_name_list)
  vpc_id = aws_vpc.project_vpc.id
  tags = {
      "Name" = "${var.project_name}-rtb-${var.route_tables_name_list[count.index]}"
    }
}

  
resource "aws_route_table_association" "public_route_asso" {
  count          = length(aws_subnet.public_subnet) 
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.rtb[0].id
}


resource "aws_route_table_association" "private_route_asso" {
  count          = length(aws_subnet.private_subnet) 
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.rtb[1].id
}


resource "aws_route" "route_public" {
  route_table_id = aws_route_table.rtb[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw_public.id

}

resource "aws_route" "route_private" {
  route_table_id = aws_route_table.rtb[1].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.nat_gateway[0].id  #aws_nat_gateway.nat_gateway.*.id[count.index]

}


