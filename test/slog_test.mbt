///|
test "slog level" {
  println("test slog level")
  let msg = "Hello, world!"
  println("defualt level is info, so debug level is not printed")
  msg |> @slog.debug |> @slog.print
  msg |> @slog.info |> @slog.print
  msg |> @slog.warn |> @slog.print
  msg |> @slog.error |> @slog.print
  println("------------------------------------------------------")
  @slog.set_level(@slog.Level::Debug)
  println("set level to debug, so all level is printed")
  msg |> @slog.debug |> @slog.print
  msg |> @slog.info |> @slog.print
  msg |> @slog.warn |> @slog.print
  msg |> @slog.error |> @slog.print
  println("------------------------------------------------------")
  @slog.set_level(@slog.Level::Warn)
  println("set level to warn, so only warn and error is printed")
  msg |> @slog.debug |> @slog.print
  msg |> @slog.info |> @slog.print
  msg |> @slog.warn |> @slog.print
  msg |> @slog.error |> @slog.print
  println("------------------------------------------------------")
  @slog.set_level(@slog.Level::Error)
  println("set level to error, so only error is printed")
  msg |> @slog.debug |> @slog.print
  msg |> @slog.info |> @slog.print
  msg |> @slog.warn |> @slog.print
  msg |> @slog.error |> @slog.print
  println("------------------------------------------------------")
  println("")
  @slog.set_level(@slog.Level::Info)
}

///|
test "slog json" {
  println("test slog json")
  let msg : Json = { "message": "hello world", "a": 1, "b": 2.0 }
  msg |> @slog.info |> @slog.jprint
  msg |> @slog.info |> @slog.print
  let msg : Json = {
    "message": "hello world",
    "a": [{ "a": 1, "b": 2.0 }, { "a": 1, "b": 2.0 }],
  }
  msg |> @slog.info |> @slog.jprint
  msg |> @slog.info |> @slog.print
  println("------------------------------------------------------")
  println("")
}

///|
test "link style" {
  println("test link style")
  @slog.simple_logger.info("hello world").print()
  @slog.simple_logger.info("hello world").jprint()
  println("------------------------------------------------------")
  println("")
}

///|
test "log env level" {
  println("test log env level")
  @sys.set_env_var(@slog.LOG_ENV_KEY, "wArn")
  @slog.get_level_from_env() |> @slog.set_level
  let msg = "Hello, world!"
  println("env level is warn, so only warn and error is printed")
  msg |> @slog.debug |> @slog.print
  msg |> @slog.info |> @slog.print
  msg |> @slog.warn |> @slog.print
  msg |> @slog.error |> @slog.print
  println("------------------------------------------------------")
  println("")
  @slog.set_level(@slog.Level::Info)
}

///|
test "color enable" {
  println("test color enable")
  @slog.enable_color(enable=false)
  println("color is disabled")
  "Hello, world!" |> @slog.debug |> @slog.print
  "Hello, world!" |> @slog.info |> @slog.print
  "Hello, world!" |> @slog.warn |> @slog.print
  "Hello, world!" |> @slog.error |> @slog.print
  @slog.enable_color()
  println("color is enabled")
  "Hello, world!" |> @slog.debug |> @slog.print
  "Hello, world!" |> @slog.info |> @slog.print
  "Hello, world!" |> @slog.warn |> @slog.print
  "Hello, world!" |> @slog.error |> @slog.print
  println("------------------------------------------------------")
  println("")
}

///|
test "call time enable" {
  println("test call time enable")
  @slog.enable_call_time(enable=false)
  println("call time is disabled")
  "Hello, world!" |> @slog.info |> @slog.print
  @slog.enable_call_time()
  println("call time is enabled")
  "Hello, world!" |> @slog.info |> @slog.print
  println("------------------------------------------------------")
  println("")
}

///|
test "src loc enable" {
  println("test src loc enable")
  @slog.enable_src_loc(enable=false)
  println("src loc is disabled")
  "Hello, world!" |> @slog.info |> @slog.print
  @slog.enable_src_loc()
  println("src loc is enabled")
  "Hello, world!" |> @slog.info |> @slog.print
  println("------------------------------------------------------")
  println("")
  @slog.enable_src_loc(enable=false)
}

///|
test "args loc enable" {
  println("test args loc enable")
  @slog.enable_args_loc(enable=false)
  println("args loc is disabled")
  "Hello, world!" |> @slog.info |> @slog.print
  @slog.enable_args_loc()
  println("args loc is enabled")
  "Hello, world!" |> @slog.info |> @slog.print
  println("------------------------------------------------------")
  println("")
  @slog.enable_args_loc(enable=false)
}

///|
test "set time zone" {
  println("test set time zone")
  let time_zone = try? @time.fixed_zone("Asia/Shanghai", 8 * 60 * 60)
  @slog.set_time_zone(time_zone.unwrap())
  "Hello, world!" |> @slog.info |> @slog.print
  @slog.set_time_zone(@time.utc_zone)
  "Hello, world!" |> @slog.info |> @slog.print
  println("------------------------------------------------------")
  println("")
  @slog.set_time_zone(time_zone.unwrap())
}

///|
test "src loc and args loc with json" {
  println("test src loc and args loc with json")
  @slog.enable_src_loc()
  @slog.enable_args_loc()
  "Hello, world!" |> @slog.info |> @slog.print
  "Hello, world!" |> @slog.info |> @slog.jprint
  println("------------------------------------------------------")
  println("")
  @slog.enable_src_loc(enable=false)
  @slog.enable_args_loc(enable=false)
}
