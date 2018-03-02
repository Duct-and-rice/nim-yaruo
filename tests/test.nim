import unittest, space, unicode
suite "space":
  test "space":
    for i in 1..16:
      echo "'" & width_space(i) & "'"
    echo "'" & repr "\u0029" & "'"
