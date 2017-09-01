// Place student's code here
// Student's names: Han Zhang, Luyao Huang
// Date last edited: Aug.31,2017
/* Functionality provided (say what works):
problem 2:
 1.Calculated and drew the medial axis of caplet W.
problem 1:
 1.Computed 4 arcs to make callet W.
 2.Used 120 points to draw caplet W.
 3.Filled W with color(200,200,200).
 4.draw 4 arcs with different color.
 */

pt circleCenterL, circleCenterR;
pt tangentPointL, tangentPointR;
pt intersectionPointL, intersectionPointR;
float radiusL, radiusR;
final int point_number = 40;
pt [] pointSetCircleArcL = new pt[point_number];
pt [] pointSetCircleArcR = new pt[point_number];
pt [] pointSetTanCircleL = new pt[point_number];
pt [] pointSetTanCircleR = new pt[point_number];
pt [] areaW = new pt[4 * point_number];
PShape areaWP = new PShape();

final int divisionNumber = 200;
class Matrix
{
  float [][] value;
  Matrix()
  {
    value = new float[3][3];
    value[0][0] = 1;
    value[0][1] = 0;
    value[0][2] = 0;
    value[1][0] = 0;
    value[1][1] = 1;
    value[1][2] = 0;
    value[2][0] = 0;
    value[2][1] = 0;
    value[2][2] = 1;
  }
  void setMatrix(Matrix b)
  {
    for (int i = 0; i < 3; i++)
      for (int j = 0; j < 3; j++)
      {
        value[i][j] = b.value[i][j];
      }
  }
  void setRotation(float theta)
  {
    value[0][0] = cos(theta);
    value[0][1] = sin(theta);
    value[0][2] = 0;
    value[1][0] = -sin(theta);
    value[1][1] = cos(theta);
    value[1][2] = 0;
    value[2][0] = 0;
    value[2][1] = 0;
    value[2][2] = 1;
  }

  void setRotation(float costheta, float sintheta)
  {
    value[0][0] = costheta;
    value[0][1] = sintheta;
    value[0][2] = 0;
    value[1][0] = -sintheta;
    value[1][1] = costheta;
    value[1][2] = 0;
    value[2][0] = 0;
    value[2][1] = 0;
    value[2][2] = 1;
  }


  void setTranslation(float x, float y)
  {
    value[0][0] = 1;
    value[0][1] = 0;
    value[0][2] = 0;
    value[1][0] = 0;
    value[1][1] = 1;
    value[1][2] = 0;
    value[2][0] = x;
    value[2][1] = y;
    value[2][2] = 1;
  }
}

Matrix Apply(Matrix mat1, Matrix mat2)
{
  Matrix resultMatrix = new Matrix();
  for (int i = 0; i < 3; i++)
    for (int j = 0; j < 3; j++)
    {
      resultMatrix.value[j][i] = mat1.value[j][0] * mat2.value[0][i] + mat1.value[j][1] * mat2.value[1][i] + mat1.value[j][2] * mat2.value[2][i];
    }
  return resultMatrix;
}

pt Apply(pt point, Matrix mat)
{
  pt resultpt = new pt();
  resultpt.x = point.x * mat.value[0][0] + point.y * mat.value[1][0] + mat.value[2][0];
  resultpt.y = point.x * mat.value[0][1] + point.y * mat.value[1][1] + mat.value[2][1];
  float scale = point.x * mat.value[0][2] + point.y * mat.value[1][2] + mat.value[2][2];

  resultpt.x /= scale;
  resultpt.y /= scale;

  return resultpt;
}

vec Apply(vec vector, Matrix mat)
{
  vec resultvec = new vec();

  resultvec.x = vector.x * mat.value[0][0] + vector.y * mat.value[1][0];
  resultvec.y = vector.x * mat.value[0][1] + vector.y * mat.value[1][1];
  float scale = vector.x * mat.value[0][2] + vector.y * mat.value[1][2] + mat.value[2][2];

  resultvec.x /= scale;
  resultvec.y /= scale;

  return resultvec;
}

void PrintMatrix(Matrix mat)
{
  for (int i = 0; i < 3; i++)
  {
    println(mat.value[i][0] + "  " + mat.value[i][1] + "  " + mat.value[i][2]);
  }
}

