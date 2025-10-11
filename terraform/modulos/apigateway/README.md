# Módulo: API Gateway

Este módulo crea y configura el Amazon API Gateway para el Sistema de Inventario, el cual actúa como punto de entrada para las solicitudes HTTP provenientes de los usuarios o servicios externos.
Su función principal es enrutar las peticiones al Application Load Balancer (ALB), que distribuye la carga hacia las instancias EC2 del backend.
