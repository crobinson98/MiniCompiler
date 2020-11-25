//Chedva Broder 315075317
//Chaya Robinson 323561282


import system;
import system'io;
import extensions;
import system'text;
import system'collections;
import system'routines;
import extensions'text;
import extensions'routines;


static keywords = new Variable();
static mySymbol = new Variable();
static myI = new Variable();
     
public tokenizer(var myDirectory, var myJackFile,var txmlFile)
{

    var fileNameReader := myJackFile;
    var fileNameWriter := txmlFile;
    
 
    // opening a text file reader
    using(auto reader := File.assign(fileNameReader).textreader())
    {
        
        var i :=0;
        var j :=0;
        // repeating until all the lines are read 
        while (reader.Available)
        {
             i:=0;
            // read the line
            string line := reader.readLine();//console.printLine(line);//console.readChar();
            while(i<line.Length)
            {
                if(line[i]=="/"){//comment, divide, 
                    if(line[i+1]=="/"){
                        line := reader.readLine();
                        i := 0;
                    }
                    else{
                        if(line[i+1]=="*"){
                            while(line[line.Length-1]!="/"||(line[line.Length-2]!="*")){
                                line:=reader.readLine();
                            };
                            line:=reader.readLine();
                            i:=0;
                        }
                        else{
                            using(auto writer := File.assign(fileNameWriter).logger())
                            writer.writeLine("<symbol> "+line[i]+" </symbol>");
                            i+=1;
                        }
                    }
                    
                }
                else{
                    if(line[i].toInt()==9){//tab
                        if(line.Length==1){//empty line
                            line:=reader.readLine();
                        }
                        else{
                            i+=1;
                        }
                    };
                    if(line[i]==" "){//space
                        i+=1;
                    };
                    if(line[i].toInt()==95||(line[i].toInt()>64 && line[i].toInt()<91)||(line[i].toInt()>96&&line[i].toInt()<123)){//keyword or identifier
                        var flag:=true;
                        j:=i;
                        while(flag){
                            i := i+1;
                            if(line[i].toInt()!=95&&(line[i].toInt()>64 && line[i].toInt()<91)==false&&(line[i].toInt()>96&&line[i].toInt()<123)==false)//word
                            {
                                flag := false;
                            };
                        
                        };
                        if(inArrayKey(line.Substring(j,i-j))){//keyword
                            using(auto writer := File.assign(fileNameWriter).logger())
                            writer.writeLine("<keyword> "+line.Substring(j,i-j)+" </keyword>");
                        }
                        else{//identifier
                            using(auto writer := File.assign(fileNameWriter).logger())
                            writer.writeLine("<identifier> "+line.Substring(j,i-j)+" </identifier>");
                            };
                       
                    }
                    else{
                        if(inArraySym(line[i])){//symbol
                            if(line[i]==">"){
                                using(auto writer := File.assign(fileNameWriter).logger())
                                writer.writeLine("<symbol> &gt; </symbol>");
                            }
                            else{
                                if(line[i]=="<"){
                                    using(auto writer := File.assign(fileNameWriter).logger())
                                    writer.writeLine("<symbol> &lt; </symbol>");
                                }
                                else{
                                    if(line[i]=="&"){
                                        using(auto writer := File.assign(fileNameWriter).logger())
                                        writer.writeLine("<symbol> &amp; </symbol>");
                                    }
                                    else{
                                        using(auto writer := File.assign(fileNameWriter).logger())
                                        writer.writeLine("<symbol> "+line[i]+" </symbol>");
                                    }
                                }
                                
                            };
                            i+=1;
                        }
                        else{
                            if(line[i].toInt()>47 && line[i].toInt()<58){//number
                                var flag := true;
                                j := i;
                                while(flag){
                                    i+=1;
                                    if((line[i].toInt()>47 && line[i].toInt()<58)==false)
                                    {
                                        flag := false;
                                    };
                                };
                                using(auto writer := File.assign(fileNameWriter).logger())
                                writer.writeLine("<integerConstant> "+line.Substring(j,i-j)+" </integerConstant>");
                
                            }
                            else{
                                if(line[i].toInt()==34){//quets
                                    j:=i;
                                    var flag := true;
                                    while(flag){
                                        i+=1;
                                        if(line[i].toInt()==34){
                                            flag := false;
                                        };
                        
                                    };
                                    i+=1;
                                    using(auto writer := File.assign(fileNameWriter).logger())
                                    writer.writeLine("<stringConstant> "+line.Substring(j+1,i-j-2)+" </stringConstant>");
                                }
                            }
                        }
                    }
                            
                }
                       
            };
        
        };

    };
}




