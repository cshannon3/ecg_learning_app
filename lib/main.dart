import 'dart:async';
import 'dart:math';

import 'package:ecg_learning_app/Models/molecule_location.dart';
import 'package:flutter/material.dart';

List<Color> colors = [Colors.blue, Colors.green, Colors.red];
void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Size s = MediaQuery.of(context).size;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: SimpleCollision(),
          //  MoleculesCollision(),
        )));
  }
}

class SimpleCollision extends StatefulWidget {
  @override
  _SimpleCollisionState createState() => _SimpleCollisionState();
}

class _SimpleCollisionState extends State<SimpleCollision> {
  Timer timer;
  Stopwatch stopwatch = Stopwatch();
  Random random;

  List<MoleculeLocation> molecules = [];
  bool open = false;
  @override
  void initState() {
    super.initState();
    random = Random();
    molecules = _buildMoleculeList();
    /* molecules.add(MoleculeLocation(
        xfromCenter: 0.0,
        yfromCenter: 0.0,
        velocity: 0.0,
        directionAngle: 0.0,
        moleculeColor: Colors.blue));
    molecules.add(MoleculeLocation(
        xfromCenter: -30.0,
        yfromCenter: 50.0,
        velocity: 0.0,
        directionAngle: 90.0,
        moleculeColor: Colors.red));
*/
    timer = Timer.periodic(Duration(milliseconds: 20), (Timer timer) {
      setState(() {
        molecules.forEach((mol) => mol.updatePosition());
      });
    });
  }

