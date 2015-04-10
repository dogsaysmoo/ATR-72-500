# ATR 72-500
# Aircraft-specific control functions
#####################################

var engines = [];
setlistener("sim/signals/fdm-initialized", func
 {
 var nodes = props.globals.getNode("controls/engines").getChildren("engine");
 for (var i = 0; i < size(nodes); i += 1)
  {
  append(engines, {});
  engines[size(engines) - 1].node = nodes[i];
  engines[size(engines) - 1].selected = props.globals.getNode("sim/input/selected/engine[" ~ i ~ "]");
  }
 }, 0, 0);

var incCondition = func(v)
 {
 var min = 0;
 var max = 1;
 for (var i = 0; i < size(engines); i += 1)
  {
  if (engines[i].selected.getBoolValue())
   {
   var condition = engines[i].node.getChild("condition");
   var newvalue = condition.getValue() + v;
   condition.setValue(newvalue < min ? min : newvalue > max ? max : newvalue);
   }
  }
 };

var incStarter = func(v)
 {
 var min = 0;
 var max = 4;
 var start_switch = props.globals.getNode("controls/engines/start-switch");
 var newvalue = start_switch.getValue() + v;
 start_switch.setValue(newvalue < min ? min : newvalue > max ? max : newvalue);
 };
