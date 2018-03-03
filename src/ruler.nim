import unicode, widthtable, tables, memo

proc get_width(s: string): int {.memoized.} =
  result = 0
  for r in s.toRunes:
    let c = widthtable[r]
    result += c
     
export get_width
