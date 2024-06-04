{
  description = "A fun enviroment for developing C#";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
          "vscode-with-extensions"
          "vscode"
          "vscode-extension-ms-dotnettools-csdevkit"
        ];
      };
    };
  in 
  {
    packages.${system} = {

      default = pkgs.writeShellScriptBin "run" ''
        nix develop -c -- code .
      '';

    };
    

    devShells.${system}.default = pkgs.mkShell rec {
      name = "CSharpForFun";
      buildInputs = with pkgs; [
        gnome.gnome-terminal
        bashInteractive
        dotnet-sdk_8
        (vscode-with-extensions.override  {
          vscode = pkgs.vscode;
          vscodeExtensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            mhutchie.git-graph
            ms-dotnettools.csdevkit
            ms-dotnettools.csharp
          ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "vscode-dotnet-runtime";
              publisher = "ms-dotnettools";
              version = "2.0.5";
              sha256 = "sha256-acP3NULTNNyPw5052ZX1L+ymqn9+t4ydoCns29Ta1MU=";
            }
            # {
            #   name = "csharp";
            #   publisher = "ms-dotnettools";
            #   version = "2.30.28";
            #   sha256 = "sha256-+loUatN8evbHWTTVEmuo9Ups6Z1AfqzCyTWWxAY2DY8=";
            # }
            # {
            #   name = "csdevkit";
            #   publisher = "ms-dotnettools";
            #   version = "1.6.8";
            #   sha256 = "sha256-rkoIneBJO3178k4Bbjji4EKNUfFAwfdsmEbnfNLuNKg=";
            # }
          ];
        })
      ];

      shellHook = ''
        export PS1+="${name}> "
        echo "Welcome to the CSharpForFun Dev Shell!"
      '';
    };
  }; 

}

