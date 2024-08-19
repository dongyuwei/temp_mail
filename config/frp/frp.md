## frp_0.60.0
- server: frp_0.60.0_linux_amd64, `./frps -c frps.toml`
- client: frp_0.60.0_darwin_amd64, `./frpc -c frpc.toml`
- domain in config/config.exs shoule be updated to the **same** domain in customDomains frpc.toml, set both to `tmpmail.work`.
- visist http://tmpmail.work:8080/ to verify the tmp mail serice.