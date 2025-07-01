# Simple Logger Use

让人不懵逼的简单日志库

## add dep

```bash
moon add calacaly/clog/slog
```

## example code

> pipe style

```moon
"hello world" |> @slog.info |> @slog.print 

{"test": "test"} |> @slog.info |> @slog.print

```

> link style

```moon
let logger = @slog.simple_logger
logger.info("hello world").print()
logger.info({"test": "test"}).jprint()
```
