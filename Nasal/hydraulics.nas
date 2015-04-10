# ATR 72-500
# Hydraulics system
###################

# The ATR hydraulics system is split into two separate systems
# The 'blue' system controls:
#  - Flaps
#  - Spoilers
#  - Nose gear steering
#  - Engine 2 propeller brake
#  - Emergency and parking brakes
# The 'green' system controls:
#  - Landing gear extension/retraction
#  - Normal brakes

var hydraulics =
 {
 auxilary_pump: props.globals.initNode("controls/hydraulic/system[0]/electric-pump[1]", 1, "BOOL"),
 xfeed: props.globals.initNode("controls/hydraulic/x-feed", 1, "BOOL"),
 blue:
  {
  serviceable: props.globals.initNode("systems/hydraulics/blue/serviceable", 1, "BOOL"),
  pump: props.globals.initNode("controls/hydraulic/system[0]/electric-pump[0]", 1, "BOOL"),
  flight:
   {
   flaps: props.globals.initNode("systems/hydraulics/blue/flight/flaps", 0, "DOUBLE"),
   spoilers: props.globals.initNode("systems/hydraulics/blue/flight/spoilers", 0, "DOUBLE")
   },
  engines:
   {
   propeller_brake: props.globals.initNode("systems/hydraulics/blue/engines/propeller-brake", 0, "BOOL")
   },
  gear:
   {
   brake_parking: props.globals.initNode("systems/hydraulics/blue/gear/brake-parking", 0, "BOOL")
   },
  update: func
   {
   var flaps = props.globals.getNode("controls/flight/flaps");
   var flaps_pos = props.globals.getNode("surface-positions/flap-pos-norm");
   var spoilers = props.globals.getNode("controls/flight/speedbrake");
   var spoilers_pos = props.globals.getNode("surface-positions/speedbrake-pos-norm");
   var propeller_brake = props.globals.getNode("controls/engines/propeller-brake");
   var brake_parking = props.globals.getNode("controls/gear/brake-parking");
   if (hydraulics.blue.serviceable.getBoolValue() and (hydraulics.blue.pump.getBoolValue() or hydraulics.auxilary_pump.getBoolValue()))
    {
    hydraulics.blue.flight.flaps.setValue(flaps.getValue());
    hydraulics.blue.flight.spoilers.setValue(spoilers.getValue());
    hydraulics.blue.engines.propeller_brake.setBoolValue(propeller_brake.getBoolValue());
    hydraulics.blue.gear.brake_parking.setBoolValue(brake_parking.getBoolValue());
    }
   else
    {
    hydraulics.blue.flight.flaps.setValue(flaps_pos.getValue());
    hydraulics.blue.flight.spoilers.setValue(spoilers_pos.getValue());
    hydraulics.blue.engines.propeller_brake.setBoolValue(0);
    hydraulics.blue.gear.brake_parking.setBoolValue(0);
    }
   }
  },
 green:
  {
  serviceable: props.globals.initNode("systems/hydraulics/green/serviceable", 1, "BOOL"),
  pump: props.globals.initNode("controls/hydraulic/system[1]/electric-pump", 1, "BOOL"),
  gear:
   {
   gear_down: props.globals.initNode("systems/hydraulics/green/gear/gear-down", 1, "BOOL"),
   brake_left: props.globals.initNode("systems/hydraulics/green/gear/brake-left", 0, "DOUBLE"),
   brake_right: props.globals.initNode("systems/hydraulics/green/gear/brake-right", 0, "DOUBLE")
   },
  update: func
   {
   var gear_down = props.globals.getNode("controls/gear/gear-down");
   var brake_left = props.globals.getNode("controls/gear/brake-left");
   var brake_right = props.globals.getNode("controls/gear/brake-right");
   if (hydraulics.green.serviceable.getBoolValue() and (hydraulics.green.pump.getBoolValue() or (hydraulics.auxilary_pump.getBoolValue() and hydraulics.xfeed.getBoolValue())))
    {
    hydraulics.green.gear.gear_down.setBoolValue(gear_down.getBoolValue());
    hydraulics.green.gear.brake_left.setValue(brake_left.getValue());
    hydraulics.green.gear.brake_right.setValue(brake_right.getValue());
    }
   else
    {
    hydraulics.green.gear.brake_left.setValue(0);
    hydraulics.green.gear.brake_right.setValue(0);
    }
   }
  },
 update: func
  {
  hydraulics.blue.update();
  hydraulics.green.update();
  }
 };

print("ATR 72 hydraulics ... ok")