void pointSetonCircle(pt [] pointSet, pt point_a, pt point_b, CIRCLE circle, boolean clockwise)
{
  float startAngle = atan2((point_a.y - circle.C.y)/circle.r, (point_a.x - circle.C.x) /circle.r);
  float endAngle = atan2((point_b.y - circle.C.y) /circle.r, (point_b.x - circle.C.x) /circle.r);

  // println(pow((point_b.y - circle.C.y) /circle.r,2) + "   " + pow((point_b.x - circle.C.x) /circle.r,2));

  if (clockwise)
  {
    if (endAngle > startAngle)
      startAngle += 2 * PI;
  } else
  {
    if (endAngle < startAngle)
      endAngle += 2 * PI;
  }

  float theta = startAngle;
  float deltaAngle = (endAngle - startAngle)  / point_number;
  for (int i = 0; i < point_number; i++, theta += deltaAngle)
  {
    float x = circle.C.x + circle.r * cos(theta);
    float y = circle.C.y + circle.r * sin(theta);
    pointSet[i] = new pt();
    pointSet[i].x = x;
    pointSet[i].y = y;
  }
}
void pointSetonCircle(pt [] pointSet, pt point_a, pt point_b, CIRCLE circle, int smallArc)
{


  float startAngle = atan2((point_a.y - circle.C.y)/circle.r, (point_a.x - circle.C.x) /circle.r);
  float endAngle = atan2((point_b.y - circle.C.y) /circle.r, (point_b.x - circle.C.x) /circle.r);

  // println(pow((point_b.y - circle.C.y) /circle.r,2) + "   " + pow((point_b.x - circle.C.x) /circle.r,2));

  if (endAngle < startAngle)
  {
    float temp = endAngle;
    endAngle = startAngle;
    startAngle = temp;
  }

  if (smallArc == 1)
  {
    if (endAngle - startAngle > PI )
    {
      float temp = endAngle;
      endAngle = startAngle + 2 * PI;
      startAngle = temp;
    }
  } else
  {
    if (endAngle - startAngle < PI )
    {
      float temp = startAngle;
      startAngle = endAngle;
      endAngle = temp + 2 * PI;
    }
  }

  float theta = startAngle;
  float deltaAngle = (endAngle - startAngle)  / point_number;
  for (int i = 0; i < point_number; i++, theta += deltaAngle)
  {
    float x = circle.C.x + circle.r * cos(theta);
    float y = circle.C.y + circle.r * sin(theta);
    pointSet[i] = new pt();
    pointSet[i].x = x;
    pointSet[i].y = y;
  }
}

class Hyperbola
{
  float square_a, square_b, square_c;
  boolean isright; // decide left or right curve of Hyperbola;
  Hyperbola() {
  };
  Hyperbola(float square_a_, float square_b_, float square_c_) {
    square_a = square_a_; 
    square_b = square_b_; 
    square_c = square_c_;
  }

  void setHyperbola(float square_a_, float square_b_, float square_c_) {
    square_a = square_a_; 
    square_b = square_b_; 
    square_c = square_c_;
  }

  void pointSetInHyperbola(pt [] pointSet, pt point_a, pt point_b)
  {

    float a = sqrt(square_a);
    float b = sqrt(square_b);

    float startAngle = atan2((point_a.y * a) / (b * point_a.x), a / point_a.x);
    float endAngle = atan2((point_b.y * a) / (b * point_b.x), a / point_b.x);


    if (endAngle < startAngle)
    {
      float temp = endAngle;
      endAngle = startAngle;
      startAngle = temp;
    }

    if (endAngle - startAngle > PI)
    {
      float temp = endAngle;
      endAngle = startAngle + 2 * PI;
      startAngle = temp;
    }

    if (startAngle < PI / 2.0f && startAngle > -PI / 2.0f)
    {
      isright = true;
    } else
    {
      isright = false;
    }

    float theta = startAngle;
    float deltaAngle = (endAngle - startAngle)  / divisionNumber;
    for (int i = 0; i < divisionNumber; i++, theta += deltaAngle)
    {
      pointSet[i] = new pt();
      float x = sqrt(square_a) / cos(theta);
      float y = sqrt(square_b) * tan(theta);
      pointSet[i].x = x;
      pointSet[i].y = y;
    }
  }
}

