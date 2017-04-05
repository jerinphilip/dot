function proxy_on {
    #printf -v no_proxy '%s,' 10.1.{1..255}.{1..255}
    export {http,https,ftp,rsync}_proxy="http://proxy.iiit.ac.in:8080"
    export {HTTP,HTTPS,FTP,RSYNC}_PROXY=$http_proxy
    export no_proxy="localhost,127.0.0.1,.iiit.ac.in,"
}

function proxy_off {
    unset {http,https,ftp,rsync}_proxy
    unset {HTTP,HTTPS,FTP,RSYNC}_PROXY
}