public inArrayKey(var str){
    for (int i:=0,i<21,i+=1){
        if(keywords[i]==str){
            ^true;};
    };
    ^false;
}

public inArraySym(var str){
    for (int i:=0,i<18,i+=1){
        if(mySymbol[i]==str){
            ^true;};
    };
    ^false;
}


//program structure
public myClass(var xmlFile,var txmlFile)
{
    var n := forward newLine.toString();

     
     if(txmlFile[myI+1]=="class"){
         using(auto writer := File.assign(xmlFile).logger())
         writer.writeLine("<class>"+n+txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
         +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]
         +n+txmlFile[myI.Value+6]+" "+txmlFile[myI.Value+7]+" "+txmlFile[myI.Value+8]);//<class> name </class> <idenfier> name </identifier> <symbol> { </symbol>
        myI.Value:=myI.Value+9;
        classVarDec(xmlFile,txmlFile);
        subroutineDec(xmlFile,txmlFile);
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]+n+"</class>"); //<symbol> } </symbol>
        myI.Value:=myI.Value+3;
    };
}


public classVarDec(var xmlFile, var txmlFile)
{
    var n := forward newLine.toString();
    
    while(txmlFile[myI.Value+1]=="static"||(txmlFile[myI.Value+1]=="field")){
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine("<classVarDec>");
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]//<> static/field</>
        +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]//<> type </>
        +n+txmlFile[myI.Value+6]+" "+txmlFile[myI.Value+7]+" "+txmlFile[myI.Value+8]); //<> name </>
        myI.Value:=myI.Value+9;
        while(txmlFile[myI.Value+1]==","){ //(, varName)*
            using(auto writer := File.assign(xmlFile).logger())
            writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
            +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);
            myI.Value:=myI.Value+6;
        };
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//;
        myI.Value:=myI.Value+3;
        
        using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("</classVarDec>");
        
    };
    
    
}



public subroutineDec(var xmlFile, var txmlFile)
{
    var n := forward newLine.toString();
   
    
    while(txmlFile[myI.Value+1]=="constructor"||(txmlFile[myI.Value+1]=="function")||(txmlFile[myI.Value+1]=="method")){
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine("<subroutineDec>");
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
        +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]
        +n+txmlFile[myI.Value+6]+" "+txmlFile[myI.Value+7]+" "+txmlFile[myI.Value+8]
        +n+txmlFile[myI.Value+9]+" "+txmlFile[myI.Value+10]+" "+txmlFile[myI.Value+11]); //c|f|m void|type name(
        myI.Value:=myI.Value+12;
        parameterList(xmlFile, txmlFile);
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);///')'
        myI.Value:=myI.Value+3;
        subroutineBody(xmlFile, txmlFile);
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine("</subroutineDec>");
    };
    
}

public parameterList(var xmlFile, var txmlFile)
{
    var n := forward newLine.toString();
    
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<parameterList>");
    if(txmlFile[myI.Value+1]!=")"){
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
        +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]); //type name
        myI.Value:=myI.Value+6;
    };
    while(txmlFile[myI.Value+1]!=")")
    {
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
        +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]
        +n+txmlFile[myI.Value+6]+" "+txmlFile[myI.Value+7]+" "+txmlFile[myI.Value+8]);
        myI.Value:=myI.Value+9;
    };
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("</parameterList>");
    
}

public subroutineBody(var xmlFile,var txmlFile)
{
    
    var n := forward newLine.toString();
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<subroutineBody>"+n+txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//<> { </>
    myI.Value:=myI.Value+3;
    varDec(xmlFile, txmlFile);
    statements(xmlFile, txmlFile);
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]+n+"</subroutineBody>");
    myI.Value:=myI.Value+3;   
}