class Ellipse
{
  float square_a, square_b, square_c;
  Ellipse() {
  };
  Ellipse(float square_a_, float square_b_, float square_c_) {
    square_a = square_a_; 
    square_b = square_b_; 
    square_c = square_c_;
  }

  void pointSetInEllipse(pt [] pointSet, pt point_a, pt point_b)
  {
    float a = sqrt(square_a);
    float b = sqrt(square_b);

    //vec vector_CLS = new vec(changed_S.x ,changed_S.y );
    // vec vector_CLE = new vec(changed_E.x ,changed_E.y );
    float startAngle = atan2(point_a.y / b, point_a.x / a);
    float endAngle = atan2(point_b.y / b, point_b.x / a);

    if (endAngle < startAngle)
    {
      float temp = endAngle;
      endAngle = startAngle;
      startAngle = temp;
    }

    if (endAngle - startAngle > PI)
    {
      float temp = endAngle;
      endAngle = startAngle + 2 * PI;
      startAngle = temp;
    }



    float theta = startAngle;
    float deltaAngle = (endAngle - startAngle)  / divisionNumber;
    for (int i = 0; i < divisionNumber; i++, theta += deltaAngle)
    {
      pointSet[i] = new pt();
      float x = sqrt(square_a) * cos(theta);
      float y = sqrt(square_b) * sin(theta);
      pointSet[i].x = x;
      pointSet[i].y = y;
    }
  }
}

class Line
{
  float k, b;
  boolean isperpendicular;
  float x_value; // x = x_value when isperpendicular is true
  Line()
  {
    k = 1;
    b = 1;
  };
  Line(float k_, float b_)
  {
    k = k_;
    b = b_;
  }

  void figureoutLine(pt point_a, pt point_b)
  {
    if (abs(point_b.x - point_a.x) < 0.0001)
    {
      isperpendicular = true;
      x_value = point_b.x;
    } else
    {
      isperpendicular = false;
      k = (point_b.y - point_a.y) / (point_b.x - point_a.x);
      b = point_a.y - k * point_a.x;
    }
  }
}
pt intersection_LineAndLine(Line line_a, Line line_b)
{
  pt resultpt = new pt();
  resultpt.x = (line_b.b - line_a.b) / (line_a.k - line_b.k);
  resultpt.y = line_a.k * resultpt.x + line_a.b;

  return resultpt;
}
pt intersection_LineAndHyperbola(Line line_, Hyperbola hyperbola_, int direction)
{


  pt resultpt = new pt();

  /*if(line_.isperpendicular)
   {
   resultpt.x = line_.x_value;
   resultpt.y = direction * sqrt(hyperbola_.square_b * ((line_.x_value * line_.x_value) / hyperbola_.square_a - 1));
   
   return resultpt;
   }*/


  float temp_a = hyperbola_.square_b - hyperbola_.square_a * line_.k * line_.k;
  float temp_b = -2 * hyperbola_.square_a * line_.k * line_.b;
  float temp_c = -1 * hyperbola_.square_b * hyperbola_.square_a - hyperbola_.square_a * line_.b * line_.b;

  if (hyperbola_.isright == true)
    resultpt.x = (-1 * temp_b + sqrt(sq(temp_b) - 4 * temp_a * temp_c) ) / (2 * temp_a);
  else
    resultpt.x = (-1 * temp_b - sqrt(sq(temp_b) - 4 * temp_a * temp_c) ) / (2 * temp_a);

  resultpt.y = line_.k * resultpt.x + line_.b;

  return resultpt;
}

Line figureoutTangentLine(pt circleCenter, pt point_)
{
  Line resultLine;
  resultLine = new Line();


  Line tempLine = new Line();
  tempLine.figureoutLine(circleCenter, point_);

  if (tempLine.isperpendicular)
  {
    resultLine.k = 0;
    resultLine.b = point_.y;

    return resultLine;
  }

  if (abs(tempLine.k) < 0.0001)
  {

    resultLine.isperpendicular = true;
    resultLine.x_value = point_.x;

    return resultLine;
  }


  float k = -1 / tempLine.k;
  float b = point_.y - k * point_.x;

  resultLine = new Line(k, b);

  return resultLine;
}

