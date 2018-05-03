within IDEAS.BoundaryConditions.Examples;
model StrobeInfoManager_offset
  "Unit test for SimInfoManager with time offset on read data"
  import IDEAS;
  extends Modelica.Icons.Example;
  inner IDEAS.BoundaryConditions.Occupants.Extern.StrobeInfoManager strobe(
    nOcc=10,
    FilNam_P="P.txt",
    FilNam_Q="Q.txt",
    FilNam_mDHW="mDHW.txt",
    FilNam_QCon="QCon.txt",
    FilNam_QRad="QRad.txt",
    FilNam_TSet="sh_day.txt",
    FilNam_TSet2="sh_night.txt",
    filDir=Modelica.Utilities.Files.loadResource("modelica://IDEAS") +
        "/Resources/strobe/",
    startTime(displayUnit="d") = -864000)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  annotation (
    experiment(StopTime=1e+06),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/BoundaryConditions/Examples/StrobeInfoManager1.mos"
        "Unit test 1"),
    Documentation(revisions="<html>
<ul>
<li>
September 22, 2016 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end StrobeInfoManager_offset;
