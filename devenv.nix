{ pkgs, lib, config, inputs, ... }:

{
  # Variables de entorno para esta shell
  env = {
    
  };

  devcontainer.enable = true;
  
  # https://devenv.sh/packages/
  packages = [ 
    pkgs.conda  # Para poder usar el gestor de paquetes de Conda en Nix
    pkgs.spark_3_5
  ];
  
  # Para poder usar Spark
  languages.java = {
    enable = true;
    jdk.package = pkgs.jdk17;
  };
  
  # Para usar Jupyter Notebook en local
  languages.javascript.enable = true;

  # https://devenv.sh/basics/
  enterShell = ''
    echo "Bienvenido al shell de desarrollo con dependencias de Python para PySpark"
  '';
  
  # Scripts personalizados para poder usar paquetes de Conda y PySpark en esta shell
  
  scripts = {
    prepare-env = {
      exec = ''
        echo 'Iniciando preparación del entorno sparkenv...'
        conda-shell -c "
          echo 'Creando el entorno sparkenv con Python 3.12...'
          conda create -n sparkenv python=3.12 anaconda -y
          echo 'Instalando paquetes científicos...'
          conda install -n sparkenv -c anaconda numpy scipy ipython ipykernel scikit-learn pandas pip -y
          echo 'Instalando matplotlib...'
          conda install -n sparkenv -c conda-forge matplotlib -y
          echo 'Instalando paquetes para PySpark (Spark)...'
          conda install -n sparkenv pyspark -y
          conda install -n sparkenv -c conda-forge findspark -y
          echo 'Configuración completada exitosamente!'
        "
        echo '¡Entorno sparkenv preparado y listo para usar!'
      '';
      description = "Prepara el entorno conda sparkenv con todas las librerías necesarias";
    };
    
    install-jupyter = {
      exec = ''
        echo 'Iniciando instalación de Jupyter Lab...'
        conda-shell -c "
          conda install -n sparkenv -c anaconda jupyterlab -y
        "
      '';
      description = "Instala JupyterLab";
    };
  };
  
  processes = {
    "jupyter-lab".exec = ''
      conda-shell -c "
        conda activate sparkenv
        jupyter lab
      "
    '';
  };
  
  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
  '';
}