// intersection of two tangent line of a circle
pt tangentLineIntersection(pt circleCenter, pt point_a, pt point_b) 
{
  pt resultpt;

  Line tangentLineL, tangentLineR;

  tangentLineL = figureoutTangentLine(circleCenter, point_a);
  tangentLineR = figureoutTangentLine(circleCenter, point_b);

  resultpt = intersection_LineAndLine(tangentLineL, tangentLineR);

  return resultpt;
}


//clockwise
vec Rotate(vec vector, float theta)
{
  vec resultvec = new vec();
  Matrix matrix_T = new Matrix();
  matrix_T.setRotation(theta);
  resultvec = Apply(vector, matrix_T);
  return resultvec;
}

Matrix figureoutMatrix(float translate_x, float translate_y, float theta, float translate_x2, float translate_y2)
{
  Matrix translationMat = new Matrix();
  translationMat.setTranslation(translate_x, translate_y);

  Matrix rotationMat = new Matrix();
  rotationMat.setRotation(theta);

  Matrix translationMatAxis = new Matrix();
  translationMatAxis.setTranslation(translate_x2, translate_y2);

  Matrix tempMat = new Matrix();
  tempMat.setMatrix(Apply(translationMat, rotationMat));

  Matrix finalMat = new Matrix();
  finalMat.setMatrix(Apply(tempMat, translationMatAxis));

  return finalMat;
}

//two point in Circle_a but not in Circle_b
boolean sameCirclePos(pt point_a, pt point_b, pt circleL, float rL, pt circleR, float rR)
{
  if (d(point_a, circleL) > rL && d(point_b, circleL) > rL && d(point_a, circleR) < rR && d(point_b, circleR) < rR)
    return true;

  if (d(point_a, circleL) < rL && d(point_b, circleL) < rL && d(point_a, circleR) > rR && d(point_b, circleR) > rR)
    return true;

  return false;
}

void CalculateArc(pt point_A, pt point_S, pt point_E, pt point_B, int leftOrRight)
{

  pt tangentPoint, intersectionPoint;
  vec T = new vec(point_S.x - point_A.x, point_S.y - point_A.y);

  T = Rotate(T, PI / 2.0f);

  if (leftOrRight == 0)
    if (T.x < 0)
      T.scaleBy(-1);

  if (leftOrRight == 0)
    if (T.x > 0)
      T.scaleBy(-1);

  T.normalize();
  float r;

  vec BS = new vec(point_S.x - point_B.x, point_S.y - point_B.y);
  float b = d(point_B, point_E);
  r = ((b * b - dot(BS, BS))) / (2 * dot(BS, T));

  // println(T.x,T.y);

  vec TO = T.scaleBy(r);

  pt temp_S = new pt(point_S.x, point_S.y);
  intersectionPoint = temp_S.add(TO);


  vec BO = new vec(intersectionPoint.x - point_B.x, intersectionPoint.y - point_B.y);
  BO.normalize();
  BO.scaleBy(b);

  float theta = acos(b / d(point_B, intersectionPoint));
  BO = Rotate(BO, theta);

  pt temp_B = new pt(point_B.x, point_B.y);
  tangentPoint = temp_B.add(BO);

  Line line_First = new Line();
  line_First.figureoutLine(point_A, point_S);

  Line line_Second = new Line();
  line_Second.figureoutLine(point_B, tangentPoint);

  pt circleCenter = intersection_LineAndLine(line_First, line_Second);

  //line(circleCenter.x,circleCenter.y,intersectionPoint.x,intersectionPoint.y);
  float radius = d(circleCenter, tangentPoint);

  if (leftOrRight == 0)
  {
    tangentPointL = tangentPoint;
    intersectionPointL = intersectionPoint;
    circleCenterL = circleCenter;
    radiusL = radius;
  } else
  {
    tangentPointR = tangentPoint;
    intersectionPointR = intersectionPoint;
    circleCenterR = circleCenter;
    radiusR = radius;
  }

  //drawCircleArcInHat(point_S, intersectionPoint, tangentPoint);
}

