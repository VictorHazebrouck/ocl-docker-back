{
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      war = pkgs.stdenv.mkDerivation {
        pname = "app";
        version = "1.0.0";
        src = ./.;

        nativeBuildInputs = [
          pkgs.gradle
          pkgs.temurin-bin-21
        ];

        buildPhase = ''
          gradle clean bootWar --no-daemon
        '';

        installPhase = ''
          mkdir -p $out
          cp build/libs/*.war $out/ROOT.war
        '';
      };
    in
    {
      packages.${system}.docker = pkgs.dockerTools.buildImage {
        name = "spring-tomcat";

        copyToRoot = pkgs.buildEnv {
          name = "image-root";
          paths = [
            pkgs.tomcat
            pkgs.temurin-bin-21
          ];
        };

        runAsRoot = ''
          mkdir -p /usr/local/tomcat/webapps
          cp ${war}/ROOT.war /usr/local/tomcat/webapps/ROOT.war
        '';

        config = {
          ExposedPorts = {
            "8080/tcp" = { };
          };

          Cmd = [
            "${pkgs.tomcat}/bin/catalina.sh"
            "run"
          ];
        };
      };
    };
}
