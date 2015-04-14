# ATR 72-500
# Nasal doors system
####################

var doors =
 {
 new: func(name, transit_time)
  {
  doors[name] = aircraft.door.new("sim/model/door-positions/" ~ name, transit_time);
  },
 toggle: func(name)
  {
  doors[name].toggle();
  }
 };
doors.new("pax-left", 2);
doors.new("pax-right", 2);
doors.new("cargo", 2.5);
doors.new("pilot-armrests", 1);
doors.new("copilot-armrests", 1);
doors.new("cockpit", 1);
doors.new("overhead-bins", 1);
