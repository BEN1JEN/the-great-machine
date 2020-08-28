return {
  deadZone = 0.2,
  buttons = {
    left = {
      {type="kb", key="a"},
      {type="kb", key="left"},
      {type="axis", axis=2, direction=-1},
      {type="hat", hat=1, direction="l"},
      {type="touch", shape="square", x = 50, y = 50, size = 30, symbol = "<", align = "bl"},
    },
    right = {
      {type="kb", key="d"},
      {type="kb", key="right"},
      {type="axis", axis=2, direction=1},
      {type="hat", hat=1, direction="r"},
      {type="touch", shape="square", x = 125, y = 50, size = 30, symbol = ">", align = "bl"},
    },
    jump = {
      {type="kb", key="space"},
      {type="joybutton", id=1},
      {type="touch", shape="circle", x = 50, y = 50, size = 40, symbol = "^", align = "br"},
    },
    sprint = {
    	{type="kb", key="lshift"},
    	{type="joybutton", id=3},
    	{type="touch", shape="circle", x = 150, y = 50, size = 40, symbol = ">>", align = "br"},
    },
    debug = {
      {type="kb", key="escape"},
      {type="touch", shape="square", x = 50, y = 50, size = 40, symbol = "d!", align = "tl"},
    },
  },
}
