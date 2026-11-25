{ ... }:
{
  flake.nixosModules.replay-buffer-pro =
    { pkgs, ... }:
    let
      replay-buffer-pro = pkgs.callPackage (
        {
          stdenv,
          fetchFromGitHub,
          cmake,
          ninja,
          pkg-config,
          obs-studio,
          qt6,
          curl,
          ffmpeg,
        }:
        stdenv.mkDerivation rec {
          pname = "replay-buffer-pro";
          version = "1.10.0";

          src = fetchFromGitHub {
            owner = "JoshuaPotter";
            repo = "replay-buffer-pro";
            rev = version;
            fetchSubmodules = true;
            hash = "sha256-hNsoiRlGxwBfh+oXcJY4+ByhzbLNbxNXlqk6h2TVyDE=";
          };

          nativeBuildInputs = [
            cmake
            ninja
            pkg-config
            qt6.wrapQtAppsHook
          ];

          buildInputs = [
            obs-studio
            ffmpeg
            curl
            qt6.qtbase
          ];
          
          preConfigure = ''
            mkdir -p cmake/linux

            cat > cmake/linux/compilerconfig.cmake <<'EOF'
            include_guard(GLOBAL)
            include(compiler_common)
            set(CMAKE_C_STANDARD 17)
            set(CMAKE_C_STANDARD_REQUIRED ON)
            set(CMAKE_CXX_STANDARD 20)
            set(CMAKE_CXX_STANDARD_REQUIRED ON)
            add_compile_options(-fPIC)
            EOF

            cat > cmake/linux/defaults.cmake <<'EOF'
            include_guard(GLOBAL)
            set(CMAKE_FIND_PACKAGE_TARGETS_GLOBAL TRUE)
            set(BUILD_SHARED_LIBS OFF)
            EOF

            cat > cmake/linux/helpers.cmake <<'EOF'
            include_guard(GLOBAL)
            include(helpers_common)
            include(GNUInstallDirs)

            function(set_target_properties_plugin target)
              set(options "")
              set(oneValueArgs "")
              set(multiValueArgs PROPERTIES)
              cmake_parse_arguments(
                PARSE_ARGV 0 _STPO
                "''${options}"
                "''${oneValueArgs}"
                "''${multiValueArgs}"
              )

              while(_STPO_PROPERTIES)
                list(POP_FRONT _STPO_PROPERTIES key value)
                set_property(
                  TARGET "''${target}"
                  PROPERTY "''${key}" "''${value}"
                )
              endwhile()

              set_target_properties(
                "''${target}"
                PROPERTIES
                  PREFIX ""
              )

              if(TARGET plugin-support)
                target_link_libraries("''${target}" PRIVATE plugin-support)
              endif()

              install(
                TARGETS "''${target}"
                LIBRARY DESTINATION "''${CMAKE_INSTALL_LIBDIR}/obs-plugins"
              )

              if(EXISTS "''${CMAKE_CURRENT_SOURCE_DIR}/data")
                install(
                  DIRECTORY "''${CMAKE_CURRENT_SOURCE_DIR}/data/"
                  DESTINATION "''${CMAKE_INSTALL_DATAROOTDIR}/obs/obs-plugins/''${target}"
                  USE_SOURCE_PERMISSIONS
                )
              endif()
            endfunction()
            EOF
          '';

          cmakeFlags = [
            "-DENABLE_QT=ON"
            "-DBUILD_OUT_OF_TREE=ON"
          ];
        }
      ) { };
    in
    {
      programs.obs-studio.plugins = [ replay-buffer-pro ];
    };
}
