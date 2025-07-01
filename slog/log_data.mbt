///|
struct Meta {
  mut timestamp : String?
  mut level : Level
  color : Bool
  mut src_loc : String?
  mut args_loc : String?
}

///|
pub fn Meta::to_map(self : Meta) -> Map[String, Json] {
  let m : Map[String, Json] = Map::new()
  if self.timestamp is Some(timestamp) {
    m.set("timestamp", timestamp.to_json())
  }
  m.set("level", self.level.to_string().to_json())
  if self.src_loc is Some(src_loc) {
    m.set("src_loc", src_loc.to_json())
  }
  if self.args_loc is Some(args_loc) {
    m.set("args_loc", args_loc.to_json())
  }
  m
}

///|
impl Show for Meta with output(self : Meta, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
impl Show for Meta with to_string(self : Meta) -> String {
  let builder = StringBuilder::new()
  if self.timestamp is Some(timestamp) {
    builder.write_char('[')
    builder.write_string(timestamp)
    builder.write_char(']')
    builder.write_char(' ')
  }
  if self.color {
    builder.write_string(self.level.color_prefix())
  }
  builder.write_char('[')
  builder.write_string(self.level.to_string())
  builder.write_char(']')
  if self.color {
    builder.write_string(reset_color())
  }
  builder.write_char(' ')
  if self.src_loc is Some(src_loc) {
    builder.write_string("src=")
    builder.write_string(src_loc)
    builder.write_char(' ')
  }
  if self.args_loc is Some(args_loc) {
    builder.write_string("args=")
    builder.write_string(args_loc)
    builder.write_char(' ')
  }
  builder.to_string()
}

///|
impl ToJson for Meta with to_json(self : Meta) -> Json {
  self.to_map().to_json()
}

///|
pub trait LogData {
  to_json(Self) -> Json
  dump(Self) -> String
}

///|
pub impl LogData for Json with dump(self : Json) -> String {
  self |> json_dump
}

///|
pub impl LogData for Json with to_json(self : Json) -> Json {
  self
}

///|
pub impl LogData for String with dump(self : String) -> String {
  self
}

///|
pub impl LogData for String with to_json(self : String) -> Json {
  self.to_json()
}

///|
pub(all) enum Data[T] {
  None
  Some(Meta, T)
}

///|
pub impl[T : LogData] LogData for Data[T] with dump(self : Data[T]) -> String {
  match self {
    Data::None => "None".to_string()
    Data::Some(meta, msg) => {
      let builder = StringBuilder::new()
      builder.write_string(meta.to_string())
      builder.write_char(' ')
      builder.write_string(msg.dump())
      builder.to_string()
    }
  }
}

///|
pub impl[T : LogData] LogData for Data[T] with to_json(self : Data[T]) -> Json {
  match self {
    Data::None => {}
    Data::Some(meta, msg) => {
      let m = meta.to_map()
      m.set("msg", msg.to_json())
      m.to_json()
    }
  }
}
