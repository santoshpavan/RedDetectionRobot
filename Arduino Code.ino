void setup()
{
  Serial.available(9600);
  
  pinMode(12, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(6,OUTPUT);
}

void loop()
{
  if(Serial.available()>0)
  {
    char a = Serial.read();
    
    if (a == 'f') //forward
    {
      digitalWrite(12, HIGH);
      digitalWrite(10, LOW);
      digitalWrite(8, HIGH);
      digitalWrite(6, LOW);
    }
    
    if (a == 'b') //forward
    {
      digitalWrite(12, LOW);
      digitalWrite(10, HIGH);
      digitalWrite(8, LOW);
      digitalWrite(6, HIGH);
    }
    
    if (a == 'r') //right
    {
      digitalWrite(12, LOW);
      digitalWrite(10, HIGH);
      digitalWrite(8, HIGH);
      digitalWrite(6, LOW);
    }
    
    if (a == 'b') //left
    {
      digitalWrite(12, HIGH);
      digitalWrite(10, LOW);
      digitalWrite(8, LOW);
      digitalWrite(6, HIGH);
    }
  }
}