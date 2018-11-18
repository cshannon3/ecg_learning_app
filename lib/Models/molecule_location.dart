import 'dart:math';

import 'package:flutter/material.dart';

class MoleculeLocation {
  double xfromCenter;
  double yfromCenter;
  // for angle 0 deg is when  arrow pointed down to bottom of screen and it rotates towards the left of screen
  double directionAngle;
  // velocity will be pixels per tick
  double velocity;
  double xbounds = 200.0;
  double ybounds = 300.0;
  Color moleculeColor;
  int inCollisionWith = -1;
  //double oldDirectionAngle;
  int collisionDelay = 0;

  MoleculeLocation({
    @required this.xfromCenter,
    @required this.yfromCenter,
    this.velocity = 1.0,
    this.directionAngle = 45.0,
    // this.oldDirectionAngle = 45.0,
    this.moleculeColor = Colors.red,
  });

  updatePosition() {
    collisionDelay += 1;
    /* if (inCollisionWith != -1) {
      oldDirectionAngle = directionAngle;
      inCollisionWith = -1;
    }*/
    xfromCenter -= velocity * sin(directionAngle * (pi / 180));
    yfromCenter += velocity * cos(directionAngle * (pi / 180));
    if (xfromCenter.abs() > xbounds) {
      directionAngle = 360 - directionAngle;
    }
    if (yfromCenter.abs() > ybounds
        //|| (yfromCenter.abs() <= 10.0 && xfromCenter.abs() > 50.0)
        ) {
      directionAngle = 180.0 - directionAngle;
    }
  }

  double distanceFrom(double otherX, double otherY) {
    return sqrt(
        pow((otherX - xfromCenter), 2) + pow((otherY - yfromCenter), 2));
  }

  collision(double newangle, int collision_molecule) {
    if (collisionDelay > 3) {
      //  collision_molecule != inCollisionWith
      collisionDelay = 0;
      inCollisionWith = collision_molecule;
      // oldDirectionAngle = directionAngle;
      directionAngle = newangle; //directionAngle + 180 * cos(rotation);

      // xfromCenter += 3 * velocity * sin(directionAngle * (pi / 180));

      // yfromCenter += 3 * velocity * cos(directionAngle * (pi / 180));
    }
    collisionDelay = 0;
  }

  setDirection(double newdir) {
    directionAngle = newdir;
  }
  /* double getOldDirectionAngle() {
    return (oldDirectionAngle == directionAngle)
        ? directionAngle
        : oldDirectionAngle;
  }*/
}
