# Modulo ecr

Este módulo crea un repositorio privado de imágenes Docker en Amazon Elastic Container Registry (ECR), utilizado por el Sistema de Inventario para almacenar las imágenes del backend que serán desplegadas en instancias EC2.

El repositorio cuenta con escaneo automático de vulnerabilidades (scan_on_push = true), permitiendo detectar fallas de seguridad al momento de subir una nueva imagen.
Además, gracias a la integración con los VPC Endpoints definidos en el módulo vpc, las instancias EC2 pueden acceder al repositorio sin necesidad de conectarse a Internet, lo que incrementa la seguridad y reduce costos.
