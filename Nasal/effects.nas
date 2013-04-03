# ATR 72-500
# Nasal effects
###############

## Livery select
aircraft.livery.init("Aircraft/ATR-72-500/Models/Liveries");

## Switch sounds
var switch_sound =
 {
 sounds: [],
 new: func(sound_prop, time)
  {
  var m =
   {
   node: props.globals.initNode(sound_prop, 0, "BOOL"),
   time: time
   };
  append(switch_sound.sounds, m);
  var id = size(switch_sound.sounds) - 1;
  for (var i = 0; i < size(arg); i += 1)
   {
   setlistener(arg[i], func
    {
    switch_sound.sound(id);
    }, 0, 0);
   }
  },
 sound: func(id)
  {
  var sound = switch_sound.sounds[id];
  if (sound.node.getBoolValue())
   {
   return;
   }
  sound.node.setBoolValue(1);
  settimer(func
   {
   sound.node.setBoolValue(0);
   }, sound.time);
  }
 };
switch_sound.new("sim/sound/passenger-sign", 2,
 "controls/switches/no-smoking-sign",
 "controls/switches/seatbelt-sign"
 );
switch_sound.new("sim/sound/click", 0.5,
 "controls/lighting/beacon",
 "controls/lighting/nav-lights",
 "controls/lighting/landing-lights[0]",
 "controls/lighting/landing-lights[1]",
 "controls/lighting/strobe",
 "controls/lighting/taxi-lights",
 "controls/lighting/logo-lights",
 "controls/lighting/wing-lights",
 "controls/lighting/cabin-lights",
 "controls/lighting/cockpit-lights",
 "controls/engines/start-switch",
 "controls/engines/propeller-brake",
 "controls/engines/engine[0]/starter[0]",
 "controls/engines/engine[1]/starter[1]",
 "controls/electric/battery-switch",
 "controls/electric/external-power",
 "controls/electric/engine[0]/generator",
 "controls/electric/engine[1]/generator",
 "controls/hydraulic/system[0]/electric-pump[0]",
 "controls/hydraulic/system[0]/electric-pump[1]",
 "controls/hydraulic/system[1]/electric-pump",
 "controls/hydraulic/x-feed",
 "controls/anti-ice/engine[0]/inlet-heat",
 "controls/anti-ice/engine[1]/inlet-heat",
 "controls/anti-ice/window-heat",
 "consumables/fuel/tank[0]/selected",
 "consumables/fuel/tank[1]/selected",
 "controls/fuel/x-feed"
 );

## Lights
var beacon_switch = props.globals.getNode("controls/switches/beacon", 2);
var beacon = aircraft.light.new("sim/model/lights/beacon", [0.015, 3], "controls/lighting/beacon");

var strobe_switch = props.globals.getNode("controls/switches/strobe", 2);
var strobe = aircraft.light.new("sim/model/lights/strobe", [0.025, 1.5], "controls/lighting/strobe");

## Tire smoke/rain
var tiresmoke_system = aircraft.tyresmoke_system.new(0, 1, 2);
aircraft.rain.init();
