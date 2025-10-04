# Contenedorización

El repositorio ECR actúa como la galería de arte digital donde almacenamos y versionamos las imágenes Docker de nuestra aplicación backend. Es el lugar centralizado y seguro donde se guardan todas las versiones de nuestro código empaquetado en contenedores.

**Tecnologías Implementadas**

Se configura un repositorio privado en Amazon ECR con escaneo automático de vulnerabilidades al subir imágenes, etiquetas mutables para desarrollo y protección contra eliminación accidental. El repositorio sirve como registro privado para almacenar y gestionar las imágenes Docker del backend.

**Justificación de su Uso**

ECR proporciona un almacenamiento seguro y escalable para las imágenes de contenedores, permitiendo despliegues consistentes y confiables. El escaneo automático de seguridad garantiza que las imágenes no contengan vulnerabilidades conocidas, mientras que la inmutabilidad de etiquetas facilita el control de versiones durante el desarrollo.

**Cumplimiento de Requisitos**

El repositorio ECR asegura la disponibilidad mediante almacenamiento duradero de imágenes, implementa seguridad con escaneo automático de vulnerabilidades, y soporta escalabilidad al permitir despliegues rápidos y consistentes de contenedores en múltiples instancias EC2.
