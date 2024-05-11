data "aws_subnet" "selected" {
  id = var.subnet_id
}


data "aws_iam_policy_document" "assume_ec2instance_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_role" "join_domain_role" {
  name = "AccountSetup-ec2DomainJoinRole-1ABXQAS2BTFRY"
}

data "aws_iam_policy" "amazon_ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "cloud_watch_agent_server_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.ec2_name}-ec2-role"
  description        = "IAM role for this application"
  assume_role_policy = data.aws_iam_policy_document.assume_ec2instance_policy.json
}

resource "aws_iam_role_policy_attachment" "amazon_ssm_managed_instance_core_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = data.aws_iam_policy.amazon_ssm_managed_instance_core.arn
}

resource "aws_iam_role_policy_attachment" "amazon_cloud_watch_agent_server_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = data.aws_iam_policy.cloud_watch_agent_server_policy.arn
}

resource "aws_iam_role_policy_attachment" "custom_polices" {
  for_each = toset(var.custom_policies_arns)

  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = each.value
}

// attach policy to the role

resource "aws_iam_instance_profile" "ec2_iam_instance_profile" {
  name = "${var.ec2_name}-instance-profile"
  role = data.aws_iam_role.join_domain_role.name
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = templatefile("pub_key.pub",{})
}
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.deployer.key_name

  iam_instance_profile   = aws_iam_instance_profile.ec2_iam_instance_profile.name
  vpc_security_group_ids = concat(
    var.custom_security_group_ids,
    [module.security_group.security_group_id]
  )

  user_data_base64 = var.user_data_base64

  tags = {
    Name          = var.ec2_name
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
  }
}

module "security_group" {
  source = "../../aws_security_group/1.0.0"

  security_group_prefix = "${var.ec2_name}"
  default_tags          = var.default_tags
  vpc_id                = data.aws_subnet.selected.vpc_id

  security_group_rules_cidr_blocks = var.security_group_rules_cidr_blocks
}
