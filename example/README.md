# OMSFW Example

## Build

```
xmake -y build
```

## Run

```
xmake run
```

## Test

```
$ time curl -svk '127.0.0.1:8080/test1/test2?test3=test4&test5=test6'
*   Trying 127.0.0.1:8080...
* Established connection to 127.0.0.1 (127.0.0.1 port 8080) from 127.0.0.1 port 54554
* using HTTP/1.x
> GET /test1/test2?test3=test4&test5=test6 HTTP/1.1
> Host: 127.0.0.1:8080
> User-Agent: curl/8.16.0
> Accept: */*
>
* Request completely sent off
< HTTP/1.1 200 OK
< Content-Type: application/json
< X-Sample-Header: sample-header-value
< Content-Length: 72
< Date: Wed, 15 Oct 2025 14:23:21 GMT
<
* Connection #0 to host 127.0.0.1:8080 left intact
{"query":{"test5":"test6","test3":"test4"},"message":"Hello from Test2"}
real    0m0.017s
user    0m0.008s
sys     0m0.006s
```
