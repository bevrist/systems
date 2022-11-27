# CoreDNS

Guide: https://dev.to/tunacado/running-coredns-as-a-dns-server-in-a-container-1d0

Run Container:
`docker run -d --net b-server --name coredns --restart always -v $(pwd):/root -p 53:53/udp coredns/coredns -conf /root/Corefile`
