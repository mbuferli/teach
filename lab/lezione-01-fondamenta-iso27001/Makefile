.PHONY: up wait setup audit watch down status help

help:
	@echo "make up      Avvia il container floci"
	@echo "make setup   Crea l'ambiente NuvolaSoft (volutamente vulnerabile)"
	@echo "make audit   Verifica di conformità (una tantum)"
	@echo "make watch   Verifica di conformità in loop, si ferma quando tutto è a posto"
	@echo "make status  Stato del container floci"
	@echo "make down    Ferma e rimuove il container"

up:
	@# Rimuove un eventuale container omonimo lasciato da esecuzioni precedenti
	@docker rm -f floci-lezione-01 >/dev/null 2>&1 || true
	docker compose up -d
	@echo "floci su http://localhost:4566"

# Attende che floci risponda sull'endpoint di health (max ~30s).
wait:
	@for i in $$(seq 1 30); do \
		if curl -fs http://localhost:4566/_localstack/health >/dev/null 2>&1; then \
			exit 0; \
		fi; \
		sleep 1; \
	done; \
	echo "floci non pronto su http://localhost:4566 dopo 30s"; exit 1

setup: up wait
	./setup.sh

audit: wait
	./audit.sh

watch: wait
	./audit.sh --watch

status:
	@curl -s http://localhost:4566/_localstack/health 2>/dev/null || echo "floci non raggiungibile"

down:
	docker compose down -v
