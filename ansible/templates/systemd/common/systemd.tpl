[Unit]
Description={{service_sign}}
After=network.target

[Service]
User=www
WorkingDirectory={{service_path}}
ExecStart={{start_cmd}}
ExecStop={{stop_cmd}}
Restart=always
RestartSec=5
PrivateTmp=true

[Install]
WantedBy=multi-user.target
