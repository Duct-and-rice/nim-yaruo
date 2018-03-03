import unicode, strutils, memo
type 
  SpacesSet = tuple[a: int, h: int, adj: int]

const spaces: array[10,tuple[width: int, c: string, isUnicode: bool]] = [
    ( width: 1, c: "\u200a", isUnicode: true ), # 0
    ( width: 2, c: "\u2009", isUnicode: true ), # 1
    ( width: 3, c: "\u2006", isUnicode: true ), # 2
    ( width: 4, c: "\u2005",  isUnicode: true ), # 3
    ( width: 5, c: "\u2004",  isUnicode: true ), # 4
    ( width: 5, c: "\u0020",  isUnicode: false ), # 5
    ( width: 8, c: "\u2002",  isUnicode: true ), # 6
    ( width: 10, c: "\u2007",  isUnicode: true ), # 7
    ( width: 11, c: "\u3000",  isUnicode: false ),# 8
    ( width: 16, c: "\u2003",  isUnicode: true ) # 9
]

const half_space = ' '
const empty_space = (width: -1, c: "\u0000", isUnicode: false)
const dots_to_space = [
  empty_space,
  spaces[0],
  spaces[1],
  spaces[2],
  spaces[3],
  spaces[5],
  empty_space,
  empty_space,
  spaces[6],
  empty_space,
  spaces[7],
  spaces[8],
  empty_space,
  empty_space,
  empty_space,
  empty_space,
  spaces[9]
]

proc generate_space_from_a_h (a: int, h: int): string =
  if a == 0 and h == 1:
    return "" & half_space
  elif a >= h and a >= 0 and h >= 0:
    return dots_to_space[11].c.repeat(a - h) &
      (dots_to_space[11].c & half_space).repeat(h)

proc adjust_with_unicode (adj: int): string =
  if adj == 0:
    return ""
  elif adj > 5:
    return dots_to_space[adj-5].c & half_space
  else:
    return dots_to_space[adj].c & ""

proc one_dot_reduce(ah:SpacesSet): SpacesSet =
  var res = ah
  if res.a - 1 >= res.h + 2:
    res.a -= 1
    res.h += 2
  elif res.adj >= 1:
    res.adj -= 1
  elif res.h >= 1:
    res.h -= 1
    res.adj += 4
  elif res.a >= 1 and res.adj < 6:
    res.a -= 1
    res.h += 1
    res.adj += 5

  if res.h >= 1 and res.adj <= 6:
    res.h -= 1
    res.adj += 5

  return res

proc adj_to_a_h (ah:SpacesSet): SpacesSet =
  var res = ah
  if res.adj == 5:
    res.h += 1
    res.adj = 0

  let gap = 11 - res.adj
  if res.a + 1 - gap >= res.h + 2 * gap:
    res.a += 1
    res.a -= gap
    res.h += 2 * gap
    res.adj = 0
  return res

proc width_space (sp: int): string {.memoized.} =
  let modded = sp mod 11
  var ah:SpacesSet
  ah.a = 0
  ah.h = 0
  ah.adj = 0
  case modded
    of 0:
      ah.a = sp div 11
    of 1..4:
      ah.a = sp div 11
      ah.h = 1
    of 5:
      if sp == 5:
        return dots_to_space[5].c & ""
      ah.a = sp div 11
      ah.h = 1
    of 6..10:
      ah.a = (sp div 11) + 1
    else: discard

  if modded != 0 and modded != 5:
    while ah.a * 11 + ah.h * 5 + ah.adj != sp:
      ah = ah.one_dot_reduce()

    ah = ah.adj_to_a_h

  return generate_space_from_a_h(ah.a, ah.h) & adjust_with_unicode(ah.adj)

export width_space
