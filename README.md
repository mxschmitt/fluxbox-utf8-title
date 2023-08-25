## Repro steps:

1. Run the Docker container

```
docker build -t emoji_window . -f Dockerfile
docker run --rm -p 8080:8080 emoji_window
```

1. Open http://localhost:7900/vnc.html

1. Run the `/emoji_window` binary

Expected: UTF8-Title works
Actual: UTF8-Title is broken