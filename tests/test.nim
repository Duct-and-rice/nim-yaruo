import unittest, space, unicode, parsecsv,
  widthtable, tables, ruler, times, strutils, memo

suite "time":
  test "ruler":
    const s = "以呂波耳本へ止".repeat 100
    let t = cpuTime()
    for i in 1..100:
      discard s.get_width
    echo "Ruler Time Taken:", cpuTime() - t

  test "space":
    let t = cpuTime()
    for i in 1..100:
      discard i.width_space
    echo "Space Time Taken:", cpuTime() - t

suite "space":
  test "zen space":
    check width_space(11) == "　"
  test "all space":
    for i in 1..100:
      check i.width_space.get_width == i

suite "ruler":
  test "widthtable":
    check widthtable["!".runeAt(0)] == 4

