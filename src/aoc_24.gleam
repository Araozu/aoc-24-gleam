import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/string
import simplifile

pub fn main() {
  io.println("Advent of Code 2024 in Gleam :D\n")
  let is_test = False

  let answer1_1 = day1_part1(is_test)
  io.println("Day 01 part 1:\t" <> answer1_1)
}

pub fn day1_part1(is_test: Bool) -> String {
  let input_path =
    "./inputs/01."
    <> {
      case is_test {
        True -> "test"
        False -> "txt"
      }
    }

  let assert Ok(input) = simplifile.read(from: input_path)
  let lines = string.split(input, "\n") |> list.filter(fn(x) { x != "" })

  let #(left_list, right_list) = list.map(lines, line_to_int) |> list.unzip
  let #(left_list, right_list) = #(
    list.sort(left_list, by: int.compare),
    list.sort(right_list, by: int.compare),
  )

  let differences =
    list.zip(left_list, right_list)
    |> list.fold(0, fn(acc, next) { acc + int.absolute_value(next.0 - next.1) })

  int.to_string(differences)
}

fn line_to_int(line: String) -> #(Int, Int) {
  let assert Ok(re) = regexp.from_string("(\\d+)\\s+(\\d+)")
  let match = regexp.scan(with: re, content: line)
  let first_m = case match {
    [match] -> match
    _ -> {
      io.debug("ehhh??? " <> line)
      panic as ":c"
    }
  }

  case first_m.submatches {
    [option.Some(match_1), option.Some(match_2)] -> {
      let assert Ok(v1) = int.parse(match_1)
      let assert Ok(v2) = int.parse(match_2)
      #(v1, v2)
    }
    _ -> {
      panic as "found number other than 2 matches"
    }
  }
}