  List<MoleculeLocation> _buildMoleculeList() {
    List<MoleculeLocation> newMolecules = [];
    // top = 0; bottom = 0;
    for (int i = 0; i < 10; i++) {
      double newXCenter = random.nextInt(400) - 200.0;
      double newYCenter = random.nextInt(600) - 300.0;
      double newAngle = (random.nextInt(360)).toDouble();
      //   if (newYCenter>0) top+=1;
      Color newColor = colors[random.nextInt(3)];
      newMolecules.add(MoleculeLocation(
        xfromCenter: newXCenter,
        yfromCenter: newYCenter,
        directionAngle: newAngle,
        moleculeColor: newColor,
      ));
    }
    return newMolecules;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: []
          ..addAll(List.generate(molecules.length, (i) {
            return _buildMolecule(molecules[i], i);
          }))
          ..addAll(
            List.generate((molecules.length), (i) {
              int closest_molecule = (i + 1) % molecules.length;
              double length = molecules[i].distanceFrom(
                  molecules[closest_molecule].xfromCenter,
                  molecules[closest_molecule].yfromCenter);
              for (int p = 1; p < molecules.length; p++) {
                if (p != i) {
                  double seperation = molecules[i].distanceFrom(
                      molecules[p].xfromCenter, molecules[p].yfromCenter);
                  if (seperation < length) {
                    length = seperation;
                    closest_molecule = p;
                  }
                }
              }
              double roat = atan2(
                  (molecules[closest_molecule].xfromCenter -
                      molecules[i].xfromCenter),
                  (molecules[closest_molecule].yfromCenter -
                      molecules[i].yfromCenter));
              double xoffset = -(length) * sin(roat);
              double yoffset = (length) * cos(roat);
              if (length < 60.0) {
                // open = true;
                double radius = 10.0;
                /* double otherroat = atan2(
                    (molecules[i].xfromCenter -
                        molecules[closest_molecule].xfromCenter),
                    (molecules[i].yfromCenter -
                        molecules[closest_molecule].yfromCenter));
                        */
                double posroat = (roat * 180 / pi + 360) % 360;
                // rotated
                print(";;;;; $i");
                // y direction
                // first value is going to be transfered
                print(roat * 180 / pi);
                // print(otherroat * 180 / pi);

                /* print(
                  "Transfered by $i y dir ${-cos((molecules[i].directionAngle * pi / 180) - roat)}");
              print(
                  "Transfered to $i y dir ${-cos((molecules[closest_molecule].directionAngle * pi / 180) - roat)}");
              print(
                  "Transferred by $i x Direction ${-cos((molecules[i].directionAngle * pi / 180) - roat) * sin(roat)}");
                   "Transferred to $i x Direction ${-cos((molecules[closest_molecule].directionAngle * pi / 180) - roat) * sin(roat)}");
              print(
                  "Kept by $i in y dir ${-sin((molecules[i].directionAngle * pi / 180) - roat) * sin(roat)}");
              print(
                  "Kept in x Direction ${sin((molecules[i].directionAngle * pi / 180) - roat) * cos(roat)}");*/
                double newxdir =
                    // x component from other molecule
                    sin(roat -
                                (molecules[closest_molecule].directionAngle *
                                    pi /
                                    180)) *
                            sin(roat) +
                        // Own x component
                        cos((molecules[i].directionAngle * pi / 180) - roat) *
                            sin(roat);
                double othernewx =
                    // X component given to other
                    sin(roat - (molecules[i].directionAngle * pi / 180)) *
                            sin(roat) +
                        // X component from other
                        cos((molecules[closest_molecule].directionAngle *
                                    pi /
                                    180) -
                                roat) *
                            sin(roat);
                /*
                double othernewx =
                    cos((molecules[i].directionAngle * pi / 180) + (roat)) *
                            sin(roat) -
                        sin((molecules[closest_molecule].directionAngle *
                                    pi /
                                    180) +
                                otherroat) *
                            cos(otherroat);
                            */
                double newydir = cos((roat -
                            molecules[closest_molecule].directionAngle *
                                pi /
                                180)) *
                        cos(roat) +
                    sin((molecules[i].directionAngle * pi / 180) - roat) *
                        sin(roat);

                double othernewy =
                    cos(roat - (molecules[i].directionAngle * pi / 180)) *
                            cos(roat) +
                        sin((molecules[closest_molecule].directionAngle *
                                    pi /
                                    180) -
                                roat) *
                            sin(roat);
                print(" new y $newydir and new x $newxdir");
                double newangle = atan2(newxdir, newydir);

                print(newangle * 180 / pi);

                print(" other new y $othernewy and new x $othernewx");
                double othernewangle = atan2(othernewx, othernewy);
                print(othernewangle * 180 / pi);
                molecules[i].directionAngle = newangle * 180 / pi;
                molecules[closest_molecule].directionAngle =
                    othernewangle * 180 / pi;
                while (molecules[i].distanceFrom(
                        molecules[closest_molecule].xfromCenter,
                        molecules[closest_molecule].yfromCenter) <=
                    60.0) {
                  molecules[i].updatePosition();
                  molecules[closest_molecule].updatePosition();
                }
                // molecules[i].xfromCenter = 0.0;
                // molecules[i].yfromCenter = 0.0;
                // molecules[i].updatePosition();
                // molecules[closest_molecule].updatePosition();
              }

              /*print(-cos((molecules[i].directionAngle * pi / 180) - roat) *
                      cos(roat) -
                  sin((molecules[i].directionAngle * pi / 180) - roat) *
                      sin(roat));
              print(-cos((molecules[i].directionAngle * pi / 180) - roat) *
                      sin(roat) +
                  sin((molecules[i].directionAngle * pi / 180) - roat) *
                      cos(roat));
*/
              // print(sin((molecules[i].directionAngle * pi / 180) - roat) *
              //     cos(roat));
              // molecules[i] = MoleculeLocation(
              //     xfromCenter: 50.0 * i, yfromCenter: 100.0 * i);

              return /*Stack(
                children: <Widget>[
                  // Rotated*/
                  Transform(
                transform: //Matrix4.translationValues(100.0, 100.0, 0.0)
                    Matrix4.translationValues(
                        (MediaQuery.of(context).size.width / 2) -
                            molecules[i].xfromCenter,
                        (MediaQuery.of(context).size.height / 2) +
                            molecules[i].yfromCenter,
                        0.0)
                      ..rotateZ(roat - pi / 2),
                child: Container(
                  height: xoffset.abs(),
                  width: 2.0,
                  decoration: BoxDecoration(
                      color: molecules[i].moleculeColor,
                      border: Border.all(color: Colors.grey, width: .5)),
                ),
                /* ),
                  Transform(
                    transform: //Matrix4.translationValues(100.0, 100.0, 0.0)
                        Matrix4.translationValues(
                            (MediaQuery.of(context).size.width / 2) -
                                molecules[i].xfromCenter -
                                (xoffset * sin(roat)),
                            (MediaQuery.of(context).size.height / 2) +
                                molecules[i].yfromCenter +
                                (yoffset + sin(roat) * xoffset),
                            0.0)
                          ..rotateZ(roat),
                    child: Container(
                      height: yoffset.abs(),
                      width: 2.0,
                      decoration: BoxDecoration(
                          color: molecules[i].moleculeColor,
                          border: Border.all(color: Colors.grey, width: .5)),
                    ),
                  ),
                  /*Transform(
                    transform: //Matrix4.translationValues(100.0, 100.0, 0.0)
                    Matrix4.translationValues(
                        (MediaQuery.of(context).size.width / 2) -
                            molecules[i].xfromCenter -
                            xoffset,
                        (MediaQuery.of(context).size.height / 2) +
                            molecules[i].yfromCenter +
                            yoffset,
                        0.0)
                      ..rotateZ(roat),
                    child: Container(
                      height: yoffset.abs(),
                      width: 2.0,
                      color: colors[i],
                    ),
                  ),*/
                ],*/
              );
            }),
          ));
  }

  Widget _buildMolecule(MoleculeLocation newMolecule, int index) {
    return //Center(child:
        Transform.translate(
      // All movemet will be related to center
      offset: Offset(
          MediaQuery.of(context).size.width / 2 - newMolecule.xfromCenter,
          MediaQuery.of(context).size.height / 2 + newMolecule.yfromCenter),
      child: Stack(
        children: <Widget>[
          FractionalTranslation(
            translation: Offset(-0.5, -0.5),
            child: Container(
              height: 60.0,
              width: 60.0,
              decoration: BoxDecoration(
                color: newMolecule.moleculeColor,
                shape: BoxShape.circle,
              ),
              child: Center(child: Text("$index")),
            ),
          ),
          Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0)
                ..rotateZ(newMolecule.directionAngle * (pi / 180)),
              child: Container(
                height: 10.0,
                width: 3.0,
                color: Colors.black,
              )),
        ],
      ),
      // ),
    );
  }
}

