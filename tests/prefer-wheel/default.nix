{ lib, poetry2nix, python37 }:
let
  drv = poetry2nix.mkPoetryApplication {
    pyproject = ./pyproject.toml;
    poetrylock = ./poetry.lock;
    src = lib.cleanSource ./.;
    overrides = poetry2nix.overrides.withDefaults
      # This is also in overrides.nix but repeated for completeness
      (
        self: super: {
          maturin = super.maturin.override {
            preferWheel = true;
          };
        }
      );
  };
  isWheelAttr = drv.passthru.python.pkgs.maturin.src.isWheel or false;
in
assert isWheelAttr; drv
