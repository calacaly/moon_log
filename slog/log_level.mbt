///|
pub(all) enum Level {
  Debug = 0
  Info = 1
  Warn = 2
  Error = 3
} derive(Eq, Compare)

///|
fn Level::color_prefix(self : Self) -> String {
  match self {
    Level::Debug => "\u001B[94m" // 蓝色
    Level::Info => "\u001B[32m" // 绿色
    Level::Warn => "\u001B[33m" // 黄色
    Level::Error => "\u001B[31m" // 红色
  }
}

///|
fn reset_color() -> String {
  "\u001B[0m"
}

///|
impl Show for Level with to_string(self : Level) -> String {
  match self {
    Level::Debug => "debug"
    Level::Info => "info"
    Level::Warn => "warn"
    Level::Error => "error"
  }
}

///|
impl Show for Level with output(self : Level, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
pub fn Level::from_str(s : String) -> Level {
  let s = s.to_upper()
  match s {
    "DEBUG" => Level::Debug
    "INFO" => Level::Info
    "WARN" => Level::Warn
    "ERROR" => Level::Error
    _ => Level::Info
  }
}
