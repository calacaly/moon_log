///|
pub const LOG_ENV_KEY = "MOONBIT_LOG"

///|
pub let simple_logger : SimpleLogger = SimpleLogger::default()

///|
/// only level = debug will be logged
pub fn[T : LogData] debug(
  msg : T,
  src_loc~ : SourceLoc = _,
  args_loc~ : ArgsLoc = _
) -> Data[T] {
  if simple_logger.level > Level::Debug {
    return Data::None
  }
  simple_logger.log(msg, level=Some(Level::Debug), src_loc~, args_loc~)
}

///|
/// only level <= info will be logged
pub fn[T : LogData] info(
  msg : T,
  src_loc~ : SourceLoc = _,
  args_loc~ : ArgsLoc = _
) -> Data[T] {
  if simple_logger.level > Level::Info {
    return Data::None
  }
  simple_logger.log(msg, level=Some(Level::Info), src_loc~, args_loc~)
}

///|
/// only level <= warn will be logged
pub fn[T : LogData] warn(
  msg : T,
  src_loc~ : SourceLoc = _,
  args_loc~ : ArgsLoc = _
) -> Data[T] {
  if simple_logger.level > Level::Warn {
    return Data::None
  }
  simple_logger.log(msg, level=Some(Level::Warn), src_loc~, args_loc~)
}

///|
/// only level <= error will be logged
pub fn[T : LogData] error(
  msg : T,
  src_loc~ : SourceLoc = _,
  args_loc~ : ArgsLoc = _
) -> Data[T] {
  if simple_logger.level > Level::Error {
    return Data::None
  }
  simple_logger.log(msg, level=Some(Level::Error), src_loc~, args_loc~)
}

///|
pub fn set_level(level : Level) -> Unit {
  simple_logger.level = level
}

///|
pub fn set_time_format(format : String) -> Unit {
  simple_logger.caller.time_format = format
}

///|
pub fn set_time_zone(tz : @time.Zone) -> Unit {
  simple_logger.caller.time_zone = tz
}

///|
pub fn enable_color(enable~ : Bool = true) -> Unit {
  simple_logger.color = enable
}

///|
pub fn enable_src_loc(enable~ : Bool = true) -> Unit {
  simple_logger.caller.src_loc = enable
}

///|
pub fn enable_args_loc(enable~ : Bool = true) -> Unit {
  simple_logger.caller.args_loc = enable
}

///|

///|
pub fn enable_call_time(enable~ : Bool = true) -> Unit {
  simple_logger.caller.call_time = enable
}

///|
pub fn get_level_from_env() -> Level {
  let level = @sys.get_env_vars()
    .iter()
    .filter(x => x.0 == LOG_ENV_KEY)
    .collect()
    .pop()
  if level is Some(lv) {
    return Level::from_str(lv.1)
  } else {
    return Level::Info
  }
}

///|
pub fn set_caller(caller : Caller) -> Unit {
  simple_logger.caller = caller
}