public varDec(var xmlFile, var txmlFile)
{
    
    var n := forward newLine.toString();
    
    while(txmlFile[myI.Value+1]=="var"){
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine("<varDec>");
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]//<> var </>
        +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]
        +n+txmlFile[myI.Value+6]+" "+txmlFile[myI.Value+7]+" "+txmlFile[myI.Value+8]);
        myI.Value:=myI.Value+9;
    
        while(txmlFile[myI.Value+1]==","){
            using(auto writer := File.assign(xmlFile).logger())
            writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]//, name
            +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);
            myI.Value:=myI.Value+6;
        };
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]+n+"</varDec>");  //;
        myI.Value:=myI.Value+3;
    };   
}



//statements
public statements(var xmlFile,var txmlFile){
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<statements>");
    statement(xmlFile, txmlFile);
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("</statements>");
}
public statement(var xmlFile,var txmlFile)
{
    while(txmlFile[myI.Value+1]=="while"||(txmlFile[myI.Value+1]=="if")||(txmlFile[myI.Value+1]=="let")||
    (txmlFile[myI.Value+1]=="do")||(txmlFile[myI.Value+1]=="return")){
        if(txmlFile[myI.Value+1] == "let")
            {
                letStatement(xmlFile, txmlFile);
            }
            else{
                if(txmlFile[myI.Value+1] == "if"){
                    ifStatement(xmlFile, txmlFile);
                }
                else{
                    if( txmlFile[myI.Value+1] == "while"){
                        whileStatement(xmlFile, txmlFile);
                    }
                    else{
                        if(txmlFile[myI.Value+1] == "do"){
                            doStatement(xmlFile, txmlFile);
                        }
                        else{
                            if(txmlFile[myI.Value+1] == "return"){
                                returnStatement(xmlFile, txmlFile);
                            }
                        }
                      
                    }
                }
            }
        };  
}


public letStatement(var xmlFile,var txmlFile)
{
    
    var n := forward newLine.toString();
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<letStatement>"+n+txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
    +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);
    myI.Value:=myI.Value+6;
    if(txmlFile[myI.Value+1] =="[") 
    {
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//[
        myI.Value:=myI.Value+3;
        expression(xmlFile, txmlFile);
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//]
        myI.Value:=myI.Value+3;
    };
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//=
    myI.Value:=myI.Value+3;
    expression(xmlFile, txmlFile);
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]+n+"</letStatement>");//;
    myI.Value:=myI.Value+3;
    
}



public ifStatement(var xmlFile,var txmlFile)
{
    
    var n := forward newLine.toString();
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<ifStatement>"+n+txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
    +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);//if (
    myI.Value:=myI.Value+6;
    expression(xmlFile, txmlFile);
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
    +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);//){
    myI.Value:=myI.Value+6;
    statements(xmlFile, txmlFile);
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//}
    myI.Value:=myI.Value+3; 
    if(txmlFile[myI.Value+1]=="else")
    {
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
        +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);//else {
        myI.Value:=myI.Value+6;
        statements(xmlFile, txmlFile);
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//}
        myI.Value:=myI.Value+3;
    };
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(" </ifStatement>");   
}



public whileStatement(var xmlFile,var txmlFile)
{
    
    var n := forward newLine.toString();
    
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<whileStatement>"+n+txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
    +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);//(
    myI.Value:=myI.Value+6;
    expression(xmlFile, txmlFile);
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
    +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);//){
    myI.Value:=myI.Value+6;
    statements(xmlFile, txmlFile);
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]+n+"</whileStatement>");
    myI.Value:=myI.Value+3;  

}




public doStatement(var xmlFile,var txmlFile)
{
    
    var n := forward newLine.toString();
    
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<doStatement>"+n+txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//do
    myI.Value:=myI.Value+3;
    subroutineCall(xmlFile, txmlFile);
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]+n+" </doStatement>");//;
    myI.Value:=myI.Value+3;
    
}



public returnStatement(var xmlFile,var txmlFile)
{
    
    var n := forward newLine.toString();
    
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<returnStatement>"+n+txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//return
    myI.Value:=myI.Value+3;
    if(txmlFile[myI.Value+1]!=";"){
        expression(xmlFile, txmlFile);
    };
    
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]+n+" </returnStatement>");//;
    myI.Value:=myI.Value+3;
   
}


