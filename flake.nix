{
  description = "Monorepo development flake for Python and Node.js";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        shared-tools = with pkgs; [
          gnumake
          git
        ];

        python-tools = with pkgs; [
          python313

          (pkgs.python313.withPackages (ps: with ps;
            [
              python-dotenv
              structlog
              flask
            ]))

          uv
          ruff
          ty
          bandit
        ];

        node-tools = with pkgs; [
          nodejs_24
          pnpm
        ];

      in
      {
        devShells = {
          default = pkgs.mkShell {
            name = "monorepo-shell";
            buildInputs = shared-tools ++ python-tools ++ node-tools;
            shellHook = ''
              echo "✅ Monorepo shell loaded. All tools are available."
            '';
          };

          backend = pkgs.mkShell {
            name = "backend-shell";
            buildInputs = shared-tools ++ python-tools;
            shellHook = ''
              echo "✅ Entering Python backend shell..."
              if [ -d "packages/backend" ]; then
                cd packages/backend
              fi

              VENV_DIR=".venv"

              if [ -f "pyproject.toml" ]; then
                  if [ ! -d "$VENV_DIR" ]; then
                      echo "🔨 Creating virtual environment..."
                      uv venv -p ${pkgs.python313}/bin/python $VENV_DIR
                  fi

                  source "$VENV_DIR/bin/activate"
                  echo "🐍 Virtual environment activated."

                  echo "📦 Installing project in editable mode with dev dependencies..."
                  uv pip install -e ".[test]"

                  echo "✅ Backend environment is ready."

                  cd "../.."
              else
                  echo "⚠️ Not in a Python project directory. Skipping uv setup."
              fi
            '';
          };

          frontend = pkgs.mkShell {
            name = "frontend-shell";
            buildInputs = shared-tools ++ node-tools;
            shellHook = ''
              echo "✅ Entering Node.js frontend shell."
              echo "➡️ To get started, navigate to your frontend directory and run 'pnpm install'."
            '';
          };
        };
      });
}
