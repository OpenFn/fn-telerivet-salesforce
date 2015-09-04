public class CalculatorControler {

public Integer num1{get;set;}
public Integer num2{get;set;}
public Integer total{get;set;}

public List<String> lstPrint{get;set;}


public void Calculate()
{
   total = num1 * num2;
   
}

public pageReference Print()
{
  lstPrint = new List<String>();
   
  for(Integer i = 1;i<= 100;i++)
  {

      If( math.mod(i,5)==0)
      {    lstPrint.add('Nadeem');
      }
      else
      {  
          lstPrint.add(String.ValueOf(i));
      }
  }
    
    return null;

}

 
     
}