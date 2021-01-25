[Unit]
Description={{service_sign}}
After=network.target

[Service]
User=www
WorkingDirectory={{service_path}}
ExecStart={{run_cmd}}
ExecStop=/bin/kill -9 $MAINPID
Restart=always
RestartSec=5
PrivateTmp=true

[Install]
WantedBy=multi-user.target
