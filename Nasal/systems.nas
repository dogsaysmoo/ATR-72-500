# ATR 72-500
# Aircraft systems
##################

# NOTE: This file contains a loop for running all update functions, so it should be loaded last

## Systems loop
var systems =
 {
 stopUpdate: 0,
 init: func
  {
  aircraft.crossfeed_valve.new(2, "controls/fuel/x-feed", 0, 1);
  systems.stop();
  settimer(func
   {
   systems.stopUpdate = 0;
   systems.update();
   }, 0.5);
  print("ATR 72 aircraft systems ... initialized");
  },
 stop: func
  {
  systems.stopUpdate = 1;
  },
 reinit: func
  {
  systems.stop();
  settimer(func
   {
   systems.stopUpdate = 0;
   systems.update();
   }, 0.5);
  setprop("sim/model/start-idling", 0);
  print("ATR 72 aircraft systems ... reinitialized");
  },
 update: func
  {
  engine1.update();
  engine2.update();
  hydraulics.update();
  update_electrical();
  update_steering();

  # stop calling our systems code if the stop() function was called or the aircraft crashes
  if (!systems.stopUpdate and !props.globals.getNode("sim/crashed").getBoolValue())
   {
   settimer(systems.update, 0);
   }
  }
 };

# call init() 2 seconds after the FDM is ready
setlistener("sim/signals/fdm-initialized", func
 {
 settimer(systems.init, 2);
 }, 0, 0);
# call reinit() if the simulator resets
setlistener("sim/signals/reinit", func(reinit)
 {
 if (reinit.getBoolValue())
  {
  systems.reinit();
  }
 }, 0, 0);

## Startup/shutdown functions
var start_id = -1;
var startup = func
 {
 start_id += 1;
 var id = start_id;
 setprop("controls/engines/start-switch", 4);
 setprop("controls/engines/engine[0]/condition", 1);
 setprop("controls/engines/engine[1]/condition", 1);
 setprop("controls/engines/engine[0]/starter", 1);
 setprop("controls/engines/engine[1]/starter", 1);
 setprop("controls/electric/engine[0]/generator", 1);
 setprop("controls/electric/engine[1]/generator", 1);
 settimer(func
  {
  if (id != start_id)
   {
   return;
   }
  setprop("controls/engines/start-switch", 0);
  setprop("controls/engines/engine[0]/starter", 0);
  setprop("controls/engines/engine[1]/starter", 0);
  }, 3);
 };
var shutdown = func
 {
 setprop("controls/engines/engine[0]/condition", 0);
 setprop("controls/engines/engine[1]/condition", 0);
 setprop("controls/electric/engine[0]/generator", 0);
 setprop("controls/electric/engine[1]/generator", 0);
 };
setlistener("sim/model/start-idling", func(idle)
 {
 var run = idle.getBoolValue();
 if (run)
  {
  startup();
  }
 else
  {
  shutdown();
  }
 }, 0, 0);

## Nose gear steering
# The nose gear can be steered using the normal system (tiller) or the alternate system (rudder)
# The real ATR 72 only steers using the "normal" system; the alternate system is implemented only for the sake of user-friendliness
var update_steering = func
 {
 var enable_tiller = props.globals.getNode("controls/gear/enable-tiller").getBoolValue();
 # Normal system
 if (enable_tiller)
  {
  var tiller_steer = props.globals.getNode("controls/gear/tiller-steering-deg").getValue();
  setprop("controls/gear/steering-deg", tiller_steer);
  }
 # Alternate system
 else
  {
  var rudder_steer = props.globals.getNode("controls/flight/rudder").getValue();
  setprop("controls/gear/steering-deg", rudder_steer * 60);
  }
 };

## Aircraft-specific dialogs
var dialogs =
 {
 lights: gui.Dialog.new("sim/gui/lights/dialog", "Aircraft/ATR-72-500/Systems/lights-dlg.xml"),
 failures: gui.Dialog.new("sim/gui/failures/dialog", "Aircraft/ATR-72-500/Systems/failures-dlg.xml"),
 tiller: gui.Dialog.new("sim/gui/tiller/dialog", "Aircraft/ATR-72-500/Systems/tiller-dlg.xml"),
 autopilot: gui.Dialog.new("sim/gui/autopilot/dialog", "Aircraft/ATR-72-500/Systems/autopilot-dlg.xml")
 };
