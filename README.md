# Coleting_Solutions

Repositorio [Github](https://github.com/Miituberss/Coleting_Solutions)

>[!WARNING]  
> Recordar hacer **apt update** antes de instalar
  
## Orden de instalación
commserve -> mediaagent -> cliente -> airgap

## Credenciales

### Credenciales del usuario Commadmin
**Usuario**: commadmin  
**Contraseña**: clave  
  
### Credenciales del grafana
**Usuario**: admin  
**Contraseña**: admin  
  
>[!WARNING]  
> Tras el primer inicio de sesión te pedira cambiar la contraseña  

### Conexión http a Grafana
http://IP_Commserve:3000

## AirGap
Para añadir nuevos MA al proceso de inmutabilidad se debe añadir su IP al fichero **/usr/share/airgap/lista_mediaagents.txt**

## preparar_paquete.sh
Este script permite aplicar los permisos y crear los .deb rápidamente en el caso de modificar su código fuente.