public expression(var xmlFile,var txmlFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<expression>");
    term(xmlFile, txmlFile);
    while(inOp(txmlFile[myI.Value+1])){
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//(
        myI.Value:=myI.Value+3;
        term(xmlFile, txmlFile);
        /*console.printLine(txmlFile[myI.Value+1]);
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//)
        myI.Value:=myI.Value+3;*/
        
    };
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("</expression>");
}




public term(var xmlFile,var txmlFile)
{
    
    var n := forward newLine.toString();
    
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<term>");
    if(txmlFile[myI.Value]=="<integerConstant>"||(txmlFile[myI.Value]=="<keyword>"))
    {
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);
        myI.Value:=myI.Value+3;
    }
    else{
        if(txmlFile[myI.Value]=="<stringConstant>"){
            string temp:="";
            while(txmlFile[myI.Value]!="</stringConstant>"){
                temp:=temp+txmlFile[myI.Value]+" ";
                myI.Value:=myI.Value+1;
            };
            temp:=temp+txmlFile[myI.Value];
            myI.Value:=myI.Value+1;
            using(auto writer := File.assign(xmlFile).logger())
            writer.writeLine(temp);
        }
    
        else{
            if(txmlFile[myI.Value]=="<identifier>"&& txmlFile[myI.Value+4]=="[")
            {
                using(auto writer := File.assign(xmlFile).logger())
                writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
                +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);//varName [
                myI.Value:=myI.Value+6;
                expression(xmlFile, txmlFile);
                using(auto writer := File.assign(xmlFile).logger())
                writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//]
                myI.Value:=myI.Value+3;
            }
            else{
                if(txmlFile[myI.Value]=="<identifier>"&& txmlFile[myI.Value+4]=="("||(txmlFile[myI.Value]=="<identifier>"&& txmlFile[myI.Value+4]=="."))  //suroutieCall !!!!!!
                {
                    subroutineCall(xmlFile, txmlFile);
                }
                else{
                    if(txmlFile[myI.Value]=="<identifier>") //varName
                    {
                        using(auto writer := File.assign(xmlFile).logger())
                        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);   
                        myI.Value:=myI.Value+3;
                   }
                   else{
                       if(txmlFile[myI.Value+1]=="(") // (expression)
                       {
                            using(auto writer := File.assign(xmlFile).logger())
                            writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);   //(
                            myI.Value:=myI.Value+3;
                            expression(xmlFile, txmlFile);
                            using(auto writer := File.assign(xmlFile).logger())
                            writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);   //)
                            myI.Value:=myI.Value+3;
                            
                       }
                       else{
                           if(txmlFile[myI.Value+1]=="-"||(txmlFile[myI.Value+1]=="~")) //unary op
                           {
                               using(auto writer := File.assign(xmlFile).logger())
                               writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);
                               myI.Value:=myI.Value+3;
                               term(xmlFile, txmlFile);
                           }
                           
                       }
                   }
                }
            }
            
            
        }
    };
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("</term>");    
}


public subroutineCall(var xmlFile,var txmlFile)
{
    
    var n := forward newLine.toString();
    
    
    if(txmlFile[myI.Value+4]=="."){
        using(auto writer := File.assign(xmlFile).logger())
        writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
            +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);//name.
        myI.Value:=myI.Value+6;
    };
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]
    +n+txmlFile[myI.Value+3]+" "+txmlFile[myI.Value+4]+" "+txmlFile[myI.Value+5]);//name(
    myI.Value:=myI.Value+6;
    expressionList(xmlFile, txmlFile);
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);//)
    myI.Value:=myI.Value+3;
  
}
        


public expressionList(var xmlFile,var txmlFile)
{
    
    var n := forward newLine.toString();
    
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("<expressionList>");
    if(txmlFile[myI.Value+1]!=")"){
        expression(xmlFile, txmlFile);
            
        while(txmlFile[myI.Value+1] == ",")
        {
            using(auto writer := File.assign(xmlFile).logger())
            writer.writeLine(txmlFile[myI.Value]+" "+txmlFile[myI.Value+1]+" "+txmlFile[myI.Value+2]);
            myI.Value:=myI.Value+3;
            expression(xmlFile, txmlFile);
            
        }
    };   
    using(auto writer := File.assign(xmlFile).logger())
    writer.writeLine("</expressionList>");    
    
}





