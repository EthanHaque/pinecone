BACKEND_DIR := packages/backend
FRONTEND_DIR := packages/frontend

.PHONY: help install check install-backend check-backend install-frontend check-frontend

help: ## ✨ Show this help message
	@printf "\n\033[1mUsage:\033[0m\n  make \033[36m<target>\033[0m\n\n\033[1mTargets:\033[0m\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: install-backend install-frontend ## 🚀 Install all project dependencies

check: check-backend check-frontend ## ✅ Run all checks for both projects

install-backend: ## 🐍 Install Python dependencies
	@printf "\n\033[1;34m🐍 Installing backend dependencies...\033[0m\n"
	@cd $(BACKEND_DIR) && uv sync --dev

check-backend: ## 🐍 Run all Python checks
	@printf "\n\033[1;34m🐍 Checking Backend...\033[0m\n"
	@cd $(BACKEND_DIR) && \
		printf "\033[36m   -> Formatting with Ruff...\033[0m\n" && \
		ruff format --silent . && \
		printf "\033[36m   -> Linting with Ruff...\033[0m\n" && \
		ruff check . --fix --show-fixes --silent && \
		printf "\033[36m   -> Type-checking with ty...\033[0m\n" && \
		ty check && \
		printf "\033[36m   -> Checking docs with pydoclint...\033[0m\n" && \
		pydoclint --style=numpy src/ && \
		printf "\033[36m   -> Scanning with Bandit...\033[0m\n" && \
		bandit --quiet -x tests/ -r src/ && \
		printf "\033[1;32m   ✓ All backend checks passed.\033[0m\n"

install-frontend: ## 🚀 Install Node.js dependencies
	@printf "\n\033[1;32m🚀 Installing frontend dependencies...\033[0m\n"
	@cd $(FRONTEND_DIR) && pnpm install

check-frontend: ## 🚀 Run all Node.js checks
	@printf "\n\033[1;32m🚀 Checking frontend...\033[0m\n"
	@cd $(FRONTEND_DIR) && pnpm check
