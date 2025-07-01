///|
pub fn[T : LogData] print(d : Data[T]) -> Unit {
  guard d is Data::Some(_) else { return }
  d.dump() |> println
}

///|
pub fn[T : LogData] Data::print(self : Self[T]) -> Unit {
  print(self)
}

///|
pub fn[T : LogData] jprint(d : Data[T]) -> Unit {
  guard d is Data::Some(_) else { return }
  d.to_json() |> json_dump |> println
}

///|
pub fn[T : LogData] Data::jprint(self : Self[T]) -> Unit {
  jprint(self)
}

///|
pub fn json_dump(json : Json) -> String {
  let builder = StringBuilder::new()
  match json {
    Array(a) => {
      let mut index = 0
      builder.write_char('[')
      for item in a {
        index += 1
        builder.write_string(json_dump(item))
        if index < a.length() {
          builder.write_string(", ")
        }
      }
      builder.write_char(']')
    }
    String(s) => {
      builder.write_char('"')
      builder.write_string(s)
      builder.write_char('"')
    }
    Number(n) => builder.write_string(n.to_string())
    False => builder.write_string("false")
    True => builder.write_string("true")
    Null => builder.write_string("null")
    Object(m) => {
      builder.write_char('{')
      let mut index = 0
      for k, v in m {
        index += 1
        builder.write_char('"')
        builder.write_string(k)
        builder.write_char('"')
        builder.write_string(": ")
        builder.write_string(json_dump(v))
        if index != m.size() {
          builder.write_string(", ")
        }
      }
      builder.write_char('}')
    }
  }
  builder.to_string()
}
