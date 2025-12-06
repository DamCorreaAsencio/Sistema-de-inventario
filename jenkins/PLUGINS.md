# 🔌 Plugins Necesarios para Jenkins

## ✅ Checklist de Plugins

### Plugins que vienen con "Install suggested plugins"
- ✅ Pipeline
- ✅ Git
- ✅ Credentials
- ✅ Folders
- ✅ Timestamper
- ✅ Workspace Cleanup

### Plugins que DEBES instalar manualmente

#### Esenciales (Obligatorios)
1. ✅ **Docker Pipeline**
   - Nombre exacto: `Docker Pipeline`
   - Para: Construir y publicar imágenes Docker

2. ✅ **Terraform**
   - Nombre exacto: `Terraform`
   - Para: Ejecutar comandos Terraform

3. ✅ **CloudBees AWS Credentials**
   - Nombre exacto: `CloudBees AWS Credentials`
   - Para: Manejar credenciales AWS de forma segura

4. ✅ **Pipeline: AWS Steps**
   - Nombre exacto: `Pipeline: AWS Steps`
   - Para: Ejecutar comandos AWS CLI en el pipeline

#### Recomendados (Opcionales)
5. ✅ **Blue Ocean**
   - Nombre exacto: `Blue Ocean`
   - Para: Mejor visualización del pipeline

6. ✅ **SonarQube Scanner**
   - Nombre exacto: `SonarQube Scanner`
   - Para: Integración con SonarCloud

---

## 📝 Cómo Instalar

### Método 1: Instalar uno por uno

1. `Manage Jenkins` → `Plugins` → `Available plugins`
2. Buscar: `Docker Pipeline`
3. Marcar checkbox
4. Buscar: `Terraform`
5. Marcar checkbox
6. Buscar: `CloudBees AWS Credentials`
7. Marcar checkbox
8. Buscar: `Pipeline: AWS Steps`
9. Marcar checkbox
10. Buscar: `Blue Ocean` (opcional)
11. Marcar checkbox
12. Click **"Install"**
13. Marcar: **"Restart Jenkins when installation is complete"**

### Método 2: Buscar todos a la vez

En el buscador de plugins, busca cada uno y márcalos todos antes de instalar:
- `Docker Pipeline`
- `Terraform`
- `CloudBees AWS Credentials`
- `Pipeline: AWS Steps`
- `Blue Ocean`

Luego click **"Install"** y reiniciar.

---

## ✅ Verificar Instalación

Después de que Jenkins se reinicie:

1. `Manage Jenkins` → `Plugins` → `Installed plugins`
2. Buscar cada plugin en la lista:
   - ✅ Docker Pipeline
   - ✅ Terraform
   - ✅ CloudBees AWS Credentials
   - ✅ Pipeline: AWS Steps
   - ✅ Blue Ocean (si lo instalaste)

---

## 🔍 Nombres Exactos para Buscar

Copia y pega estos nombres en el buscador de plugins:

```
Docker Pipeline
Terraform
CloudBees AWS Credentials
Pipeline: AWS Steps
Blue Ocean
```

---

## ⚠️ Importante

- **CloudBees AWS Credentials** es el que permite usar el tipo de credencial "AWS Credentials" en Jenkins
- Sin este plugin, solo podrás usar "Username with password" para AWS
- **Pipeline: AWS Steps** permite usar comandos como `withAWS` en el Jenkinsfile

---

## 🐛 Troubleshooting

### No encuentro "CloudBees AWS Credentials"
- Busca exactamente: `CloudBees AWS Credentials`
- También puede aparecer como: `AWS Credentials Plugin`

### No encuentro "Pipeline: AWS Steps"
- Busca exactamente: `Pipeline: AWS Steps`
- Debe tener los dos puntos (:)

### Los plugins no aparecen
- Verifica que Jenkins tenga conexión a internet
- Ve a `Manage Jenkins` → `Plugins` → `Advanced settings`
- Click en **"Check now"** para actualizar la lista de plugins
