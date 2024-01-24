# Proxmox-Debian12
```bash                                                      _               
  _ __  _ __ _____  ___ __ ___   _____  __    ___  ___| |_ _   _ _ __  
 | '_ \| '__/ _ \ \/ / '_ ` _ \ / _ \ \/ /   / __|/ _ \ __| | | | '_ \ 
 | |_) | | | (_) >  <| | | | | | (_) >  <    \__ \  __/ |_| |_| | |_) |
 | .__/|_|  \___/_/\_\_| |_| |_|\___/_/\_\___|___/\___|\__|\__,_| .__/ 
 |_|                                    |_____|                 |_|    
```

Este script automatiza a instalação do Proxmox sobre o Debian 12 e a criação da bridge para facilitar a configuração de redes.

**Nota: Este script foi projetado para ser executado em um sistema Debian 12. Certifique-se de ter permissões de superusuário antes de executar o script.**

## Requisitos

- Debian 12 instalado
- Git instalado
- Permissões de superusuário

## Instruções de Uso

1. Baixe o script para o seu sistema Debian 12.
```bash
cd /
git clone https://github.com/mathewalves/Proxmox-Debian12.git
cd /Proxmox-Debian12
chmod +x ./setup.bash
./setup.bash
```
2. Torne o script executável.
```bash
chmod +x ./setup.bash
```

3. Execute o script.
```bash
./setup.bash
```

## Pacotes Adicionais

O script instala alguns pacotes adicionais para melhorar a experiência e fornecer funcionalidades adicionais. Os pacotes incluem:

1. **'sudo':** Ferramenta essencial para conceder permissões administrativas ao usuário selecionado.
2. **'nala':** Uma aplicação que melhora a interface gráfica do 'apt'.
3. **'neofetch':** Uma ferramenta de exibição de informações do sistema com uma interface colorida e amigável.
4. **'net-tools':** Conjunto de utilitários clássicos de rede, como ifconfig e route.
5. **'nmap':** Uma poderosa ferramenta de exploração de rede e auditoria de segurança.

Certifique-se de revisar a documentação oficial de cada pacote para obter mais detalhes sobre suas funcionalidades.

## Funcionalidades

1. **Instalação do Proxmox:** O script instala automaticamente o Proxmox sobre a base do Debian 12.

2. **Pacotes Adicionais:** Esses pacotes adicionais são instalados para melhorar a experiência do usuário e fornecer ferramentas úteis para o sistema e para o ambiente Proxmox.

3. **Criação de Bridge:** Facilita a configuração de redes criando uma bridge chamada `vmbr0`. Você pode optar por configurar manualmente ou usar DHCP.

## Atualizações e Suporte

Para obter suporte ou relatar problemas, [abra uma issue](https://github.com/seu-usuario/proxmox-debian12/issues).

## Licença

Este script é distribuído sob a licença [BSD 3-Clause](https://opensource.org/licenses/BSD-3-Clause).

## Agradecimentos

Agradecemos por usar o script Proxmox-Debian12. Se você encontrar melhorias ou quiser contribuir, sinta-se à vontade para criar um pull request.

**Divirta-se com o Proxmox!** 🚀