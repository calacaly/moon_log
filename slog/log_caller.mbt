///|
///

///|
struct Caller {
  mut src_loc : Bool
  mut args_loc : Bool
  mut call_time : Bool
  mut time_zone : @time.Zone
  mut time_format : String
}

///|
pub impl Default for Caller with default() -> Caller {
  let mut default_zone : @time.Zone = @time.utc_zone
  let time_zone = try? @time.fixed_zone("Asia/Shanghai", 8 * 60 * 60)
  if time_zone is Ok(tz) {
    default_zone = tz
  }
  {
    src_loc: false,
    args_loc: false,
    call_time: true,
    time_zone: default_zone,
    time_format: "%Y-%m-%d %H:%M:%S",
  }
}

///|
pub fn Caller::with_time_zone(self : Self, zone : String) -> Self {
  try {
    self.time_zone = @time.fixed_zone(zone, 8 * 60 * 60)
  } catch {
    _ => self.time_zone = @time.utc_zone
  }
  self
}

///|
pub fn Caller::with_time_format(self : Self, format : String) -> Self {
  self.time_format = format
  self
}

///|
fn Caller::time_string(self : Self) -> String? {
  guard self.call_time else { return None }
  let current = @env.now() / 1000
  let date_time = try? @time.unix(
      current.reinterpret_as_int64(),
      zone=self.time_zone,
    )
  match date_time {
    Ok(d) => Some(datetime_format(d, self.time_format))
    Err(_) => Some("invalid unix second: \{current}}")
  }
}

///|
fn datetime_format(t : @time.ZonedDateTime, f : String) -> String {
  let it = f.iter()
  let mut in_escape = false
  let builder = StringBuilder::new()
  for c in it {
    if in_escape {
      match c {
        'Y' => builder.write_string(t.year().to_string())
        'm' => write_withpad2(builder, t.month())
        'd' => write_withpad2(builder, t.day())
        'H' => write_withpad2(builder, t.hour())
        'M' => write_withpad2(builder, t.minute())
        'S' => write_withpad2(builder, t.second())
        '%' => builder.write_char('%')
        _ => {
          in_escape = false
          builder.write_char(c)
        }
      }
    } else if c == '%' {
      in_escape = true
    } else {
      builder.write_char(c)
    }
  }
  builder.to_string()
}

///|
fn write_withpad2(b : StringBuilder, n : Int) -> Unit {
  if n < 10 {
    b.write_char('0')
    b.write_string(n.to_string())
  } else {
    b.write_string(n.to_string())
  }
}
