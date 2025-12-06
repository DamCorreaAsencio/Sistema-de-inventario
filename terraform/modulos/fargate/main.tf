# ============================================
# ECS CLUSTER - Clúster de contenedores
# Agrupa y gestiona las tareas de Fargate
# ============================================
resource "aws_ecs_cluster" "this" {
  name = "${var.project}-cluster"
}

# ============================================
# IAM ROLES - Roles de permisos
# Define quién puede asumir el rol de ejecución de tareas ECS
# ============================================
data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${var.project}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
/////////////////////////////////////////////////////////////////////////////////////
resource "aws_iam_role_policy" "ecs_sns_publish" {
  name = "${var.project}-ecs-sns-publish"
  role = aws_iam_role.task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = var.sns_topic_arn
      }
    ]
  })
} //AGREGAO DESPUÉS DE CASI TODO PQ ME OLVIDÉ DEL SQS

# ============================================
# TASK DEFINITION - Definición de la tarea
# Especifica cómo ejecutar el contenedor (CPU, memoria, imagen)
# ============================================
resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project}-task"
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repo_name}:latest"
      essential = true
      portMappings = [
        # Mala práctica, pero equis: Aquí se pone el 3000 y no 80 pq nuestra app está en 3000 xd
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

# ============================================
# ECS SERVICE - Servicio de contenedores
# Mantiene el número deseado de tareas ejecutándose
# Integra con ALB para balanceo de carga
# ============================================
resource "aws_ecs_service" "service" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = 3000
  }

  depends_on = [var.lb_listener]
}
