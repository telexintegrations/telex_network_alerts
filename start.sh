#!/bin/bash
gunicorn network_downtime_alert.wsgi:application &
python monitor.py