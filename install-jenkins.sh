#!/bin/bash
# Script de instalación de Jenkins con Docker
# Para Windows, ejecutar en Git Bash o WSL

set -e

echo "======================================"
echo "🚀 Instalando Jenkins con Docker"
echo "======================================"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar Docker
echo "Verificando Docker..."
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker no está instalado${NC}"
    echo "Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker no está corriendo${NC}"
    echo "Inicia Docker Desktop y vuelve a ejecutar este script"
    exit 1
fi

echo -e "${GREEN}✅ Docker está instalado y corriendo${NC}"
echo ""

# Detener Jenkins si ya existe
echo "Deteniendo Jenkins existente (si existe)..."
docker-compose -f docker-compose.jenkins.yml down 2>/dev/null || true
echo ""

# Iniciar Jenkins
echo "Iniciando Jenkins..."
docker-compose -f docker-compose.jenkins.yml up -d

echo ""
echo "Esperando a que Jenkins inicie (esto puede tomar 1-2 minutos)..."
sleep 30

# Obtener contraseña inicial
echo ""
echo "======================================"
echo "📋 Información de Jenkins"
echo "======================================"
echo ""
echo "URL: http://localhost:8080"
echo ""
echo "Contraseña inicial de administrador:"
echo "--------------------------------------"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || {
    echo "Esperando a que Jenkins genere la contraseña..."
    sleep 30
    docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
}
echo ""
echo "======================================"
echo ""
echo -e "${GREEN}✅ Jenkins instalado correctamente${NC}"
echo ""
echo "Próximos pasos:"
echo "1. Abre http://localhost:8080 en tu navegador"
echo "2. Ingresa la contraseña inicial mostrada arriba"
echo "3. Selecciona 'Install suggested plugins'"
echo "4. Crea tu usuario administrador"
echo ""
echo "Para ver los logs de Jenkins:"
echo "  docker logs -f jenkins"
echo ""
echo "Para detener Jenkins:"
echo "  docker-compose -f docker-compose.jenkins.yml down"
echo ""
