{
  description = "A CSharp Dev Shell";

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
      name = "CSharpDevShell";
      buildInputs = with pkgs; [
        bashInteractive
        dotnet-sdk_8
        (vscode-with-extensions.override  {
          vscode = pkgs.vscode;
          vscodeExtensions = with pkgs.vscode-extensions; [
            ms-dotnettools.csdevkit
            ms-dotnettools.csharp

            jnoortheen.nix-ide
            mhutchie.git-graph
          ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "vscode-dotnet-runtime";
              publisher = "ms-dotnettools";
              version = "2.0.5";
              sha256 = "sha256-acP3NULTNNyPw5052ZX1L+ymqn9+t4ydoCns29Ta1MU=";
            }
          ];
        })
      ];

      shellHook = ''
        export PS1+="${name}> "
        echo "Welcome to the CSharp Dev Shell!"
      '';
    };
  }; 

}