void CreateTangentCircle()
{
  pt S=P.G[0], E=P.G[1], L=P.G[2], R=P.G[3];

//calculate
  CalculateArc(S, L, R, E, 0);
  CalculateArc(E, R, L, S, 1);

//draw
  CIRCLE Cs = C(S, d(S, L)), Ce = C(E, d(E, R));

  vec vec_SL, vec_STL, vec_ER, vec_ETR;
  vec vec_CTL, vec_CL, vec_CTR, vec_CR;

  vec_SL = new vec(L.x - S.x, L.y - S.y);
  vec_STL = new vec(tangentPointL.x - S.x, tangentPointL.y - S.y);

  vec_ER = new vec(R.x - E.x, R.y - E.y);
  vec_ETR = new vec(tangentPointR.x - E.x, tangentPointR.y - E.y);

  vec_CL = new vec(L.x - circleCenterL.x, L.y - circleCenterL.y);
  vec_CTL = new vec(tangentPointL.x - circleCenterL.x, tangentPointL.y - circleCenterL.y);

  vec_CR = new vec(R.x - circleCenterR.x, R.y - circleCenterR.y);
  vec_CTR = new vec(tangentPointR.x - circleCenterR.x, tangentPointR.y - circleCenterR.y);

  if (angle(vec_SL, vec_STL) < 0 )
  {
    pointSetonCircle(pointSetCircleArcL, L, tangentPointR, Cs, false);
  } else
  {
    pointSetonCircle(pointSetCircleArcL, L, tangentPointR, Cs, true);
  }

  if (angle(vec_ER, vec_ETR) < 0 )
  {
    pointSetonCircle(pointSetCircleArcR, R, tangentPointL, Ce, false);
  } else
  {
    pointSetonCircle(pointSetCircleArcR, R, tangentPointL, Ce, true);
  }


  CIRCLE tangentCircleR = new CIRCLE(circleCenterR, radiusR);
  CIRCLE tangentCircleL = new CIRCLE(circleCenterL, radiusL);

  if (angle(vec_CL, vec_CTL) < 0 )
  {
    //pointSetinCircle(pointSetCircleArcR,R,tangentPointL,Ce,false);
    pointSetonCircle(pointSetTanCircleL, L, tangentPointL, tangentCircleL, true);
  } else
  {
    //pointSetinCircle(pointSetCircleArcR,R,tangentPointL,Ce,true);
    pointSetonCircle(pointSetTanCircleL, L, tangentPointL, tangentCircleL, false);
  }

  if (angle(vec_CR, vec_CTR) < 0 )
  {
    pointSetonCircle(pointSetTanCircleR, R, tangentPointR, tangentCircleR, true);
  } else
  {
    pointSetonCircle(pointSetTanCircleR, R, tangentPointR, tangentCircleR, false);
  }

  for (int i = 0; i < point_number; i++)
    areaW[i] = pointSetCircleArcL[i];

  for (int i = point_number; i < 2 * point_number; i++)
    areaW[i] = pointSetTanCircleR[2 * point_number - 1 - i];

  for (int i = 2 * point_number; i < 3 * point_number; i++)
    areaW[i] = pointSetCircleArcR[i - 2 * point_number];

  for (int i = 3 * point_number; i < 4 * point_number; i++)
    areaW[i] = pointSetTanCircleL[4 * point_number - 1 - i];

// Fill Color
  areaWP = createShape();
  areaWP.beginShape();
  areaWP.noStroke();
  areaWP.fill(200, 200, 200);
  for (int i = 0; i < 4 * point_number; i++)
  areaWP.vertex(areaW[i].x, areaW[i].y);
  areaWP.endShape(CLOSE);
  shape(areaWP);


// draw arc in different colors
  pointSetTanCircleR[0] = R;
  pointSetTanCircleR[point_number - 1] = tangentPointR;

  pointSetTanCircleL[0] = L;
  pointSetTanCircleL[point_number - 1] = tangentPointL;

  pointSetCircleArcL[0] = L;
  pointSetCircleArcL[point_number - 1] = tangentPointR;

  pointSetCircleArcR[0] = R;
  pointSetCircleArcR[point_number - 1] = tangentPointL;

  noFill();
  strokeWeight(2);
  stroke(dgreen);
  beginShape();
  for (int i = 0; i < point_number; i++)
    vertex(pointSetCircleArcL[i].x, pointSetCircleArcL[i].y);
  endShape();

  stroke(red);
  beginShape();
  for (int i = 0; i < point_number; i++)
    vertex(pointSetCircleArcR[i].x, pointSetCircleArcR[i].y);
  endShape();

  strokeWeight(5);
  stroke(brown);
  beginShape();
  for (int i = 0; i < point_number; i++)
    vertex(pointSetTanCircleR[i].x, pointSetTanCircleR[i].y);
  endShape();

  stroke(grey);
  beginShape();
  for (int i = 0; i < point_number; i++)
    vertex(pointSetTanCircleL[i].x, pointSetTanCircleL[i].y);
  endShape();
}
//calculate medial Axis 
void CreateMedialAxis()
{

  pt S=P.G[0], E=P.G[1], L=P.G[2], R=P.G[3];
  vec vector_LR = new vec(circleCenterR.x - circleCenterL.x, circleCenterR.y - circleCenterL.y);
  float theta = angle(vector_LR);

  Matrix finalMat = figureoutMatrix(-circleCenterL.x, -circleCenterL.y, -theta, -d(circleCenterL, circleCenterR)/2.0f, 0);

  Matrix finalMat_inv = figureoutMatrix(d(circleCenterL, circleCenterR)/2.0f, 0, theta, circleCenterL.x, circleCenterL.y);

  pt changed_circleCenterL, changed_circleCenterR, changed_S, changed_E;

  changed_circleCenterL = Apply(circleCenterL, finalMat);
  changed_circleCenterR = Apply(circleCenterR, finalMat);
  changed_S = Apply(S, finalMat);
  changed_E = Apply(E, finalMat);


  float square_a, square_b, square_c;

  square_c = d2(changed_circleCenterL, changed_circleCenterR) * 0.25f;

  pt [] pointset = new pt [divisionNumber];

  if ( abs(( d(S, circleCenterL) + d(S, circleCenterR) ) - (radiusL + radiusR)) < 0.01 && 
    abs(( d(E, circleCenterL) + d(E, circleCenterR) ) - (radiusL + radiusR)) < 0.01
    && sameCirclePos(S, E, circleCenterL, radiusL, circleCenterR, radiusR))
  {

    square_a = pow((d(S, circleCenterL) + d(S, circleCenterR)) / 2.0f, 2);
    square_b = square_a - square_c;

    Ellipse temp_ellipse = new Ellipse(square_a, square_b, square_c); 

    temp_ellipse.pointSetInEllipse(pointset, changed_S, changed_E);

    println("ellipse");

    for (int i = 0; i < divisionNumber; i++)
    {
      pointset[i] = Apply(pointset[i], finalMat_inv);
    }
    beginShape();

    for (int i = 0; i < divisionNumber; i++)
    {
      vertex(pointset[i].x, pointset[i].y);
    }
    endShape();

    //circle part
    line(pointSetCircleArcL[point_number / 2].x, pointSetCircleArcL[point_number / 2].y, S.x, S.y);
    line(pointSetCircleArcR[point_number / 2].x, pointSetCircleArcR[point_number / 2].y, E.x, E.y);
    
  } else if ( abs(abs(d(S, circleCenterL) - d(S, circleCenterR)) - abs(radiusL - radiusR)) < 0.01
    && abs(abs(d(E, circleCenterL) - d(E, circleCenterR)) - abs(radiusL - radiusR)) < 0.01
    && (abs(d(E, circleCenterR) - d(S, circleCenterR)) - abs(d(S, L)-d(E, R))) < 0.01)
  {


    square_a = pow((d(S, circleCenterL) - d(S, circleCenterR)) / 2.0f, 2);
    square_b = square_c - square_a;


    Hyperbola temp_hyperbola = new Hyperbola(square_a, square_b, square_c); 

    temp_hyperbola.pointSetInHyperbola(pointset, changed_S, changed_E);

    for (int i = 0; i < divisionNumber; i++)
    {
      pointset[i] = Apply(pointset[i], finalMat_inv);
    }


    beginShape();

    for (int i = 0; i < divisionNumber; i++)
    {
      vertex(pointset[i].x, pointset[i].y);
    }
    endShape();

    //circle part
    line(pointSetCircleArcL[point_number / 2].x, pointSetCircleArcL[point_number / 2].y, S.x, S.y);
    line(pointSetCircleArcR[point_number / 2].x, pointSetCircleArcR[point_number / 2].y, E.x, E.y);
    println("hyperbola0");
  } 
  else
  {
    println("Special Condition");
  }
}