public inOp(var str)
{
    if(str=="+"||(str=="-")||(str=="*")||(str=="/")||(str=="&amp;")||(str=="|")||(str=="&lt;")||(str=="&gt;")||(str=="=")){
        ^true;
    };
    ^false;
}



public parsing(var xmlFile,var txmlFile){
    
    myI.Value:=1;
    //var n := forward newLine.toString();
    // repeating until all the lines are read 
    //while (line!="</tokens>")
    //{
        // read the line
        myClass(xmlFile, txmlFile);
       
        
    //}

}







public findJackfiles(var path)
{ 
    var dir := Directory.assign(path);
    var files := dir.getFiles();
    
    for(var j := 0,j<files.Length,j+=1)
    {
        //console.readChar();
        if(files[j][files[j].Length-1]=="k" && files[j][files[j].Length-2]=="c"&&files[j][files[j].Length-3]=="a")
        {
            var txmlFile := files[j].Substring(0,files[j].Length-5)+"T1.xml";
            using(auto writer := File.assign(txmlFile).logger())
            writer.writeLine("<tokens>");
            tokenizer(path,files[j],txmlFile);
            using(auto writer := File.assign(txmlFile).logger())
            writer.writeLine("</tokens>");
            //var xmlFile := files[j].Substring(0,files[j].Length-5)+"1.xml";
            //parsing(xmlFile,txmlFile);
        };
    };
}

           

public findT1xmlfiles(var path)
{ 
    var dir := Directory.assign(path);
    var files := dir.getFiles();
    
    for(var j := 0,j<files.Length,j+=1)
    {
        //console.readChar();
        if(files[j][files[j].Length-1]=="l" && files[j][files[j].Length-2]=="m"&&files[j][files[j].Length-5]=="1")
        {
            var xmlFile := files[j].Substring(0,files[j].Length-6)+"1.xml";
            string temp:=convertFileToString(files[j]);
            var temp1:=temp.splitBy(" ");
            parsing(xmlFile,temp1);
        };
    };
}                      
                                 
                                            
public convertFileToString(var myFile){

    string line:=""; 
    // opening a text file reader
    using(auto reader := File.assign(myFile).textreader())
    {
        
        // repeating until all the lines are read 
        while (reader.Available)
        {
            // read the line
            line := line+reader.readLine()+" ";
        };
    };
    ^line;
}                                                                  



 




public program()
{
    //delete files
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\ArrayTest\MainT1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\ExpressionLessSquare\MainT1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\ExpressionLessSquare\SquareT1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\ExpressionLessSquare\SquareGameT1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\Square\MainT1.xml").delete();
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\Square\SquareT1.xml").delete();
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\Square\SquareGameT1.xml").delete();
    
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\ArrayTest\Main1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\ExpressionLessSquare\Main1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\ExpressionLessSquare\Square1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\ExpressionLessSquare\SquareGame1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\Square\Main1.xml").delete();
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\Square\Square1.xml").delete();
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\Square\SquareGame1.xml").delete();

    //labels
    keywords.Value := new string[]{"class","constructor","function","method","field","static","var","int","char"
    ,"boolean","void","true","false","null","this","let","do","if","else","while","return"};
    mySymbol.Value := new string[]{"{","}","(",")","[","]",".",",",";","+","-","*","&","|","<",">","=","~"};
   
    
    var myDirectory := system'Array.allocate:3;
    myDirectory[0] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\ArrayTest";
    myDirectory[1] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\ExpressionLessSquare";
    myDirectory[2] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\New folder\10\Square";
    
    
    
   
 
    for(var j :=0,j<myDirectory.Length,j+=1)
    {//console.print(j);
        findJackfiles(myDirectory[j]);
    };
    
    for(var k :=0,k<myDirectory.Length,k+=1)
    {
        findT1xmlfiles(myDirectory[k]);
    };

    console.printLine("finished");
    console.readChar();
}

