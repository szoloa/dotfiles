if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Created by `pipx` on 2025-02-12 07:37:08
set PATH $PATH /home/kina/.local/bin
set PATH $PATH /home/kina/.cargo/bin

set -gx EDITOR nvim
set -gx DOUBAO_API_KEY "e60fb257-eb45-4d36-8d76-1c5da3443e0d"
set -gx ALIYUNPAN_CONFIG_DIR ~/.config/aliyunpan/config
alias del='trash-put'
alias wificonfirm='xdg-open "http://10.170.1.2:9090/zportal/loginForWeb?wlanuserip=73a174e4d76793d61c40b7d44b403ad1&wlanacname=8401d4e42969489875a0b6149e63678c&ssid=c24e36c874328833576d4435928a84c5&nasip=aa97548fee0077ad407c5fe8d3a7645b&snmpagentip=&mac=323bf9c42c9a0f28a9dd27212275c9cb&t=wireless-v2&url=439c39a27e1e80a683c49610f4852988724bb2f3fed26872&apmac=&nasid=8401d4e42969489875a0b6149e63678c&vid=067d9314ddd6af1c&port=3873fb6f4ec794f4&nasportid=573f8a05533c73ec2bead5beb127574079478a22766fad6d3b769e6e9ec8cfb50cab3af38b8e773f"'
zoxide init fish | source

set D_MENU rofi -dmenu
