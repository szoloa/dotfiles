function setproxy
    set -gx http_prox 127.0.0.1:7890

    set -gx https_proxy 127.0.0.1:7890

    set -gx all_proxy 127.0.0.1:7890

    echo 'Set proxy successfully'
end
