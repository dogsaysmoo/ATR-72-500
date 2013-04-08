# ATR 72-500
# Nasal autopilot functions
###########################

var lateral_prop = props.globals.getNode("autopilot/settings/lateral", 1);
var vertical_prop = props.globals.getNode("autopilot/settings/vertical", 1);

var engage = func
 {
 var engaged = props.globals.getNode("autopilot/settings/engaged");
 if (engaged.getBoolValue())
  {
  engaged.setBoolValue(0);
  }
 else
  {
  engaged.setBoolValue(1);

  var pitch = getprop("instrumentation/attitude-indicator[0]/indicated-pitch-deg");
  setprop("autopilot/settings/target-pitch-deg", int(pitch + math.sgn(pitch) * 0.5));
  }
 };
var set_lateral = func(setting)
 {
 if (lateral_prop.getValue() == setting)
  {
  lateral_prop.setValue("");
  }
 else
  {
  lateral_prop.setValue(setting);
  }
 if (lateral_prop.getValue() != "gs1-hold" and vertical_prop.getValue() == "gs1-hold")
  {
  vertical_prop.setValue("");
  }
 };
var set_vertical = func(setting)
 {
 if (vertical_prop.getValue() == setting)
  {
  vertical_prop.setValue("");
  }
 else
  {
  vertical_prop.setValue(setting);
  }
 if (vertical_prop.getValue() != "gs1-hold" and lateral_prop.getValue() == "gs1-hold")
  {
  lateral_prop.setValue("");
  }
 };
var pitch_wheel_up = func
 {
 var setting = vertical_prop.getValue();
 if (setting == "")
  {
  var pitch_setting = getprop("autopilot/settings/target-pitch-deg") + 1;
  if (pitch_setting >= 20)
   {
   pitch_setting = 20;
   }
  setprop("autopilot/settings/target-pitch-deg", pitch_setting);
  }
 elsif (setting == "vertical-speed-hold")
  {
  var vs_setting = getprop("autopilot/settings/vertical-speed-fpm") + 100;
  if (vs_setting >= 9900)
   {
   vs_setting = 9900;
   }
  setprop("autopilot/settings/vertical-speed-fpm", vs_setting);
  }
 };
var pitch_wheel_down = func
 {
 var setting = vertical_prop.getValue();
 if (setting == "")
  {
  var pitch_setting = getprop("autopilot/settings/target-pitch-deg") - 1;
  if (pitch_setting <= -20)
   {
   pitch_setting = -20;
   }
  setprop("autopilot/settings/target-pitch-deg", pitch_setting);
  }
 elsif (setting == "vertical-speed-hold")
  {
  var vs_setting = getprop("autopilot/settings/vertical-speed-fpm") - 100;
  if (vs_setting <= -9900)
   {
   vs_setting = -9900;
   }
  setprop("autopilot/settings/vertical-speed-fpm", vs_setting);
  }
 };

var turn_anticipation = func {
	if (getprop("autopilot/route-manager/active")) {
		max_wpt=getprop("/autopilot/route-manager/route/num");
		atm_wpt=getprop("/autopilot/route-manager/current-wp");
		max_wpt-=1;
		if (getprop("/autopilot/route-manager/wp/eta")=="0:20" and getprop("/autopilot/route-manager/wp/dist")<15){
			if (getprop("/autopilot/route-manager/current-wp")<=max_wpt){
				atm_wpt+=1;
				props.globals.getNode("/autopilot/route-manager/current-wp").setValue(atm_wpt);
			}
		}
	settimer(turn_anticipation, 0.5);
	}
}

setlistener("autopilot/route-manager/active", func(fms) {
	var active = fms.getBoolValue();
	if (active) {
		turn_anticipation();
	}
},0,0);

