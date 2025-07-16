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
            git
            pre-commit

            python313
            uv
            ruff
            (pkgs.python313.withPackages (ps: with ps;
              [
                python-dotenv
                structlog
                flask
              ]))

            nodejs
            pnpm
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
            '';
        };
      }
    );
}
