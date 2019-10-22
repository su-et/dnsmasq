# Generic dnsmasq on Alpine image

Sometimes we need to quickly override DNS entries for testing purposes. [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) provides an easy way to override a few DNS records, while still (recursively) resolving any other records.

This container is just [Alpine Linux](https://alpinelinux.org) with `dnsmasq` installed.

## Building the Image

```
docker build -t dnsmasq:alpine .
```


## Running

You can either mount a hosts file:

```
% docker run -v hosts:/etc/hosts.dnsmasq dnsmasq:alpine
```

or, if you only need a single record, you can pass a host record on
the command line:

```
% docker run dnsmasq:alpine --host-record=www.example.org,example.org,127.0.0.1,60
```

The _--host-record_ syntax is _hostname_,_ipv4_,_ipv6_,_ttl_. Multiple hostnames can be specified (separated by commas); _ipv4_, _ipv6_, and _ttl_ are all optional, although if no address is specified, the "real" record will be used (if it exists). If either, or both, addresses are specified without _ttl_, a TTL of 0 will be returned.

## Examples:

Without any overrides

```
% dig +noall +answer @172.17.0.3 example.org
example.org.		4479	IN	A	93.184.216.34

% dig +noall +answer @172.17.0.3 example.org aaaa
example.org.		4481	IN	AAAA	2606:2800:220:1:248:1893:25c8:1946
```

### Replace the IPv6 address and TTL

Replace only the IPv6 address of example.org

```
docker run dnsmasq:alpine --host-record=example.org,::1,60
```

```
% dig +noall +answer @172.17.0.3 example.org
example.org.		4502	IN	A	93.184.216.34
% dig +noall +answer @172.17.0.3 example.org aaaa
example.org.		60	IN	AAAA	::1
```

### Replace the IPv4 address and TTL

Replace only the IPv4 address of example.org

```
docker run dnsmasq:alpine --host-record=example.org,127.0.0.1,60
```

```
% dig +noall +answer @172.17.0.3 example.org
example.org.		60	IN	A	127.0.0.1
% dig +noall +answer @172.17.0.3 example.org aaaa
example.org.		4502	IN	AAAA	2606:2800:220:1:248:1893:25c8:1946
```

### Replace both addresses and TTL

```
docker run dnsmasq:alpine --host-record=example.org,127.0.0.1,::1,60
```

```
% dig +noall +answer @172.17.0.3 example.org
example.org.		60	IN	A	127.0.0.1
% dig +noall +answer @172.17.0.3 example.org aaaa
example.org.		60	IN	AAAA	::1
```

