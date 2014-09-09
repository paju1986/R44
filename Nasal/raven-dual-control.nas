###############################################################################
## Nasal for dual control of the raven over the multiplayer network.
##
##  Copyright (C) 2007 - 2008  Anders Gidenstam  (anders(at)gidenstam.org)
##  This file is licensed under the GPL license version 2 or later.
##
##  Modified by Clément de l'Hamaide for Robinson R44 Raven II - 02/05/2011
##
###############################################################################

## Renaming (almost :)
var DCT = dual_control_tools;

## Pilot/copilot aircraft identifiers. Used by dual_control.
var pilot_type   = "Aircraft/R44/Models/raven.xml";
var copilot_type = "Aircraft/R44/Models/raven-copilot.xml";

######################### RAVEN PROPERTIES MP ###########################

#####
# pilot properties
##
var pilot_rudder = "sim/multiplay/generic/float[5]";
var pilot_elevator = "sim/multiplay/generic/float[6]";
var pilot_elevator_trim = "controls/flight/elevator-trim";
var pilot_aileron = "sim/multiplay/generic/float[7]";
var pilot_aileron_trim = "controls/flight/aileron-trim";
var pilot_throttle = "sim/multiplay/generic/float[8]";
var pilot_switches = "sim/multiplay/generic/int[3]";
var pilot_TDM_mpp  = "sim/multiplay/generic/string[0]";

#####
# copilot properties
##
var copilot_rudder = "controls/flight/rudder";
var copilot_elevator = "controls/flight/elevator";
var copilot_elevator_trim = "controls/flight/elevator-trim";
var copilot_aileron = "controls/flight/aileron";
var copilot_aileron_trim = "controls/flight/aileron-trim";
var copilot_throttle = "controls/engines/engine/throttle";
var copilot_switches = "sim/multiplay/generic/int[0]";
var copilot_TDM_mpp  = "sim/multiplay/generic/string[0]";

######################################################################
# Useful instrument related property paths.

# Flight controls
var rudder_cmd   = "controls/flight/rudder";
var elevator_cmd = "controls/flight/elevator";
var elevator_trim_cmd = "controls/flight/elevator-trim";
var aileron_cmd  = "controls/flight/aileron";
var aileron_trim_cmd = "controls/flight/aileron-trim";
var throttle_cmd = "controls/engines/engine/throttle";

var l_dual_control         = "dual-control";

######################################################################
###### Used by dual_control to set up the mappings for the pilot #####
######################## PILOT TO COPILOT ############################
######################################################################

var pilot_connect_copilot = func (copilot) {
  # Make sure dual-control is activated in the FDM FCS.
  setprop(l_dual_control, 1);
  return [];
}

##############
var pilot_disconnect_copilot = func {
  setprop(l_dual_control, 0);
}


######################################################################
##### Used by dual_control to set up the mappings for the copilot ####
######################## COPILOT TO PILOT ############################
######################################################################

var copilot_connect_pilot = func (pilot) {
  # Make sure dual-control is activated in the FDM FCS.
  setprop(l_dual_control, 1);
  return [
    ##################################################
    # Map copilot flight controls to MP properties.
      # Map /controls/flight/*
      DCT.Translator.new
        (pilot.getNode(pilot_rudder),
	 props.globals.getNode(rudder_cmd)),
      DCT.Translator.new
        (pilot.getNode(pilot_aileron),
	 props.globals.getNode(aileron_cmd)),
      DCT.Translator.new
        (pilot.getNode(pilot_elevator),
	 props.globals.getNode(elevator_cmd)),
      DCT.Translator.new
        (pilot.getNode(pilot_throttle),
	 props.globals.getNode(throttle_cmd)),
      # Map /multiplayer[pilot]/controls/flight/*
      DCT.Translator.new
        (pilot.getNode(pilot_rudder),
	 pilot.getNode(rudder_cmd)),
      DCT.Translator.new
        (pilot.getNode(pilot_aileron),
	 pilot.getNode(aileron_cmd)),
      DCT.Translator.new
        (pilot.getNode(pilot_elevator),
	 pilot.getNode(elevator_cmd)),
      DCT.Translator.new
        (pilot.getNode(pilot_throttle),
	 pilot.getNode(throttle_cmd)),
  ];
}

var copilot_disconnect_pilot = func {
  setprop(l_dual_control, 0);
}
