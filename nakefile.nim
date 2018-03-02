import nake

const
  ExeName = "src/nim_yaruo"

task "build", "Build":
  shell(nimExe, "c", ExeName)
