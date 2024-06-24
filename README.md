# wireguard-vps
Uma soluçao para ter uma VPS com wireguard server com linux, e conectar os clientes de forma segura, dentro do túnel.
A VPS se faz necessária caso nao tenha um IP PUBLICO, geralmente estamos atras de um GCNAT.
O wireguard é rápido e poucas linhas para fazer a configuração.


Então os clientes se conectam na VPS com wireguard server, e um cliente funciona como pivô possibilitando a ligação entre os clientes.

## Instalação wireguard server
Dependendo da sua versão de SO
### Debian
``` 
apt install wireguard
 ```

### Fedora 
apt install wireguard-tools

* criar o arquivo wg0.conf em /etc/wireguard/

### START
* comando para levantar o serviço para teste wg-quick up wg0
### STOP

* comando para parar o serviço wg-quick down wg0
### Private Key 
wg genkey
* comando parar criar a chave publica wg pubkey



