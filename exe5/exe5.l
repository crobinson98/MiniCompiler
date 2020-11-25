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
static staticCount = new Variable();
static fieldCount = new Variable();
static argumentCount = new Variable();
static varCount = new Variable();
static myClassName = new Variable();
static myIfIndex = new Variable();
static myWhileIndex = new Variable();
static subRoutineName = new Variable();

     
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
            string line := reader.readLine();
            while(i<line.Length)
            {
                if(line[i]=="/"){//comment, divide,
                    if(line[i+1]=="/"){
                        line := reader.readLine();
                        i := 0;
                    }
                    else if(line[i+1]=="*"){
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
                else if(line[i].toInt()==9){//tab
                    if(line.Length==1){//empty line
                        line:=reader.readLine();
                    }
                    else 
                        i+=1;
                    }
                else if(line[i]==" "){//space
                        i+=1;
                    }
                else if(line[i].toInt()==95||(line[i].toInt()>64 && line[i].toInt()<91)||(line[i].toInt()>96&&line[i].toInt()<123)){//keyword or identifier
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
                else if(inArraySym(line[i])){//symbol
                            if(line[i]==">"){
                                using(auto writer := File.assign(fileNameWriter).logger())
                                writer.writeLine("<symbol> &gt; </symbol>");
                            }
                            else if(line[i]=="<"){
                                    using(auto writer := File.assign(fileNameWriter).logger())
                                    writer.writeLine("<symbol> &lt; </symbol>");
                                }
                            else if(line[i]=="&"){
                                        using(auto writer := File.assign(fileNameWriter).logger())
                                        writer.writeLine("<symbol> &amp; </symbol>");
                                    }
                            else{
                                using(auto writer := File.assign(fileNameWriter).logger())
                                        writer.writeLine("<symbol> "+line[i]+" </symbol>");
                            };
                            i+=1;
                     }
                 else if(line[i].toInt()>47 && line[i].toInt()<58){//number
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
                 else if(line[i].toInt()==34){//quets
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
public myClass(var txmlFile,var myVmFile,var classSymbolTable)
{
    staticCount.Value :=0;
    fieldCount.Value :=0;
    myClassName.Value := txmlFile[myI.Value+4];

     if(txmlFile[myI+1]=="class"){
        myI.Value:=myI.Value+9;
        classVarDec(txmlFile,classSymbolTable);
        subroutineDec(txmlFile,myVmFile,classSymbolTable);
        myI.Value:=myI.Value+3;
    };
}


public classVarDec(var txmlFile,var classSymbolTable)
{
    
    var n := forward newLine.toString();
    var type;
    var kind;
    string temp;
    while(txmlFile[myI.Value+1]=="static"||(txmlFile[myI.Value+1]=="field")){
        
        type:=txmlFile[myI.Value+4];
        kind := txmlFile[myI.Value+1];
        temp:=txmlFile[myI.Value+7];  classSymbolTable.append:temp;
        temp := txmlFile[myI.Value+4];  classSymbolTable.append:temp;
        temp := txmlFile[myI.Value+1];  classSymbolTable.append:temp;
        
        if(txmlFile[myI.Value+1]=="static"){
            temp := staticCount.Value.toString(); classSymbolTable.append:temp;
            staticCount.Value := staticCount.Value+1;
        }
        else{
            temp := fieldCount.Value.toString(); classSymbolTable.append:temp;
            fieldCount.Value := fieldCount.Value+1;
        };
        
        myI.Value:=myI.Value+9;
        
        while(txmlFile[myI.Value+1]==","){ //(, varName)*
            
            temp :=txmlFile[myI.Value+4];  classSymbolTable.append:temp;
            classSymbolTable.append:type;
            classSymbolTable.append:kind;
            if(kind=="static"){
                temp := staticCount.Value.toString(); classSymbolTable.append:temp;
                staticCount.Value := staticCount.Value+1;
            }
            else{
                temp := fieldCount.Value.toString(); classSymbolTable.append:temp;
                fieldCount.Value := fieldCount.Value+1;
            };
            myI.Value:=myI.Value+6;
        };
        myI.Value:=myI.Value+3;
        
    };
    
    
}



public subroutineDec(var txmlFile,var myVmFile,var classSymbolTable)
{
    var temp;
    var n := forward newLine.toString();
    
    
    
    while(txmlFile[myI.Value+1]=="constructor"||(txmlFile[myI.Value+1]=="function")||(txmlFile[myI.Value+1]=="method")){
        myIfIndex.Value := 0;
        myWhileIndex.Value := 0;
        argumentCount.Value :=0;
        var functionSymbolTable := new system'collections'ArrayList();
        subRoutineName.Value := txmlFile[myI.Value+7];
        var type := txmlFile[myI.Value+1];
        if(txmlFile[myI.Value+1]=="method"){
            functionSymbolTable.append:"this";
            functionSymbolTable.append:myClassName.Value;
            functionSymbolTable.append:"argument";
            temp := argumentCount.Value.toString(); functionSymbolTable.append:temp;
            argumentCount.Value := argumentCount.Value+1;
        };
        myI.Value:=myI.Value+12;
        parameterList(txmlFile,functionSymbolTable);
        
        myI.Value:=myI.Value+3;
        subroutineBody(txmlFile,myVmFile,classSymbolTable,functionSymbolTable,type);  
    };
}

public parameterList(var txmlFile,var functionSymbolTable)
{
    
    var n := forward newLine.toString();
    string temp;
    if(txmlFile[myI.Value+1]!=")"){
        
        temp := txmlFile[myI.Value+4];  functionSymbolTable.append:temp;
        temp := txmlFile[myI.Value+1];  functionSymbolTable.append:temp;
        functionSymbolTable.append:"argument";
        temp := argumentCount.Value.toString(); functionSymbolTable.append:temp;
        argumentCount.Value := argumentCount.Value+1;
        
        myI.Value:=myI.Value+6;
    };
    while(txmlFile[myI.Value+1]!=")")
    {
        
        temp := txmlFile[myI.Value+7];  functionSymbolTable.append:temp;
        temp := txmlFile[myI.Value+4];  functionSymbolTable.append:temp;
        functionSymbolTable.append:"argument";
        temp := argumentCount.Value.toString(); functionSymbolTable.append:temp;
        argumentCount.Value := argumentCount.Value+1;
        
        myI.Value:=myI.Value+9;
    };
 
}

public subroutineBody(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable,var type)
{
    varCount.Value := 0;
    var n := forward newLine.toString();
    myI.Value:=myI.Value+3;
    varDec(txmlFile,myVmFile,functionSymbolTable);
    using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("function "+myClassName.Value+"."+subRoutineName.Value+" "+varCount.Value.toString());
    if(type=="constructor"){
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("push constant "+(fieldCount).toString()+n+"call Memory.alloc 1"+n+"pop pointer 0");
    };
    if(type=="method"){
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("push argument 0"+n+"pop pointer 0");
    };
    statements(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
    myI.Value:=myI.Value+3;   
}

public varDec(var txmlFile,var myVmFile,var functionSymbolTable)
{
    string temp;
    string type;
    var n := forward newLine.toString();
    
    
    while(txmlFile[myI.Value+1]=="var"){
        type := txmlFile[myI.Value+4];
        temp := txmlFile[myI.Value+7];  functionSymbolTable.append:temp;
        temp := txmlFile[myI.Value+4];  functionSymbolTable.append:temp;
        functionSymbolTable.append:"var";
        temp:=varCount.Value.toString();
        functionSymbolTable.append:temp;
        varCount.Value := varCount.Value+1;
        
        myI.Value:=myI.Value+9;
    
        while(txmlFile[myI.Value+1]==","){
            temp := txmlFile[myI.Value+4];  functionSymbolTable.append:temp;
            functionSymbolTable.append:type;
            functionSymbolTable.append:"var";
            temp := varCount.Value.toString();
            functionSymbolTable.append:temp;
            varCount.Value := varCount.Value+1;
        
            myI.Value:=myI.Value+6;
        };
        myI.Value:=myI.Value+3;
    };   
}



//statements
public statements(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable){
    
    statement(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
}
public statement(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable)
{
    while(txmlFile[myI.Value+1]=="while"||(txmlFile[myI.Value+1]=="if")||(txmlFile[myI.Value+1]=="let")||
    (txmlFile[myI.Value+1]=="do")||(txmlFile[myI.Value+1]=="return")){
        if(txmlFile[myI.Value+1] == "let")
            {
                letStatement(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
            }
            else{
                if(txmlFile[myI.Value+1] == "if"){
                    ifStatement(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
                }
                else{
                    if( txmlFile[myI.Value+1] == "while"){
                        whileStatement(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
                    }
                    else{
                        if(txmlFile[myI.Value+1] == "do"){
                            doStatement(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
                        }
                        else{
                            if(txmlFile[myI.Value+1] == "return"){
                                returnStatement(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
                            }
                        }
                      
                    }
                }
            }
        };  
}

public findIndex(var myArray,var str){
    for(var i:=0,i<myArray.Length,i+=1){
        if(myArray[i]==str){
            ^i;
        };
    };
    ^(-1);
}
public letStatement(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable)
{
    var classSymbolT:=classSymbolTable;
    var functionSymbolT:=functionSymbolTable;
    var myIndex := findIndex(functionSymbolT,txmlFile[myI.Value+4]);
    var kind;
    var index;
    if(myIndex>(-1)){
        kind:=transform(functionSymbolT[myIndex+2]);
        index := " "+functionSymbolT[myIndex+3];
    };
    if(myIndex==-1){
        myIndex := findIndex(classSymbolT,txmlFile[myI.Value+4]);
        kind:=transform(classSymbolT[myIndex+2]);
        index:=" "+classSymbolT[myIndex+3];
    };
    var n := forward newLine.toString();
    myI.Value:=myI.Value+6;
    if(txmlFile[myI.Value+1] =="[") 
    {
        
        myI.Value:=myI.Value+3;//[
        expression(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("push "+kind+index+n+"add");
        myI.Value:=myI.Value+6;//]=
        expression(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("pop temp 0"+n+"pop pointer 1"+n+"push temp 0"+n+"pop that 0");
        
    }
    else{
        myI.Value:=myI.Value+3;//=
        expression(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("pop "+kind+index);
    };
    myI.Value:=myI.Value+3;//;
    
    
}



public ifStatement(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable)
{
    var n := forward newLine.toString();
    var index := myIfIndex.Value;
    myIfIndex.Value := myIfIndex.Value+1;
    
    
    myI.Value:=myI.Value+6;//if (
    expression(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
    using(auto writer := File.assign(myVmFile).logger())
    writer.writeLine("if-goto IF_TRUE"+index.toString()+n+"goto IF_FALSE"+index.toString()+n+
    "label IF_TRUE"+index.toString());
    myI.Value:=myI.Value+6;//){
    statements(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
    
    myI.Value:=myI.Value+3;//}
    if(txmlFile[myI.Value+1]!="else"){
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("label IF_FALSE"+index.toString());
    };
    if(txmlFile[myI.Value+1]=="else")
    {
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("goto IF_END"+index.toString()+n+"label IF_FALSE"+index.toString());
        myI.Value:=myI.Value+6;//else {
        statements(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
        myI.Value:=myI.Value+3;//}
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("label IF_END"+index.toString());
    };  
    
}



public whileStatement(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable)
{
    
    var n := forward newLine.toString();
    var index := myWhileIndex.Value;
    myWhileIndex.Value := myWhileIndex.Value+1;
    
    
    using(auto writer := File.assign(myVmFile).logger())
    writer.writeLine("label WHILE_EXP"+index.toString());
    myI.Value:=myI.Value+6;//while (
    
    expression(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);

    myI.Value:=myI.Value+6;//){
        
    using(auto writer := File.assign(myVmFile).logger())
    writer.writeLine("not"+n+"if-goto WHILE_END"+index.toString());
    statements(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
    using(auto writer := File.assign(myVmFile).logger())
    writer.writeLine("goto WHILE_EXP"+index.toString()+n+"label WHILE_END"+index.toString());
    myI.Value:=myI.Value+3;  

}




public doStatement(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable)
{
    myI.Value:=myI.Value+3;//do
    subroutineCall(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
    myI.Value:=myI.Value+3;//;
    using(auto writer := File.assign(myVmFile).logger())
    writer.writeLine("pop temp 0");
    
}



public returnStatement(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable)
{
    
    myI.Value:=myI.Value+3;//return
    if(txmlFile[myI.Value+1]!=";"){
        expression(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
    }
    else{
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("push constant 0");
    };
    using(auto writer := File.assign(myVmFile).logger())
    writer.writeLine("return");
    
    myI.Value:=myI.Value+3;//;
   
}

public op(var operator, var myVmFile){
    var str;
    if(operator=="+"){
        str:="add";
    }
    else if(operator=="-"){
        str:="sub";
    }
    else if(operator=="*"){
        str := "call Math.multiply 2";
    }
    else if(operator=="/"){
        str := "call Math.divide 2";
    }
    else if(operator=="&amp;"){
        str := "and";
    }
    else if(operator=="|"){
        str := "or";
    }
    else if(operator=="&lt;"){
        str := "lt";
    }
    else if(operator=="&gt;"){
        str := "gt";
    }
    else if(operator=="="){
        str := "eq";
    };
    using(auto writer := File.assign(myVmFile).logger())
    writer.writeLine(str);
}

public expression(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable)
{
    term(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
    while(inOp(txmlFile[myI.Value+1])){
        var operator := txmlFile[myI.Value+1];
        myI.Value:=myI.Value+3;//(
        term(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
        op(operator,myVmFile);
        
    };
    
}




public term(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable)
{
    
    var n := forward newLine.toString();
    
    if(txmlFile[myI.Value]=="<integerConstant>")
    {
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("push constant "+txmlFile[myI.Value+1]);
        myI.Value:=myI.Value+3;
    }
    else if(txmlFile[myI.Value]=="<keyword>")
    {
        if(txmlFile[myI.Value+1]=="true"){
            using(auto writer := File.assign(myVmFile).logger())
            writer.writeLine("push constant 0"+n+"not");
        }
        else if(txmlFile[myI.Value+1]=="false"||(txmlFile[myI.Value+1]=="null")){
            using(auto writer := File.assign(myVmFile).logger())
            writer.writeLine("push constant 0");
        }
        else if(txmlFile[myI.Value+1]=="this"){
            using(auto writer := File.assign(myVmFile).logger())
            writer.writeLine("push pointer 0");
        };
        
        myI.Value:=myI.Value+3;
    }
    else if(txmlFile[myI.Value]=="<stringConstant>"){
            myI.Value:=myI.Value+1;
            string temp:="";
            while(txmlFile[myI.Value]!="</stringConstant>"){
                temp:=temp+txmlFile[myI.Value]+" ";
                myI.Value:=myI.Value+1;
            };

            myI.Value:=myI.Value+1;
            using(auto writer := File.assign(myVmFile).logger())
            writer.writeLine("push constant "+(temp.Length-1).toString()+n+"call String.new 1");
            var temp1;
            for(var j:=0 , j<temp.Length-1, j+=1){
                temp1 := temp[j].toInt();
	            using(auto writer := File.assign(myVmFile).logger())
                writer.writeLine("push constant "+temp1.toString()+n+"call String.appendChar 2");
            }  
        }
    
    
    else if(txmlFile[myI.Value]=="<identifier>"&& txmlFile[myI.Value+4]=="[")
    {
        var classSymbolT:=classSymbolTable;
        var functionSymbolT:=functionSymbolTable;
        var myIndex := findIndex(functionSymbolT,txmlFile[myI.Value+1]);
        var kind;
        var index;
        if(myIndex>(-1)){
            kind:=transform(functionSymbolT[myIndex+2]);
            index := " "+functionSymbolT[myIndex+3];
        };
        if(myIndex==-1){
            myIndex := findIndex(classSymbolT,txmlFile[myI.Value+1]);
            kind:=transform(classSymbolT[myIndex+2]);
            index:=" "+classSymbolT[myIndex+3];
        };
     
        
        myI.Value:=myI.Value+6;//varName [
        expression(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
        
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("push "+kind+index+n+"add"+n+"pop pointer 1"+n+"push that 0");
        myI.Value:=myI.Value+3;//]
    }
    else if(txmlFile[myI.Value]=="<identifier>"&& txmlFile[myI.Value+4]=="("||(txmlFile[myI.Value]=="<identifier>"&& txmlFile[myI.Value+4]=="."))  //suroutieCall
    {        
         subroutineCall(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
    }
    else if(txmlFile[myI.Value]=="<identifier>") //varName
    {
        var classSymbolT:=classSymbolTable;
        var functionSymbolT:=functionSymbolTable;
        var myIndex := findIndex(functionSymbolT,txmlFile[myI.Value+1]);
        var kind;
        var index;
        if(myIndex>(-1)){
            kind:=transform(functionSymbolT[myIndex+2]);
            index := " "+functionSymbolT[myIndex+3];
        };
        if(myIndex==-1){
            myIndex := findIndex(classSymbolT,txmlFile[myI.Value+1]);
            kind:=transform(classSymbolT[myIndex+2]);
            index:=" "+classSymbolT[myIndex+3];
        };
        
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("push "+kind+index);
        myI.Value:=myI.Value+3;
     }
     else if(txmlFile[myI.Value+1]=="(") // (expression)
     {
         myI.Value:=myI.Value+3;//(
         expression(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
         myI.Value:=myI.Value+3;//)
                    
     }
     else if(txmlFile[myI.Value+1]=="-") //unary op
     {
         myI.Value:=myI.Value+3;
         term(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
         using(auto writer := File.assign(myVmFile).logger())
         writer.writeLine("neg");
     }
     else if(txmlFile[myI.Value+1]=="~") //unary op
     {
         myI.Value:=myI.Value+3;
         term(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
         using(auto writer := File.assign(myVmFile).logger())
         writer.writeLine("not");
     };   
}

public transform(var str){
    if(str =="static"){
        ^"static";
    }
    else if(str=="field"){
        ^"this";
    }
    else if(str=="var"){
        ^"local";
    }
    else if(str=="argument"){
        ^"argument";
    };
}

public subroutineCall(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable)
{
    
    var n := forward newLine.toString();
    
    if(txmlFile[myI.Value+4]=="."){
        var tempName := txmlFile[myI.Value+1];
        var tempSubroutineName := txmlFile[myI.Value+7];
        
        var classSymbolT:=classSymbolTable;
        var functionSymbolT:=functionSymbolTable;
        
        var type;
        var myIndex;
        var kind;
        var index;
        
        //if it is a class function we made
        if(findIndex(functionSymbolT,txmlFile[myI.Value+1])!=(-1)||(findIndex(classSymbolT,txmlFile[myI.Value+1])!=(-1))){
            if(findIndex(functionSymbolT,txmlFile[myI.Value+1]).mod(4)==0||(findIndex(classSymbolT,txmlFile[myI.Value+1]).mod(4)==0)){
                myIndex := findIndex(functionSymbolT,txmlFile[myI.Value+1]);
                if(myIndex>(-1)){
                    type:=functionSymbolT[myIndex+1];
                    kind := transform(functionSymbolT[myIndex+2]);
                    index := " "+functionSymbolT[myIndex+3];
                };
                if(myIndex==-1){
                    myIndex := findIndex(classSymbolT,txmlFile[myI.Value+1]);
                    type:=classSymbolT[myIndex+1];
                    kind := transform(classSymbolT[myIndex+2]);
                    index := " "+classSymbolT[myIndex+3];
                };
                
                
                
                using(auto writer := File.assign(myVmFile).logger())
                writer.writeLine("push "+kind+index);//this
            
                myI.Value := myI.Value+12;
                var num := expressionList(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
                using(auto writer := File.assign(myVmFile).logger())
                writer.writeLine("call "+type+"."+tempSubroutineName+" "+(num+1).toString());
                myI.Value := myI.Value+3;
                
            }
            else{

            
                myI.Value := myI.Value+12;
                var num := expressionList(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
                using(auto writer := File.assign(myVmFile).logger())
                writer.writeLine("call "+tempName+"."+tempSubroutineName+" "+num.toString());
                myI.Value := myI.Value+3;
            };
            
        }
        else{//functions belonging to OS
            myI.Value := myI.Value+12;
            var num := expressionList(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
            using(auto writer := File.assign(myVmFile).logger())
            writer.writeLine("call "+tempName+"."+tempSubroutineName+" "+num.toString());
            myI.Value := myI.Value+3;
      
        };
    }
    else{
        var temp := txmlFile[myI.Value+1];
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("push pointer 0");
        myI.Value:=myI.Value+6;
        var num := expressionList(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
        myI.Value:=myI.Value+3;
        using(auto writer := File.assign(myVmFile).logger())
        writer.writeLine("call "+myClassName.Value+"."+temp+" "+(num+1).toString());//varCount.Value);
        
    };
    
    
  
  
}
        


public expressionList(var txmlFile,var myVmFile,var classSymbolTable,var functionSymbolTable)
{
    var numOfVariables:=0;
    if(txmlFile[myI.Value+1]!=")"){
        expression(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
        numOfVariables+=1;
        while(txmlFile[myI.Value+1] == ",")
        {
            numOfVariables+=1;
            myI.Value:=myI.Value+3;
            expression(txmlFile,myVmFile,classSymbolTable,functionSymbolTable);
            
        }
    };   
    ^numOfVariables;
}





public inOp(var str)
{
    if(str=="+"||(str=="-")||(str=="*")||(str=="/")||(str=="&amp;")||(str=="|")||(str=="&lt;")||(str=="&gt;")||(str=="=")){
        ^true;
    };
    ^false;
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
            using(auto writer := File.assign(txmlFile).textwriter())
            writer.writeLine("<tokens>");
            tokenizer(path,files[j],txmlFile);
            using(auto writer := File.assign(txmlFile).logger())
            writer.writeLine("</tokens>");
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
            var myVmFile := files[j].Substring(0,files[j].Length-6)+".vm";
            string temp:=convertFileToString(files[j]);
            var temp1:=temp.splitBy(" ");
            var classSymbolTable := new system'collections'ArrayList();
            myI.Value:=1;
            //parsing
            myClass(temp1,myVmFile,classSymbolTable);
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
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\Average\MainT1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\ComplexArrays\MainT1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\ConvertToBin\MainT1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\Pong\MainT1.xml").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\Pong\BallT1.xml").delete();
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\Pong\BatT1.xml").delete();
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\Pong\PongGameT1.xml").delete();
    

    //labels
    keywords.Value := new string[]{"class","constructor","function","method","field","static","var","int","char"
    ,"boolean","void","true","false","null","this","let","do","if","else","while","return"};
    mySymbol.Value := new string[]{"{","}","(",")","[","]",".",",",";","+","-","*","&","|","<",">","=","~"};
   
    
    var myDirectory := system'Array.allocate:6;
    myDirectory[0] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\Average";
    myDirectory[1] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\ComplexArrays";
    myDirectory[2] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\ConvertToBin";
    myDirectory[3] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\Pong";
    myDirectory[4] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\Seven";
    myDirectory[5] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe5\11\Square";
    


   
 
    for(var j :=0,j<myDirectory.Length,j+=1)
    {
        findJackfiles(myDirectory[j]);
    };
    
    for(var k :=0,k<myDirectory.Length,k+=1)
    {
        findT1xmlfiles(myDirectory[k]);
    };

    console.printLine("finished");
    console.readChar();
}

