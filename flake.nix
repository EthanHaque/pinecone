{
  description = "Python development flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

      in
        {
        devShells.default = pkgs.mkShell {
          name = "pinecone-shell";
          buildInputs = with pkgs; [
            python313

            uv
            git
            pre-commit
            ruff

            (pkgs.python313.withPackages (ps: with ps;
              [
                python-dotenv
                structlog
              ]))
          ];

          shellHook = ''
            echo "✅ Python dev shell with uv activated."

            VENV_DIR=".venv"

            if [ -f "pyproject.toml" ]; then
              if [ ! -d "$VENV_DIR" ]; then
                echo "🔨 Creating virtual environment in '$VENV_DIR'..."
                uv venv $VENV_DIR -p ${pkgs.python313}/bin/python
              fi

              source "$VENV_DIR/bin/activate"
              echo "🐍 Virtual environment activated."

              echo "📦 Installing project in editable mode with dev dependencies..."
              uv pip install -e ".[dev]"

              echo "✅ Project installed."
            else
              echo "⚠️ 'pyproject.toml' not found. Skipping uv setup."
              echo "🐍 Using system Python: $(${pkgs.python313}/bin/python --version)"
            fi


            if [ -f .pre-commit-config.yaml ]; then
              echo "▶️ Running 'pre-commit install'..."
              pre-commit install
            else
              echo "ℹ️ No .pre-commit-config.yaml found. Skipping pre-commit setup."
            fi

            # Unset the SOURCE_DATE_EPOCH variable which can interfere with some build tools
            unset SOURCE_DATE_EPOCH
            '';
        };
      }
    );
}