class MoleculesCollision extends StatefulWidget {
  @override
  _MoleculesCollisionState createState() => _MoleculesCollisionState();
}

class _MoleculesCollisionState extends State<MoleculesCollision> {
  Timer timer;
  Stopwatch stopwatch = Stopwatch();
  Random random;
  List<MoleculeLocation> molecules = [];
  double linelength = 0.0;
  // int top = 0;
  int bottom = 0;
  List<Color> colors = [Colors.red, Colors.blue, Colors.green];
  @override
  void initState() {
    super.initState();
    random = Random();
    molecules = _buildMoleculeList();

    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 20), (Timer timer) {
      linelength = 0.0;
      setState(() {
        molecules.forEach((mol) => mol.updatePosition());
      });
    });
  }

  List<MoleculeLocation> _buildMoleculeList() {
    List<MoleculeLocation> newMolecules = [];
    // top = 0; bottom = 0;
    for (int i = 0; i < 10; i++) {
      double newXCenter = random.nextInt(400) - 200.0;
      double newYCenter = random.nextInt(600) - 300.0;
      double newAngle = (random.nextInt(360)).toDouble();
      //   if (newYCenter>0) top+=1;
      Color newColor = colors[random.nextInt(3)];
      newMolecules.add(MoleculeLocation(
        xfromCenter: newXCenter,
        yfromCenter: newYCenter,
        directionAngle: newAngle,
        moleculeColor: newColor,
      ));
    }
    // bottom = 20 - top;

    return newMolecules;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
      Align(
        alignment: Alignment.centerLeft,
        child: FractionalTranslation(
          translation: Offset(0.0, -0.5),
          child: Container(
            width: 150.0,
            height: 20.0,
            color: Colors.grey,
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: FractionalTranslation(
          translation: Offset(0.0, -0.5),
          child: Container(
            width: 150.0,
            height: 20.0,
            color: Colors.grey,
          ),
        ),
      ),
    ]
          ..addAll(List.generate((molecules.length), (i) {
            return _buildMolecule(molecules[i], i);
          }))
          ..addAll(List.generate((molecules.length), (i) {
            int closest_molecule = (i + 1) % molecules.length;
            double length = molecules[i].distanceFrom(
                molecules[closest_molecule].xfromCenter,
                molecules[closest_molecule].yfromCenter);
            for (int p = 1; p < molecules.length; p++) {
              if (p != i) {
                double seperation = molecules[i].distanceFrom(
                    molecules[p].xfromCenter, molecules[p].yfromCenter);
                if (seperation < length) {
                  length = seperation;
                  closest_molecule = p;
                }
              }
            }
            double roat = -atan2(
                (molecules[closest_molecule].xfromCenter -
                    molecules[i].xfromCenter),
                (molecules[closest_molecule].yfromCenter -
                    molecules[i].yfromCenter));

            //if (roat > 0) roat -= 2 * pi;
            //  double roat = atan()
            if (length < 20
                // && molecules[i].inCollisionWith != closest_molecule
                ) {
              print("collision of $i and $closest_molecule");
              print(molecules[i].directionAngle);
              //print(molecules[closest_molecule].getOldDirectionAngle());
              double ownpart = sin(molecules[i].directionAngle - roat);
              // double transferpart = cos((roat - molecules[closest_molecule].getOldDirectionAngle()));
              print(ownpart);
              //  print(transferpart);
              // print(atan2(transferpart, ownpart) * 180 / pi);
              // double newangle = atan2(transferpart, ownpart) * 180 / pi;

              // molecules[closest_molecule].collision(newangle, closest_molecule);

              print(i);
              print(roat * 180 / pi);
              // molecules[i].collision(newangle, closest_molecule);
              //   timer.cancel();
              print("-------------------------");
            }

            linelength += length;

            return Transform(
              transform: //Matrix4.translationValues(100.0, 100.0, 0.0)
                  Matrix4.translationValues(
                      (MediaQuery.of(context).size.width / 2) +
                          molecules[i].xfromCenter,
                      (MediaQuery.of(context).size.height / 2) +
                          molecules[i].yfromCenter,
                      0.0)
                    ..rotateZ(roat),
              child: Container(
                height: length,
                width: 2.0,
                color: Colors.pink,
              ),
            );
          })));
  }

  Widget _buildMolecule(MoleculeLocation newMolecule, int index) {
    return //Center(child:
        Transform.translate(
      // All movemet will be related to center
      offset: Offset(
          MediaQuery.of(context).size.width / 2 + newMolecule.xfromCenter,
          MediaQuery.of(context).size.height / 2 + newMolecule.yfromCenter),
      child: Stack(
        children: <Widget>[
          FractionalTranslation(
            translation: Offset(-0.5, -0.5),
            child: Container(
              height: 20.0,
              width: 20.0,
              decoration: BoxDecoration(
                color: newMolecule.moleculeColor,
                shape: BoxShape.circle,
              ),
              child: Text("$index"),
            ),
          ),
          Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0)
                ..rotateZ(-newMolecule.directionAngle * (pi / 180)),
              child: Container(
                height: 10.0,
                width: 3.0,
                color: Colors.black,
              )),
          Container(
            height: 5.0,
            width: 5.0,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      // ),
    );
  }
}

