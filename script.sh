 #!/bin/bash
public_key=""
##caminho que o script ira jogar os conf dos clientes
caminho_clientes="/etc/wireguard/clientes/"
#privatekey="$caminho_clientes"privatekey.$new_ip
#pubkey="$caminho_clientes"pubkey.$new_ip

### criar o arquivo ips.txt com o ultimo ip criado do cliente pivo
caminho_ips="/<caminho aqui>"
#Ler o arquivo
while IFS= read -r line; do
    # Pegar a primeira linha
    ip="$line"
    break
done < "$caminho_ips"/ips.txt

# Extrair a última parte do IP
last_octet=$(echo "$ip" | awk -F'.' '{print $4}')

# Adicionar um ao último octeto
new_last_octet=$((last_octet + 1))

# Reconstruir o IP com o novo último octeto
new_ip=$(echo "$ip" | awk -F'.' -v new_last_octet="$new_last_octet" '{print $1"."$2"."$3"."new_last_octet}')

# Sobrescrever o arquivo com o novo IP
sed -i "1s/.*/$new_ip/" "$caminho_ips"/ips.txt


privatekey="$caminho_clientes"privatekey.$new_ip
pubkey="$caminho_clientes"pubkey.$new_ip



wg genkey | tee $privatekey | wg pubkey > $pubkey



ler_privatekey=$(cat "$privatekey")


#criar o arquivo $new_ip.conf

conf_file="$caminho_clientes$new_ip".conf

echo "[Interface]" > "$conf_file"
echo "PrivateKey = $ler_privatekey" >> "$conf_file"
echo "Address = $new_ip/32" >> "$conf_file"
echo "DNS = 186.202.26.26, 8.8.8.8" >> "$conf_file"
echo "" >> "$conf_file"
echo "[Peer]" >> "$conf_file"
echo "PublicKey = $public_key" >> "$conf_file"
echo "AllowedIPs = 0.0.0.0/0" >> "$conf_file"
echo "Endpoint = <ipvps>:<porta>" >> "$conf_file"


###parar wireguard

wg-quick down wg0
systemctl stop wg-quick@wg0

##adcionar no arquivo de configuraçao os clientes

ler_pubkey=$(cat "$pubkey")

echo "[Peer]" >> "/etc/wireguard/wg0.conf"
echo "PublicKey =  $ler_pubkey"  >> "/etc/wireguard/wg0.conf"
echo "AllowedIPs = $new_ip/32"  >> "/etc/wireguard/wg0.conf"
echo "" >> "/etc/wireguard/wg0.conf" 
systemctl start wg-quick@wg0 
