within IDEAS.Buildings.Components.BaseClasses.RadiativeHeatTransfer;
model ZoneLwGainDistribution
  "Distribution of radiative internal gains"

  parameter Integer nSurf(min=1) "number of surfaces in contact with the zone";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDir
    "Direct solar radiation gains received through windows"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDif
    "Diffuse solar radiation gains received through windows"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a radGain
    "External long wave internal gains, e.g. from radiator"
    annotation (Placement(transformation(extent={{-110,-48},{-90,-28}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nSurf] radSurfTot
    "Port for connecting to surfaces"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput TRad
    "Radiative zone temperature, computed as weighted sum of surface temperatures."
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] epsLw(
     each final unit="1")
    "Long wave surface emissivities of connected surfaces" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] epsSw(
     each final unit="1")
    "Short wave surface emissivities of connected surfaces" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] area(
     each final unit="m2")
    "Surface areas of connected surfaces" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-80,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] inc "Surface inclination angles"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] azi "Surface azimuth angles"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={80,100})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b gain_star
    "Port for injecting radiative heat gains onto star node"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

protected
  final parameter Real[nSurf] weightFactorDir(each final fixed=false)
    "weightfactor for received direct shortwave solar radiation";
  final parameter Real[nSurf] weightFactorTRad(each final fixed=false)
    "weightfactor for received direct shortwave solar radiation";
  final parameter Modelica.SIunits.Area AfloorTot(fixed=false)
    "Total floor surface area";
  final parameter Real ASWotherSurface(fixed=false)
    "Total absorption surface on surfaces other than the floor";
  final parameter Real fraTotAbsFloor(fixed=false)
    "Fraction of the bream radiation that is absorbed by the floor";

initial equation
  weightFactorDir = {if IDEAS.Utilities.Math.Functions.isAngle(inc[i], IDEAS.Types.Tilt.Floor)
                     then area[i]*epsSw[i]/AfloorTot
                     else (1-fraTotAbsFloor)*area[i]*epsSw[i]/ASWotherSurface for i in 1:nSurf};
  // minimum of Modelica.Constants.small to guard against division by zero
  AfloorTot = max(Modelica.Constants.small,sum({if IDEAS.Utilities.Math.Functions.isAngle(inc[i], IDEAS.Types.Tilt.Floor) then area[i] else 0 for i in 1:nSurf}));
  fraTotAbsFloor = sum({if IDEAS.Utilities.Math.Functions.isAngle(inc[i], IDEAS.Types.Tilt.Floor) then area[i]*epsSw[i] else 0 for i in 1:nSurf})/AfloorTot;
  ASWotherSurface = sum({if IDEAS.Utilities.Math.Functions.isAngle(inc[i], IDEAS.Types.Tilt.Floor) then 0 else area[i]*epsSw[i] for i in 1:nSurf});
  weightFactorTRad = area .* epsSw / sum(area .* epsSw);
  assert(AfloorTot>2*Modelica.Constants.small, "WARNING: Zone does not contain a floor surface so incoming beam radiation is spread over all other surfaces! Is this intended? \n", AssertionLevel.warning);

  assert(AfloorTot<0.9*sum(area), "More than 90% of zone surface area is floor, this is not allowed.");
  assert(abs(1-sum(weightFactorTRad))<1e-4, "Error in computation of weightFactorTRad, please submit a bug report");
  assert(abs(1-sum(weightFactorDir))<1e-4, "Error in computation of weightFactorDir, please submit a bug report");

equation
  TRad = radSurfTot.T * weightFactorTRad;

  iSolDir.T = TRad;
  iSolDif.T = TRad;
  radGain.T = TRad;

  radSurfTot.Q_flow = -weightFactorDir*iSolDir.Q_flow;
  gain_star.Q_flow = - iSolDif.Q_flow - radGain.Q_flow;

  annotation (
    Icon(graphics={
        Line(points={{-40,10},{40,10}}, color={191,0,0}),
        Line(points={{-40,10},{-30,16}}, color={191,0,0}),
        Line(points={{-40,10},{-30,4}}, color={191,0,0}),
        Line(points={{-40,-10},{40,-10}}, color={191,0,0}),
        Line(points={{30,-16},{40,-10}}, color={191,0,0}),
        Line(points={{30,-4},{40,-10}}, color={191,0,0}),
        Line(points={{-40,-30},{40,-30}}, color={191,0,0}),
        Line(points={{-40,-30},{-30,-24}}, color={191,0,0}),
        Line(points={{-40,-30},{-30,-36}}, color={191,0,0}),
        Line(points={{-40,30},{40,30}}, color={191,0,0}),
        Line(points={{30,24},{40,30}}, color={191,0,0}),
        Line(points={{30,36},{40,30}}, color={191,0,0}),
        Rectangle(
          extent={{-15,80},{15,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          origin={9,66},
          rotation=90),
        Rectangle(
          extent={{90,80},{60,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{-70,50},{60,50},{60,-80}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>
This model computes how radiative gains are redistributed among all surfaces.
We consider 1) diffuse solar gains, 
2) beam solar gains and 
3) other, long wave, internal gains, e.g. from occupants.
</p>
<p>
Diffuse solar gains are redistributed by computing a weighting factor equal to the surface area multiplied with the
shortwave emissivity of the surface.
This factor is used to redistribute the diffuse solar gains among all surfaces.
</p>
<p>
Internal gains from occupants are redistributed in the same way, but using
the long wave emissivity instead of the short wave emissivity.
</p>
<p>
Direct/bream solar gains are redistributed by assuming that a fixed fraction of the beam solar
gains are absorbed by the floor. 
This fraction equals the short wave emissivity of the floor. 
If there are multiple floors (based on the inclination angle) 
then their area and emissivity are used to compute a weight factor for the floors.
The remaining radiation is redistributed over all other surfaces, again using the shortwave emissivity
and surface area to determine the relative fractions.
If there is no floor then the beam radiation is spread over all surfaces and a warning is generated.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2016 by Filip Jorissen:<br/>
Fixed bug in absorption model where
<code>TRad</code> was computed using coefficients for
<code>iSolDir</code> instead of <code>iSolDif</code>.
Added asserts for checking the sum of all 
weight factors.
This closes #605.
</li>
<li>
September 8, 2016 by Filip Jorissen:<br/>
Added warning for when there are no floors and guarded against division by zero.
</li>
<li>
July 15, 2016 by Filip Jorissen:<br/>
New absorption model for beam radiation.
</li>
<li>
July 12, 2016 by Filip Jorissen:<br/>
Simplified implementation by removing intermediate variables.
</li>
</ul>
</html>"));
end ZoneLwGainDistribution;