class MoleculesScreen extends StatefulWidget {
  @override
  _MoleculesScreenState createState() => _MoleculesScreenState();
}

class _MoleculesScreenState extends State<MoleculesScreen> {
  Timer timer;
  Stopwatch stopwatch = Stopwatch();
  Random random;
  List<MoleculeLocation> molecules = [];
  List<Color> colors = [Colors.red, Colors.blue, Colors.green];

  @override
  void initState() {
    super.initState();
    random = Random();
    molecules = _buildMoleculeList();
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 20), (Timer timer) {
      setState(() {
        molecules.forEach((mol) => mol.updatePosition());
      });
    });
  }

  List<MoleculeLocation> _buildMoleculeList() {
    List<MoleculeLocation> newMolecules = [];
    for (int i = 0; i < 30; i++) {
      double newXCenter = random.nextInt(400) - 200.0;
      double newYCenter = random.nextInt(600) - 300.0;
      double newAngle = (random.nextInt(360)).toDouble();
      Color newColor = colors[random.nextInt(3)];
      newMolecules.add(MoleculeLocation(
        xfromCenter: newXCenter,
        yfromCenter: newYCenter,
        directionAngle: newAngle,
        moleculeColor: newColor,
      ));
    }

    return newMolecules;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: FractionalTranslation(
            translation: Offset(0.0, -0.5),
            child: Container(
              width: 150.0,
              height: 20.0,
              color: Colors.grey,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FractionalTranslation(
            translation: Offset(0.0, -0.5),
            child: Container(
              width: 150.0,
              height: 20.0,
              color: Colors.grey,
            ),
          ),
        ),
      ]..addAll(List.generate((molecules.length), (i) {
          return _buildMolecule(molecules[i]);
        })),
    );
  }

  Widget _buildMolecule(MoleculeLocation newMolecule) {
    return Center(
      child: Transform.translate(
        // All movemet will be related to center
        offset: Offset(newMolecule.xfromCenter, newMolecule.yfromCenter),
        child: Stack(
          children: <Widget>[
            FractionalTranslation(
              translation: Offset(-0.5, -0.5),
              child: Container(
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                  color: newMolecule.moleculeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Transform(
                transform: Matrix4.translationValues(0.0, 0.0, 0.0)
                  ..rotateZ(-newMolecule.directionAngle * (pi / 180)),
                child: Container(
                  height: 10.0,
                  width: 3.0,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
