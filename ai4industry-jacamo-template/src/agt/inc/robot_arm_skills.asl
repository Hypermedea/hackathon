/*

@author Olivier Boissier (Mines Saint-Etienne)
*/

location_conveyor([2.2,0,1]). // relative position of conveyor
location_packaging([3.2,0,1]). // relative position of packaging workshop

has_origin_coordinates(Name,ValueX, ValueY, ValueZ) :-
      thing(Name,Thing)
      & entryPoint(Base)
      & builder(Thing, Base, "ontology#hasOriginCoordinates", Temp)
      & builder(Temp, Base, "ontology#coordX",ValueX)
      & builder(Temp, Base, "ontology#coordY",ValueY)
      & builder(Temp, Base, "ontology#coordZ",ValueZ)
  .

// Plan for invoking the action affordance reset
+!reset(Name) :
    thing(Name,Thing)
    <-
    ?reset_action(Thing,ActionName);
    invokeAction(ActionName)[artifact_name(Name)];
    .println("invoked operation ",ActionName," on ",Thing);
  .

// contingency plan in case the achievement of goal !reset fails
-!reset(Name) :
    thing(Name,Thing)
    <-
    .println("---> ",Thing," has no reset operation");
  .

// Plan for invoking the action affordance release
+!release(Name,At) :
    thing(Name,Thing)
    & release_action(Thing,ActionName)
    <-
    invokeAction(ActionName)[artifact_name(Name)];
    .println("invoked operation ",ActionName," with parameter ",At," on ",Thing);
  .

// Plan for invoking the action affordance grasp
+!grasp(Name,At) :
    thing(Name,Thing)
    & grasp_action(Thing,ActionName)
    <-
    .println("invoking operation ",ActionName," with parameter ",At," on ",Thing);
    invokeAction(ActionName)[artifact_name(Name)];
    .println("invoked operation ",ActionName," with parameter ",At," on ",Thing);
  .

// contingency plan in case the achievement of goal !grasp fails
-!grasp(Name,At) :
    thing(Name,Thing)
    & grasp_action(Thing,ActionName)
    <-
    .println("---> Grasp operation failed ");
    .wait(3000);
    !grasp(Name,At);
  .

// Plan for invoking the move affordance grasp
+!move(Name,[X,Y,Z]) :
    thing(Name,Thing)
    & move_action(Thing,ActionName)
    <-
    invokeAction(ActionName,json([kv(x,X),kv(y,Y),kv(z,Z)]))[artifact_name(Name)];
    .println("invoked operation ",ActionName," with parameter X ",X," Y ",Y," Z ",Z," on ",Thing);
  .
