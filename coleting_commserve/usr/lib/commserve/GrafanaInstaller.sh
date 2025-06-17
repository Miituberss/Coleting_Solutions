#!/bin/bash
set -e

echo "[GRAFANA INSTALLER] Añadiendo repositorio de Grafana..."
mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor > /etc/apt/keyrings/grafana.gpg
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee /etc/apt/sources.list.d/grafana.list

echo "[GRAFANA INSTALLER] Instalando Grafana..."
apt update
apt install -y grafana promtail loki

echo " [GRAFANA INSTALLER] Configurando Grafana..."
mkdir -p /var/lib/grafana/dashboards
mkdir -p /etc/grafana/provisioning/datasources/
mkdir -p /etc/promtail
cp /usr/share/commserve/grafana/promtail.yml.template /etc/promtail/config.yml
cp /usr/share/commserve/grafana/dashboards.yaml /etc/grafana/provisioning/dashboards/commserve.yaml
cp /usr/share/commserve/grafana/dashboards.json /var/lib/grafana/dashboards/commserve.json
cp /usr/share/commserve/grafana/datasources.yaml /etc/grafana/provisioning/datasources/loki.yaml
cp /usr/share/commserve/grafana/loki.yml /etc/loki/config.yml

echo "[GRAFANA INSTALLER] Recargando systemd..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server.service

echo "[GRAFANA INSTALLER] Puedes editar Promtail en /etc/promtail/config.yml si es necesario."

sudo -u commadmin DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u commadmin)/bus notify-send "Commserve" "La instalación se ha completado correctamente."
echo "Commserve instalado correctamente. Ya puedes empezar a usarlo." | wall

systemctl disable grafana-deferred.service
