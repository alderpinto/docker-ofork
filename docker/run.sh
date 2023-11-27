#!/bin/bash

function prepare_ofork () {
    echo "Preparing ofork..."
    cp -rfp /app-files/ofork/* ${OTRS_ROOT}
    su -c "${OTRS_ROOT}bin/ofork.Console.pl Maint::Config::Rebuild" -s /bin/bash ofork
    su -c "${OTRS_ROOT}bin/ofork.Console.pl Maint::Cache::Delete" -s /bin/bash ofork
    ${OTRS_ROOT}bin/ofork.SetPermissions.pl --ofork-user=ofork --web-group=nginx ${OTRS_ROOT}
    rm -fr /app-files/ofork   
}

VOLUME_DIR=${OTRS_ROOT:-/opt/ofork/}

# Verificar se o diretório do volume existe
if [ -d "$VOLUME_DIR" ]; then
    # Verificar se existem arquivos ou diretórios dentro do diretório do volume
    if [ "$(ls -A $VOLUME_DIR)" ]; then
        echo "O ambiente já foi configurado anteriormente."
    else
        echo "O ambiente ainda não foi configurado."
        # Coloque aqui o código para executar a configuração inicial do ambiente
        prepare_ofork     
    fi
else
    echo "O volume ainda não foi criado."
    # Coloque aqui o código para criar o volume e executar a configuração inicial do ambiente
    mkdir -p ${OTRS_ROOT}
    prepare_ofork  
fi

/usr/bin/supervisord -c /etc/supervisord.conf&

trap 'kill ${!}; term_handler' SIGTERM

# wait forever
while true
do
 tail -f /dev/null & wait ${!}
done