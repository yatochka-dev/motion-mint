.PHONY: cm up down reset gen force

# Defaults (override: make cm M=add_users)
M ?= init
DB ?= postgres://postgres:kCsn5eKAVPV5zhsG7GjqtYEDeR8mgOoGXdWWUFfp0GzCWVjNdvhBGcE5zTIa4pol@45.143.196.227:3241/postgres?sslmode=disable
MIGR_DIR := internal/db/migrations

cm:
	migrate create -ext sql -dir $(MIGR_DIR) $(M)

up:
	migrate -path $(MIGR_DIR) -database $(DB) up

down:
	migrate -path $(MIGR_DIR) -database $(DB) -verbose down 1

gen:
	sqlc generate

force:
	migrate -path ${MIGR_DIR} -database ${DB} force 0

reset:                                  # drops all, re-runs
	migrate -path $(MIGR_DIR) -database $(DB) drop -f
	migrate -path $(MIGR_DIR) -database $(DB) up
