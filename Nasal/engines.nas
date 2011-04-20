# ATR 72-500
# Engine control system
#######################

# NOTE: Update functions are called in systems.nas

# minimum condition value for engines to run; for YASim this is 0.1%
var condition_cutoff = 0.001;
var condition_min = 0.4;

var engine =
 {
 new: func(no)
  {
  var m =
   {
   parents: [engine]
   };
  m.number = no;

  m.condition = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/condition", 1);
  m.condition.setValue(0);
  m.condition_lever = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/condition-lever", 1);
  m.condition_lever.setValue(0);
  m.cutoff = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/cutoff", 1);
  m.cutoff.setBoolValue(0);
  m.n1 = props.globals.getNode("engines/engine[" ~ no ~ "]/n1", 1);
  m.n1.setValue(0);
  m.n2 = props.globals.getNode("engines/engine[" ~ no ~ "]/n2", 1);
  m.n2.setValue(0);
  m.on_fire = props.globals.getNode("engines/engine[" ~ no ~ "]/on-fire", 1);
  m.on_fire.setBoolValue(0);
  m.out_of_fuel = props.globals.getNode("engines/engine[" ~ no ~ "]/out-of-fuel", 1);
  m.out_of_fuel.setBoolValue(0);
  m.propeller_feather = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/propeller-feather", 1);
  m.propeller_feather.setBoolValue(0);
  m.reverser = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/reverser", 1);
  m.reverser.setBoolValue(0);
  m.reverser_cmd_norm = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/reverser-cmd-norm", 1);
  m.reverser_cmd_norm.setValue(0);
  m.serviceable = props.globals.getNode("sim/failure-manager/engines/engine[" ~ no ~ "]/serviceable", 1);
  m.serviceable.setBoolValue(1);
  m.starter = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/starter", 1);
  m.starter.setBoolValue(0);
  m.throttle = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/throttle", 1);
  m.throttle.setValue(0);
  m.throttle_lever = props.globals.getNode("controls/engines/engine[" ~ no ~ "]/throttle-lever", 1);
  m.throttle_lever.setValue(0);

  return m;
  },
 update: func
  {
  if (me.on_fire.getBoolValue())
   {
   me.serviceable.setBoolValue(0);
   }
  if (me.cutoff.getBoolValue())
   {
   me.out_of_fuel.setBoolValue(1);
   }

  if (me.reverser.getBoolValue())
   {
   me.throttle_lever.setValue(0);
   me.reverser_cmd_norm.setValue(me.throttle.getValue());
   }
  else
   {
   me.throttle_lever.setValue(me.throttle.getValue());
   me.reverser_cmd_norm.setValue(0);
   }

  if (me.starter.getBoolValue() and me.condition_lever.getValue() < condition_cutoff and me.condition.getValue() >= condition_cutoff)
   {
   var start_switch = getprop("controls/engines/start-switch");
   if ((me.number == 0 and (start_switch == 2 or start_switch == 4)) or (me.number == 1 and (start_switch == 3 or start_switch == 4)))
    {
    me.condition_lever.setValue(me.get_condition_value(me.condition.getValue()));
    }
   else
    {
    me.condition_lever.setValue(0);
    }
   }
  elsif (me.condition_lever.getValue() < condition_cutoff and me.n2.getValue() < 0.5)
   {
   var true_airspeed = aircraft.kias_to_ktas(getprop("velocities/airspeed-kt"), getprop("position/altitude-ft"));
   if (me.propeller_feather.getBoolValue() or true_airspeed < 30)
    {
    me.n1.setValue(0);
    }
   else
    {
    # Windmilling calculation is based on a presumed maximum windmilling N2 (20%) and the maximum operating speed (250 kts)
    # No, it's not very accurate
    me.n1.setValue(true_airspeed / 12.5);
    me.reverser_cmd_norm.setValue(true_airspeed / 2500);
    }
   me.condition_lever.setValue(0);
   }
  if (me.n2.getValue() >= 0.5)
   {
   if (me.condition_lever.getValue() >= condition_cutoff)
    {
    me.condition_lever.setValue(me.get_condition_value(me.condition.getValue()));
    }
   else
    {
    me.condition_lever.setValue(0);
    }
   me.n1.setValue(me.n2.getValue());
   if (me.number == 1 and props.globals.getNode("systems/hydraulics/blue/engines/propeller-brake").getBoolValue())
    {
    me.throttle_lever.setValue(0);
    me.n1.setValue(0);
    }
   }
  },
 reverse_thrust: func
  {
  if (me.throttle.getValue() == 0)
   {
   if (me.reverser.getBoolValue())
    {
    me.reverser.setBoolValue(0);
    }
   else
    {
    me.reverser.setBoolValue(1);
    }
   }
  },
 get_condition_value: func(v)
  {
  if (v >= 0.4)
   {
   return condition_cutoff + (v - 0.4) / 0.6 * (1 - condition_cutoff);
   }
  return v / 0.4 * condition_cutoff;
  }
 };
var engine1 = engine.new(0);
var engine2 = engine.new(1);
