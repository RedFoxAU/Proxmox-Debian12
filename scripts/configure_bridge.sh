#!/bin/bash
# Tornando-se root
if [ "$(whoami)" != "root" ]; then
    echo -e "${ciano}Tornando-se superusuário...${normal}"
    sudo -E bash "$0" "$@"  # Executa o script como root
    exit $?
fi

# Carregar as variáveis de cores do arquivo colors.conf
cd /Proxmox-Debian12
source ./configs/colors.conf


# Caminho para o arquivo script_proxmox no diretório /etc/network/interfaces.d/
script_proxmox_file="/etc/network/interfaces.d/script_proxmox"

interface_old() 
{

    # Verificar se o arquivo script_proxmox já existe
    if [ -e "$script_proxmox_file" ]; then
        # Se o arquivo existir, limpe o conteúdo
        echo "" > "$script_proxmox_file"
    else
        # Se o arquivo não existir, crie-o
        touch "$script_proxmox_file"
    fi

    # Criar um novo arquivo interfaces com as informações relevantes
    cat <<EOF > $script_proxmox_file
# Este arquivo de configuração foi gerado automaticamente pelo script de instalação do PROXMOX

# Suas interfaces:


EOF
}

bridge()
{
    # Caminho para o arquivo de configuração
    config_file="configs/network.conf"

    # Verificar se o arquivo de configuração existe
    if [ ! -f "$config_file" ]; then
        echo -e "${amarelo}O arquivo de configuração ${ciano}$config_file${amarelo} não existe. Execute o script ${ciano}install_proxmox-1.sh${amarelo} primeiro ou configure manualmente.${normal}"
        exit 1
    fi

    # Ler as configurações do arquivo
    source "$config_file"

    # Exibindo informações de rede
    echo -e "${ciano}Exibindo interface de network.conf:${normal}"
    echo -e "${ciano}Interface Física:${azul} $INTERFACE"
    echo -e "${ciano}Endereço IP:${azul} $IP_ADDRESS"
    echo -e "${ciano}Gateway:${azul} $GATEWAY ${normal}"


    # Utilizar as variáveis lidas do arquivo ou solicitar novas se estiverem em branco
    echo -e "${azul}Revisando configurações e as informações de interface de rede para criação da bridge...${normal}"
    PS3="Selecione uma opção (Digite o número): "
    options=("Configurar Manualmente" "Usar DHCP" "Sair")

  select opt in "${options[@]}"; do
    case $opt in
        "Configurar Manualmente")
            # Leitura manual das configurações
            read -p "Informe o nome da interface física / netmask (deixe em branco para manter "$INTERFACE"): " interface_fisica
            read -p "Informe o endereço IP para a bridge com net mask (deixe em branco para manter "$IP_ADDRESS"): " endereco_ip
            read -p "Informe o gateway para a bridge (deixe em branco para manter "$GATEWAY"): " gateway

            # Utilizar as variáveis lidas ou as novas informadas
            INTERFACE=${interface_fisica:-$INTERFACE}
            IP_ADDRESS=${endereco_ip:-$IP_ADDRESS}

            # Validar se o gateway é um endereço IP válido
            if [[ -n "$gateway" && ! "$gateway" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                echo -e "${vermelho}Gateway inválido. Saindo...${normal}"
                exit 1
            fi

            GATEWAY=${gateway:-$GATEWAY}

            # Atualizar o arquivo de configuração
            echo "INTERFACE=$INTERFACE" > "$config_file"
            echo "IP_ADDRESS=$IP_ADDRESS" >> "$config_file"
            echo "GATEWAY=$GATEWAY" >> "$config_file"

            # Criar a bridge vmbr0 com as novas informações
            cat <<EOF >> $script_proxmox_file
# Configurações da Interface Física
# auto $INTERFACE
# iface $INTERFACE inet manual

# Configurações da Bridge vmbr0
auto vmbr0
iface vmbr0 inet static
    address $IP_ADDRESS
    gateway $GATEWAY
    bridge_ports $INTERFACE
    bridge_stp off
    bridge_fd 0

EOF

            break 2
            ;;

        "Usar DHCP")
            # Configuração para DHCP

            # Criar a bridge vmbr0 com as novas informações
cat <<EOF >> $script_proxmox_file
# Configurações da Interface Física
# auto $INTERFACE
# iface $INTERFACE inet dhcp

# Configurações da Bridge vmbr0 para DHCP
auto vmbr0
iface vmbr0 inet dhcp
    bridge_ports $INTERFACE
    bridge_stp off
    bridge_fd 0

EOF

            break 2
            ;;

        "Sair")
            echo -e "${vermelho}Saindo...${normal}"
            exit 0
            ;;

        *) echo -e "${amarelo}Opção inválida${normal}";;
    esac
done


    # Reiniciar o serviço de rede para aplicar as alterações
    echo "${amarelo}Reiniciando o serviço de rede...${normal}"
    systemctl restart networking

    echo "${verde}A bridge vmbr0 foi criada com sucesso!${normal}"
    cd /
}

reboot()
{
    echo -e "${verde}Instalação e configuração de rede do Proxmox concluída com sucesso!${normal}"
    echo -e "${amarelo}Lembre-se de configurar o Proxmox conforme necessário!${normal}"
    echo -e "${amarelo}Reiniciando o Sistema...${normal}"
    sleep 5
    systemctl reboot
}

main()
{
    interface_old
    bridge

    echo -e "${ciano}Deseja reiniciar o computador agora? [S/N] (Opcional)${normal}"
    read -p "Resposta " perguntar_reboot

    if ["$perguntar_reboot" == "s"]; then
        reboot
    else
        echo -e "${verde}Instalação e configuração de rede do Proxmox concluída com sucesso!${normal}"
        echo -e "${amarelo}Lembre-se de configurar o Proxmox conforme necessário!${normal}"
        sleep 5
        clear
        # Verificar se o comando neofetch está instalado
        if command -v neofetch &> /dev/null; then
            neofetch
        fi
    fi
}

main
