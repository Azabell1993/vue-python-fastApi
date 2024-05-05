#!/bin/bash
export SECRET_KEY=$(openssl rand -hex 32)
exec uvicorn src.main:app --reload --host 0.0.0.0 --port 5000