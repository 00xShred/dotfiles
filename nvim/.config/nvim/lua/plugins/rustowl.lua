-- RustOwl: ownership/lifetime visualization on hover (https://github.com/cordx56/rustowl)
return {
  "cordx56/rustowl",
  version = "*", -- Latest stable version
  build = "cargo install rustowl",
  lazy = false, -- This plugin is already lazy
  opts = { auto_enable = true },
}
