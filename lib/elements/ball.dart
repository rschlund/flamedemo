import 'dart:ui';
import 'package:box2d_flame/box2d.dart';
import '../game.dart';

class Ball {
  final MazeBallGame game;
  //Physic objects
  Body body;
  CircleShape shape;
  //Scale to get from rad/s to something in the game, I like the number 5
  double sensorScale = 5;
  //Draw class
  Paint paint;
  //Initial acceleration -> no movement as its (0,0)
  Vector2 acceleration = Vector2.zero();

  //Generate the ball and phisyc behind
  Ball(this.game, Vector2 position) {
    shape = CircleShape(); //build in shape, just set the radius
    shape.p.setFrom(Vector2.zero());
    shape.radius = .1; //10cm ball

    paint = Paint();
    paint.color = Color(0xffffffff);

    BodyDef bd = BodyDef();
    bd.linearVelocity = Vector2.zero();
    bd.position = position;
    bd.fixedRotation = false;
    bd.bullet = false;
    bd.type = BodyType.DYNAMIC;
    body = game.world.createBody(bd);
    body.userData = this;

    FixtureDef fd = FixtureDef();
    fd.density = 10;
    fd.restitution = 1;
    fd.friction = 0;
    fd.shape = shape;
    body.createFixtureFromFixtureDef(fd);
    //Replace by data from Sensor
    /*gyroscopeEvents.listen((GyroscopeEvent event) {
      //Adding up the scaled sensor data to the current acceleration
      acceleration.add(Vector2(event.y / sensorScale, event.x / sensorScale));
    });*/
  }
  //Draw the ball
  void render(Canvas c) {
    c.save();
    //Move the canvas point 0,0 to the top left edge of our ball
    c.translate(body.position.x, body.position.y);
    //Simply draw the circle
    c.drawCircle(Offset(0, 0), .1, paint);
    c.restore();
  }


  void update(double t) {
    //Our ball has to move, every frame by its accelartion. If frame rates drop it will move slower...
    body.applyForceToCenter(acceleration);
  }
}