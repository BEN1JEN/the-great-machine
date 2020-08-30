return {
  deadZone = 0.2,
  buttons = {
    left = {
      {type="kb", key="a"},
      {type="kb", key="left"},
      {type="axis", axis=2, direction=-1},
      {type="hat", hat=1, direction="l"},
      {type="touch", shape="circle", x = 50, y = 100, size = 25, symbol = "<", align = "bl"},
    },
    right = {
      {type="kb", key="d"},
      {type="kb", key="right"},
      {type="axis", axis=2, direction=1},
      {type="hat", hat=1, direction="r"},
      {type="touch", shape="circle", x = 150, y = 100, size = 25, symbol = ">", align = "bl"},
    },
    up = {
      {type="kb", key="w"},
      {type="kb", key="up"},
      {type="axis", axis=1, direction=-1},
      {type="hat", hat=1, direction="u"},
      {type="touch", shape="circle", x = 100, y = 150, size = 25, symbol = "^", align = "bl"},
    },
    down = {
      {type="kb", key="s"},
      {type="kb", key="down"},
      {type="axis", axis=1, direction=1},
      {type="hat", hat=1, direction="d"},
      {type="touch", shape="circle", x = 100, y = 50, size = 25, symbol = "v", align = "bl"},
    },
    interact = {
      {type="mouse", side=1},
    }
  },
}
