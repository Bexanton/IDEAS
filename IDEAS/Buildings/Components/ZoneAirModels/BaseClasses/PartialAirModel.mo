within IDEAS.Buildings.Components.ZoneAirModels.BaseClasses;
partial model PartialAirModel "Partial for air models"
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare replaceable package Medium = IDEAS.Media.Air);

  parameter Integer nSurf "Number of connected surfaces";
  parameter Integer nSeg(min=1)=1 "Number of air segments";
  parameter Integer nPorts "Number of fluid port connections to zone air volume";
  parameter Modelica.SIunits.Volume Vtot "Total zone air volume";
  parameter Boolean allowFlowReversal=true
     "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Advanced"));
  parameter Boolean useFluPor = true "Set to false to remove fluid ports"
    annotation(Dialog(tab="Advanced"));
  constant Boolean computeTSensorAsFunctionOfZoneAir = true
    "Set to false if TSensor in zone model should not take into account the value of the zone air temperature";
  Modelica.Blocks.Interfaces.RealOutput E(unit="J") "Model internal energy";
  Modelica.Blocks.Interfaces.RealOutput QGai(unit="J/s") "Model internal energy";
  Modelica.Blocks.Interfaces.RealOutput TAir "Zone air temperature"
    annotation (Placement(transformation(extent={{98,-70},{118,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSurf] ports_surf
    "Heat convection ports for surfaces"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] inc
    "Inclination angle of surface"
    annotation (Placement(transformation(extent={{-128,60},{-88,100}})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] A
    annotation (Placement(transformation(extent={{-126,-80},{-86,-40}})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] azi "Azimuth of surface"
    annotation (Placement(transformation(extent={{-128,20},{-88,60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) if useFluPor
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) if useFluPor
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  outer BoundaryConditions.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSeg] ports_air
    "Heat convection ports for air volumes"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow
    "Moisture mass flow rate being added to the zone air"
    annotation (Placement(transformation(extent={{128,60},{88,100}})));
  Modelica.Blocks.Interfaces.RealInput C_flow[max(Medium.nC,1)]
    "Trace substance mass flow rate being added to the zone air"
    annotation (Placement(transformation(extent={{128,20},{88,60}})));
  Modelica.Blocks.Interfaces.RealOutput phi "Zone air relative humidity"
    annotation (Placement(transformation(extent={{98,-50},{118,-30}})));
protected
  final parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";
  final parameter Modelica.SIunits.Density rho_default = Medium.density(
    state=state_default) "Medium default density";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default = Medium.specificHeatCapacityCp(state=state_default);
public
  Modelica.Fluid.Interfaces.FluidPorts_a[nPorts] ports(
    redeclare each package Medium = Medium) "Ports connector for multiple ports" annotation (Placement(
        transformation(
        extent={{-10,-40},{10,40}},
        rotation=90,
        origin={0,100})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(revisions="<html>
<ul>
<li>
April 27, 2018 by Filip Jorissen:<br/>
Modified model for supporting new interzonal air flow models.
Air leakage model and its parameters have been removed.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/796\">#796</a>.
</li>
<li>
November 15, 2016 by Filip Jorissen:<br/>
Revised documentation.
</li>
<li>
August 26, 2016 by Filip Jorissen:<br/>
Added support for conservation of energy.
</li>
<li>
April 30, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Zone air model partial containing main parameters and connectors.
</p>
</html>"));
end PartialAirModel;
