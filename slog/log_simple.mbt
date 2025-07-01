///|
pub struct SimpleLogger {
  mut level : Level
  mut color : Bool
  mut caller : Caller
}

///|
pub impl Default for SimpleLogger with default() -> SimpleLogger {
  { level: get_level_from_env(), color: true, caller: Caller::default() }
}

///|
pub fn SimpleLogger::with_caller(self : Self, caller : Caller) -> Self {
  { ..self, caller, }
}

///|
fn[T : LogData] SimpleLogger::log(
  self : Self,
  msg : T,
  src_loc~ : SourceLoc = _,
  args_loc~ : ArgsLoc = _,
  level~ : Level?
) -> Data[T] {
  let meta = Meta::{
    timestamp: None,
    level: Level::Info,
    color: self.color,
    src_loc: None,
    args_loc: None,
  }
  if level is Some(lv) {
    meta.level = lv
  }
  if self.caller.call_time {
    meta.timestamp = self.caller.time_string()
  }
  if self.caller.src_loc {
    meta.src_loc = Some(src_loc.to_string())
  }
  if self.caller.args_loc {
    meta.args_loc = Some(args_loc.to_string())
  }
  Data::Some(meta, msg)
}

///|
/// only log level = debug will be logged
pub fn[T : LogData] SimpleLogger::debug(
  self : Self,
  msg : T,
  src_loc~ : SourceLoc = _,
  args_loc~ : ArgsLoc = _
) -> Data[T] {
  if self.level > Level::Debug {
    return None
  }
  self.log(msg, level=Some(Level::Debug), src_loc~, args_loc~)
}

///|
/// only log level <= info will be logged
pub fn[T : LogData] SimpleLogger::info(
  self : Self,
  msg : T,
  src_loc~ : SourceLoc = _,
  args_loc~ : ArgsLoc = _
) -> Data[T] {
  if self.level > Level::Info {
    return None
  }
  self.log(msg, level=Some(Level::Info), src_loc~, args_loc~)
}

///|
/// only log level <= warn will be logged
pub fn[T : LogData] SimpleLogger::warn(
  self : Self,
  msg : T,
  src_loc~ : SourceLoc = _,
  args_loc~ : ArgsLoc = _
) -> Data[T] {
  if self.level > Level::Warn {
    return None
  }
  self.log(msg, level=Some(Level::Warn), src_loc~, args_loc~)
}

///|
/// only log level <= error will be logged
pub fn[T : LogData] SimpleLogger::error(
  self : Self,
  msg : T,
  src_loc~ : SourceLoc = _,
  args_loc~ : ArgsLoc = _
) -> Data[T] {
  if self.level > Level::Error {
    return None
  }
  self.log(msg, level=Some(Level::Error), src_loc~, args_loc~)
}

///|
pub fn SimpleLogger::enable_args_loc(
  self : Self,
  enable~ : Bool = true
) -> Self {
  self.caller.args_loc = enable
  self
}

///|
pub fn SimpleLogger::enable_src_loc(self : Self, enable~ : Bool = true) -> Self {
  self.caller.src_loc = enable
  self
}

///|
pub fn SimpleLogger::enable_color(self : Self, enable~ : Bool = true) -> Self {
  self.color = enable
  self
}

///|
pub fn SimpleLogger::enable_call_time(
  self : Self,
  enable~ : Bool = true
) -> Self {
  self.caller.call_time = enable
  self
}

///|
pub fn SimpleLogger::set_level(self : Self, level : Level) -> Self {
  self.level = level
  self
}

///|
pub fn SimpleLogger::set_time_format(self : Self, format : String) -> Self {
  self.caller.time_format = format
  self
}

///|
pub fn SimpleLogger::set_time_zone(self : Self, time_zone : @time.Zone) -> Self {
  self.caller.time_zone = time_zone
  self
}
