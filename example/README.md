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
$ time curl -svkw'\n' 0.0.0.0:8080/test1/test2
*   Trying 0.0.0.0:8080...
* Established connection to 0.0.0.0 (0.0.0.0 port 8080) from 127.0.0.1 port 62249
* using HTTP/1.x
> GET /test1/test2 HTTP/1.1
> Host: 0.0.0.0:8080
> User-Agent: curl/8.16.0
> Accept: */*
>
* Request completely sent off
< HTTP/1.1 200 OK
< Date: Sat, 11 Oct 2025 17:47:08 GMT
< Content-Length: 30
< Content-Type: application/json
<
* Connection #0 to host 0.0.0.0:8080 left intact
{"message":"Hello from Test2"}

real    0m0.023s
user    0m0.010s
sys     0m0.008s
```
