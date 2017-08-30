// Place student's code here
// Student's names:
// Date last edited:
/* Functionality provided (say what works):

*/

pt circleCenterL,circleCenterR;
pt tangentPointL,tangentPointR;
pt intersectionPointL,intersectionPointR;
float radiusL,radiusR;
final int divisionNumber = 2000;
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
   for(int i = 0; i < 3; i++)
     for(int j = 0; j < 3; j++)
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
 
 void setRotation(float costheta,float sintheta)
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
 
 
 void setTranslation(float x,float y)
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
  for(int i = 0; i < 3; i++)
    for(int j = 0; j < 3; j++)
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
  for(int i = 0; i < 3; i++)
  {
    println(mat.value[i][0] + "  " + mat.value[i][1] + "  " + mat.value[i][2]);
  }
}

class Hyperbola
{
  float square_a,square_b,square_c;
  boolean isright; // decide left or right curve of Hyperbola;
  Hyperbola(){};
  Hyperbola(float square_a_,float square_b_,float square_c_){square_a = square_a_; square_b = square_b_; square_c = square_c_;}
  
  void setHyperbola(float square_a_,float square_b_,float square_c_){square_a = square_a_; square_b = square_b_; square_c = square_c_;}
  
  void pointSetInHyperbola(pt [] pointSet,float startAngle,float endAngle)
  {
    if(startAngle < PI / 2.0f && startAngle > -PI / 2.0f)
    {
      isright = true;
    }
    else
    {
      isright = false;
    }
    
    float theta = startAngle;
    float deltaAngle = (endAngle - startAngle)  / divisionNumber;
    for(int i = 0;i < divisionNumber; i++,theta += deltaAngle)
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
  float square_a,square_b,square_c;
  Ellipse(){};
  Ellipse(float square_a_,float square_b_,float square_c_){square_a = square_a_; square_b = square_b_; square_c = square_c_;}
  
  void pointSetInEllipse(pt [] pointSet,float startAngle,float endAngle)
  {
    //startAngle = 0;
    //endAngle = 2 * PI;
    float theta = startAngle;
    float deltaAngle = (endAngle - startAngle)  / divisionNumber;
    for(int i = 0;i < divisionNumber; i++,theta += deltaAngle)
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
  float k,b;
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
 
 void figureoutLine(pt point_a,pt point_b)
 {
   if(abs(point_b.x - point_a.x) < 0.0001)
   {
     isperpendicular = true;
     x_value = point_b.x;
   }
   else
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
pt intersection_LineAndHyperbola(Line line_,Hyperbola hyperbola_,int direction)
{
  
  
  pt resultpt = new pt();
  
   if(line_.isperpendicular)
   {
     resultpt.x = line_.x_value;
     resultpt.y = direction * sqrt(hyperbola_.square_b * ((line_.x_value * line_.x_value) / hyperbola_.square_a - 1));
     
     return resultpt;
   }
     
  
  float temp_a = hyperbola_.square_b - hyperbola_.square_a * line_.k * line_.k;
  float temp_b = -2 * hyperbola_.square_a * line_.k * line_.b;
  float temp_c = -1 * hyperbola_.square_b * hyperbola_.square_a - hyperbola_.square_a * line_.b * line_.b;
  
  if(hyperbola_.isright == true)
  resultpt.x = (-1 * temp_b + sqrt(sq(temp_b) - 4 * temp_a * temp_c) ) / (2 * temp_a);
  else
  resultpt.x = (-1 * temp_b - sqrt(sq(temp_b) - 4 * temp_a * temp_c) ) / (2 * temp_a);
  
  resultpt.y = line_.k * resultpt.x + line_.b;
  
  return resultpt;
  
}

Line figureoutTangentLine(pt circleCenter,pt point_)
{
  Line resultLine;
  resultLine = new Line();
  
  
  Line tempLine = new Line();
  tempLine.figureoutLine(circleCenter,point_);
  
  if(tempLine.isperpendicular)
  {
    resultLine.k = 0;
    resultLine.b = point_.y;
  
     return resultLine;
  }
  
  if(abs(tempLine.k) < 0.0001)
  {
    
    resultLine.isperpendicular = true;
    resultLine.x_value = point_.x;
  
     return resultLine;
  }
  

  float k = -1 / tempLine.k;
  float b = point_.y - k * point_.x;
  
  resultLine = new Line(k,b);
  
  return resultLine;
}
// intersection of two tangent line of a circle
pt tangentLineIntersection(pt circleCenter, pt point_a,pt point_b) 
{
  pt resultpt;
  
  Line tangentLineL,tangentLineR;
 
  tangentLineL = figureoutTangentLine(circleCenter,point_a);
  tangentLineR = figureoutTangentLine(circleCenter,point_b);

  resultpt = intersection_LineAndLine(tangentLineL,tangentLineR);
  
  return resultpt;
}

enum ArcState
{
  externalTangent,
  internalTangent,
  leftInRightOut,
  leftOutRightIn;
  
}

vec Rotate(vec vector,float theta)
{
  vec resultvec = new vec();
   Matrix matrix_T = new Matrix();
   matrix_T.setRotation(theta);
   resultvec = Apply(vector,matrix_T);
   return resultvec;
}

void drawArc(pt point_A,pt point_S, pt point_E,pt point_B,int leftOrRight)
{
  
     pt tangentPoint,intersectionPoint;
     vec T = new vec(point_S.x - point_A.x,point_S.y - point_A.y);
  
     T = Rotate(T,PI / 2.0f);
     
     if(leftOrRight == 0)
      if(T.x < 0)
        T.scaleBy(-1);
        
      if(leftOrRight == 0)
        if(T.x > 0)
         T.scaleBy(-1);
  
      T.normalize();
      float r;
    
      vec BS = new vec(point_S.x - point_B.x,point_S.y - point_B.y);
      float b = d(point_B,point_E);
      r = ((b * b - dot(BS,BS))) / (2 * dot(BS,T));
      
     // println(T.x,T.y);
      
      vec TO = T.scaleBy(r);
      
      pt temp_S = new pt(point_S.x,point_S.y);
      intersectionPoint = temp_S.add(TO);
      
      
      vec BO = new vec(intersectionPoint.x - point_B.x,intersectionPoint.y - point_B.y);
      BO.normalize();
      BO.scaleBy(b);
      
      float theta = acos(b / d(point_B,intersectionPoint));
      BO = Rotate(BO,theta);
      
      pt temp_B = new pt(point_B.x,point_B.y);
      tangentPoint = temp_B.add(BO);
      
      Line line_First = new Line();
      line_First.figureoutLine(point_A,point_S);
      
      Line line_Second = new Line();
      line_Second.figureoutLine(point_B,tangentPoint);
      
      pt circleCenter = intersection_LineAndLine(line_First,line_Second);
      
      //line(circleCenter.x,circleCenter.y,intersectionPoint.x,intersectionPoint.y);
      float radius = d(circleCenter,tangentPoint);
      
      if(leftOrRight == 0)
      {
        tangentPointL = tangentPoint;
        intersectionPointL = intersectionPoint;
        circleCenterL = circleCenter;
        radiusL = radius;
      }
      else
      {
        tangentPointR = tangentPoint;
        intersectionPointR = intersectionPoint;
        circleCenterR = circleCenter;
        radiusR = radius;
      }
      
      drawCircleArcInHat(point_S,intersectionPoint,tangentPoint);
}

void CreateTangentCircle()
{
     pt S=P.G[0], E=P.G[1], L=P.G[2], R=P.G[3];
     
     drawArc(S,L,R,E,0);
     drawArc(E,R,L,S,1);
     
     CreateMedialAxis();     
}

enum CurveType
{
  hyperbola,
  ellipse;
}
void CreateMedialAxis()
{
  pt S=P.G[0], E=P.G[1], L=P.G[2], R=P.G[3];
  
 /* vec vec_SL,vec_ST,vec_ER,vec_ET;

  vec_SL = new vec(L.x - S.x,L.y - S.y);
  vec_ST = new vec(tangentPointL.x - S.x,tangentPointL.y - S.y);
  
  vec_ER = new vec(R.x - E.x,R.y - E.y);
  vec_ET = new vec(tangentPointR.x - E.x,tangentPointR.y - E.y);
  
 // vec vector_L = S(vec_SL,vec_ST,0.5f);
  vec vector_L = ((vec_SL.add(vec_ST)).normalize()).scaleBy(d(S,L));
  
  if(vector_L.x < 0)
    vector_L.scaleBy(-1);
    
  //vec vector_R = S(vec_ER,vec_ET,0.5f);
   vec vector_R = ((vec_ER.add(vec_ET)).normalize()).scaleBy(d(E,R));
  if(vector_R.x > 0)
    vector_R.scaleBy(-1);
  
  pt point_L = new pt(S.x,S.y);
  point_L.add(vector_L);
  
  //println((L.x - S.x) + "   " + (L.y - S.y));
  //println((tangentPointL.x - S.x) + "   " + (tangentPointL.y - S.y));
  //println(vector_L);
  pt point_R = new pt(E.x,E.y);
  point_R.add(vector_R);*/
    
  
  vec vector_LR = new vec(circleCenterR.x - circleCenterL.x,circleCenterR.y - circleCenterL.y);
  float theta = angle(vector_LR);
  
  Matrix translationMat = new Matrix();
  translationMat.setTranslation(-circleCenterL.x,-circleCenterL.y);

  Matrix rotationMat = new Matrix();
  rotationMat.setRotation(-theta);
  
  Matrix translationMatAxis = new Matrix();
  translationMatAxis.setTranslation(-d(circleCenterL,circleCenterR)/2.0f,0);
  
  Matrix tempMat = new Matrix();
  tempMat.setMatrix(Apply(translationMat,rotationMat));
  
  Matrix finalMat = new Matrix();
  finalMat.setMatrix(Apply(tempMat,translationMatAxis));
  
      
    Matrix translationMat_inv = new Matrix();
    translationMat_inv.setTranslation(circleCenterL.x,circleCenterL.y);

    Matrix rotationMat_inv = new Matrix();
    rotationMat_inv.setRotation(theta);
  
    Matrix translationMatAxis_inv = new Matrix();
    translationMatAxis_inv.setTranslation(d(circleCenterL,circleCenterR)/2.0f,0);
  
    Matrix tempMat_inv = new Matrix();
    tempMat_inv.setMatrix(Apply(translationMatAxis_inv,rotationMat_inv));
  
    Matrix finalMat_inv = new Matrix();
    finalMat_inv.setMatrix(Apply(tempMat_inv,translationMat_inv));
  
  
  pt changed_circleCenterL,changed_circleCenterR,changed_S,changed_E;
  
  changed_circleCenterL = Apply(circleCenterL,finalMat);
  changed_circleCenterR = Apply(circleCenterR,finalMat);
  changed_S = Apply(S,finalMat);
  changed_E = Apply(E,finalMat);
  
  CurveType curvetype;
  float square_a,square_b,square_c;
  
  square_c = d2(changed_circleCenterL,changed_circleCenterR) * 0.25f;
  
  pt [] pointset = new pt [divisionNumber];
   // && abs(( d(point_R,circleCenterL) + d(point_R,circleCenterR) ) - (radiusL + radiusR)) < 0.01)
  if( abs(( d(S,circleCenterL) + d(S,circleCenterR) ) - (radiusL + radiusR)) < 0.01 )
  {
    curvetype = CurveType.ellipse;
    square_a = pow((d(S,circleCenterL) + d(S,circleCenterR)) / 2.0f,2);
    square_b = square_a - square_c;
    
    Ellipse temp_ellipse = new Ellipse(square_a,square_b,square_c); 
    
    float a = sqrt(square_a);
    float b = sqrt(square_b);
     
    //vec vector_CLS = new vec(changed_S.x ,changed_S.y );
   // vec vector_CLE = new vec(changed_E.x ,changed_E.y );
    float startAngle = atan2(changed_S.y / b,changed_S.x / a);
    float endAngle = atan2(changed_E.y / b,changed_E.x / a);
   
    if(endAngle < startAngle)
    {
      float temp = endAngle;
      endAngle = startAngle;
      startAngle = temp;
    }
    
    if(endAngle - startAngle > PI)
    {
      float temp = endAngle;
      endAngle = startAngle + 2 * PI;
      startAngle = temp;
    }
    

   // println("S angle: " + angle(vector_CLS) + "   E Angle: " + angle(vector_CLE));
   // println("startAngle: " + startAngle + "   endAngle: " + endAngle);
    
    
    temp_ellipse.pointSetInEllipse(pointset,startAngle,endAngle);
    
   // float test = sqrt(temp_ellipse.square_a) * cos(startAngle);
   // println(pointset[0].x +"  " + changed_S.x + "   " + changed_E.x + "   " + test);
    
    println("ellipse");
    
    for(int i = 0; i < divisionNumber; i++)
    {
      pointset[i] = Apply(pointset[i],finalMat_inv);
    }
    
    
    
    beginShape();
    
    for(int i = 0; i < divisionNumber; i++)
    {
      vertex(pointset[i].x,pointset[i].y);
    }
    endShape();
  }
  else if( abs(abs(d(S,circleCenterL) - d(S,circleCenterR)) - abs(radiusL - radiusR)) < 0.01)
  {
        //&& abs(abs(d(point_R,circleCenterL) - d(point_R,circleCenterR)) - abs(radiusL - radiusR)) < 0.01
    curvetype = CurveType.hyperbola;
    
    square_a = pow((d(S,circleCenterL) - d(S,circleCenterR)) / 2.0f,2);
    square_b = square_c - square_a;
    
    
    Hyperbola temp_hyperbola = new Hyperbola(square_a,square_b,square_c); 
    
    float a = sqrt(square_a);
    float b = sqrt(square_b);
     
    //vec vector_CLS = new vec(changed_S.x ,changed_S.y );
   // vec vector_CLE = new vec(changed_E.x ,changed_E.y );
   
    float startAngle = atan2((changed_S.y * a) / (b * changed_S.x),a / changed_S.x);
    float endAngle = atan2((changed_E.y * a) / (b * changed_E.x),a / changed_E.x);
    
    if(b / radiusL < 1)
    {
       float costheta = b / radiusL;
       float sintheta1 = sqrt(1 - costheta * costheta);
       float sintheta2 = -sqrt(1 - costheta * costheta);
    
       float intersectionAngle1 =  atan2(sintheta1,costheta);
       float intersectionAngle2 =  atan2(sintheta2,costheta);
    }

   
  // println(changed_E.x);
    if(endAngle < startAngle)
    {
      float temp = endAngle;
      endAngle = startAngle;
      startAngle = temp;
    }
    
    if(endAngle - startAngle > PI)
    {
      float temp = endAngle;
      endAngle = startAngle + 2 * PI;
      startAngle = temp;
    }
    

   // println("S angle: " + angle(vector_CLS) + "   E Angle: " + angle(vector_CLE));
   // println("startAngle: " + startAngle + "   endAngle: " + endAngle);
    
    
    temp_hyperbola.pointSetInHyperbola(pointset,startAngle,endAngle);
    
    float test = sqrt(temp_hyperbola.square_a) / cos(startAngle);
    float test2 = sqrt(temp_hyperbola.square_a) / cos(endAngle);
    
  //  println(a / changed_pointR.x + "    " + cos(endAngle));
    
    
   // println(pointset[199].x +"  " + changed_S.x + "   " + changed_E.x + "   " + test + "  " +test2);
    
    for(int i = 0; i < divisionNumber; i++)
    {
      pointset[i] = Apply(pointset[i],finalMat_inv);
    }
    
    
    
    beginShape();
    
    for(int i = 0; i < divisionNumber; i++)
    {
      vertex(pointset[i].x,pointset[i].y);
    }
    endShape();
    
    
    println("hyperbola");
  }
  else
  {
    println("error");
  }


}