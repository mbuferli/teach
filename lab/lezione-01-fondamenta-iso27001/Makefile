.PHONY: up setup audit watch down status help

help:
	@echo "make up      Avvia il container floci"
	@echo "make setup   Crea l'ambiente NuvolaSoft (volutamente vulnerabile)"
	@echo "make audit   Verifica di conformità (una tantum)"
	@echo "make watch   Verifica di conformità in loop, si ferma quando tutto è a posto"
	@echo "make status  Stato del container floci"
	@echo "make down    Ferma e rimuove il container"

up:
	docker compose up -d
	@echo "floci su http://localhost:4566 — attendi qualche secondo, poi lancia 'make setup'"

setup:
	./setup.sh

audit:
	./audit.sh

watch:
	./audit.sh --watch

status:
	@curl -s http://localhost:4566/_localstack/health 2>/dev/null || echo "floci non raggiungibile"

down:
	docker compose down -v
