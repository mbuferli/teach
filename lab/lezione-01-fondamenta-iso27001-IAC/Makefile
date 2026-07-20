.PHONY: up init setup plan apply audit watch down status help

help:
	@echo "make up      Avvia il container floci"
	@echo "make setup   Crea l'ambiente NuvolaSoft con Terraform (volutamente vulnerabile)"
	@echo "make plan    Mostra il diff Terraform senza applicarlo"
	@echo "make apply   Applica le modifiche Terraform (dopo aver editato i file .tf)"
	@echo "make audit   Verifica di conformità (una tantum)"
	@echo "make watch   Verifica di conformità in loop, si ferma quando tutto è a posto"
	@echo "make status  Stato del container floci"
	@echo "make down    Distrugge le risorse Terraform, ferma e rimuove il container"

up:
	docker compose up -d
	@echo "floci su http://localhost:4566 — attendi qualche secondo, poi lancia 'make setup'"

init:
	terraform init -input=false

setup: init
	terraform apply -auto-approve -input=false

plan: init
	terraform plan

apply: init
	terraform apply -auto-approve -input=false

audit:
	./audit.sh

watch:
	./audit.sh --watch

status:
	@curl -s http://localhost:4566/_localstack/health 2>/dev/null || echo "floci non raggiungibile"

down:
	-terraform destroy -auto-approve -input=false 2>/dev/null || true
	docker compose down -v
