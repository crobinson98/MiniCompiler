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


static ifTrue = new Variable();
static ifFalse = new Variable();
static returnAddress = new Variable();


public myAdd(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"A=A-1"+n+"M=D+M"+n+"@SP"+n+"M=M-1");
}

public mySub(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"A=A-1"+n+"M=M-D"+n+"@SP"+n+"M=M-1");
}

public myNeg(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"D=A"+n+"A=M-1"+n+"M=D-M");
}

public myEq(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"A=A-1"+n+"D=M-D"+n+"@IF_TRUE"+ifTrue.toString()+n+"D;JEQ"+n+"D=0"+n+"@SP"+n+"A=M-1"+n+"A=A-1"+n+"M=D"
    +n+"@IF_FALSE"+ifFalse.toString()+n+"0;JMP"+n+"(IF_TRUE"+ifTrue.toString()+")"+n+"D=-1"+n+"@SP"+n+"A=M-1"+n+"A=A-1"+n+"M=D"+n+"(IF_FALSE"
    +ifFalse.toString()+")"+n+"@SP"+n+"M=M-1");
    ifTrue.Value := ifTrue.Value + 1;
    ifFalse.Value := ifFalse.Value + 1;
}

public myGt(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"A=A-1"+n+"D=M-D"+n+"@IF_TRUE"+ifTrue.toString()+n+"D;JGT"+n+"D=0"+n+"@SP"+n+"A=M-1"+n+"A=A-1"+
    n+"M=D"+n+"@IF_FALSE"+ifFalse.toString()+n+"0;JMP"+n+"(IF_TRUE"+ ifTrue.toString()+")"+n+"D=-1"+n+"@SP"+n+"A=M-1"+n+"A=A-1"+n+"M=D"+n
    +"(IF_FALSE"+ifFalse.toString()+")"+n+"@SP"+n+"M=M-1");
    ifTrue.Value :=ifTrue.Value + 1;
    ifFalse.Value := ifFalse.Value + 1;
}

public myLt(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"A=A-1"+n+"D=M-D"+n+"@IF_TRUE"+ifTrue.toString()+n+"D;JLT"+n+"D=0"+n+"@SP"+n+"A=M-1"+n+"A=A-1"
    +n+"M=D"+n+"@IF_FALSE"+ifFalse.toString()+n+"0;JMP"+n+"(IF_TRUE"+ifTrue.toString()+")"+n+"D=-1"+n+"@SP"+n+"A=M-1"+n+"A=A-1"+n+"M=D"+n
    +"(IF_FALSE"+ ifFalse.toString()+")"+n+"@SP"+n+"M=M-1");
    ifTrue.Value :=ifTrue.Value + 1;
    ifFalse.Value := ifFalse.Value + 1;
}

public myAnd(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"A=A-1"+n+"M=D&M"+n+"@SP"+n+"M=M-1");
}

public myOr(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"A=A-1"+n+"M=D|M"+n+"@SP"+n+"M=M-1");
}

public myNot(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=!D"+n+"M=D");
}

public myPopThis(var num,var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"@THIS"+n+"A=M");
    for(var i :=0, i<num.toInt(),i+=1){
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("A=A+1");
    };
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("M=D"+n+"@SP"+n+"M=M-1");
}

public myPopThat(var num,var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"@THAT"+n+"A=M");
    for(var i :=0, i<num.toInt(),i+=1){
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("A=A+1");
    };
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("M=D"+n+"@SP"+n+"M=M-1");
}

public myPopTemp(var num,var asmFile)
{    
    var n := forward newLine.toString();
    var temp :=5+num.toInt();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"@"+temp.toString()+n+"M=D"+n+"@SP"+n+"M=M-1");
}
    
public myPopStatic(var num, var asmFile, var vmFileName)
{
    
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"@"+vmFileName+"."+num+n+"M=D"+n+"@SP"+n+"M=M-1");
}

public myPopPointer0(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"@THIS"+n+"M=D"+n+"@SP"+n+"M=M-1");
}

public myPopPointer1(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"@THAT"+n+"M=D"+n+"@SP"+n+"M=M-1");
}

public myPopLocal(var num,var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"@LCL"+n+"A=M");
    for(var i :=0, i< num.toInt(),i+=1){
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("A=A+1");
    };
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("M=D"+n+"@SP"+n+"M=M-1");
}

public myPopArgument(var sentence,var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@SP"+n+"A=M-1"+n+"D=M"+n+"@ARG"+n+"A=M");
    for(var i :=0, i<sentence[2].toInt(),i+=1){
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("A=A+1");
    };
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("M=D"+n+"@SP"+n+"M=M-1");
}

public myPushConstant(var num,var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@"+num+n+"D=A"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1");
}

public myPushLocal(var num,var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@"+num+n+"D=A"+n+"@LCL"+n+"A=M+D"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"); 
}

public myPushArgument(var num,var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@"+num+n+"D=A"+n+"@ARG"+n+"A=M+D"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"); 
}

public myPushThis(var num, var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@"+num+n+"D=A"+n+"@THIS"+n+"A=M+D"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1");
}

public myPushThat(var num, var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@"+num+n+"D=A"+n+"@THAT"+n+"A=M+D"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"); 
}

public myPushTemp(var num,var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@"+num+n+"D=A"+n+"@5"+n+"A=A+D"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1");
}

public myPushStatic(var num,var asmFile, var vmFileName)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@"+vmFileName+"."+num+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1");
}


public myPushPointer0(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@THIS"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1");
}

public myPushPointer1(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@THAT"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1");
}

public myLabel(var labelName,var asmFile,var vmFileName)
{
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("("+vmFileName+"."+labelName+")");
}

public myGoto(var labelName,var asmFile,var vmFileName)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@"+vmFileName+"."+labelName+n+"0;JMP");  
}

public myIfGoto(var labelName,var asmFile,var vmFileName)
{
   var n := forward newLine.toString();
   using(auto writer := File.assign(asmFile).logger())
   writer.writeLine("@SP"+n+"M=M-1"+n+"A=M"+n+"D=M"+n+"@"+vmFileName+"."+labelName+n+"D;JNE");
}


public myFunction(var functionName,var numOfParams,var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("("+functionName+")"+n+"@"+numOfParams+n+"D=A"+n+"@"+functionName+".End"+n+"D;JEQ"+n+"("+functionName+".Loop)"+n+"@SP"+n+
    "A=M"+n+"M=0"+n+"@SP"+n+"M=M+1"+n+"@"+functionName+".Loop"+n+"D=D-1;JNE"+n+"("+functionName+".End)");
}
               
public myCall(var functionName,var numOfParams,var asmFile)
{
    var temp := numOfParams.toInt()+5;
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@"+functionName+".ReturnAddress"+returnAddress.toString()+n+"D=A"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"+n+"@LCL"+n+"D=M"
    +n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"+n+"@ARG"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"+n+"@THIS"+n+"D=M"+n+"@SP"+n+"A=M"+n+
    "M=D"+n+"@SP"+n+"M=M+1"+n+"@THAT"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"+n+"@SP"+n+"D=M"+n+"@"+temp.toString()+n+"D=D-A"+n+"@ARG"+n+"M=D"+n+
    "@SP"+n+"D=M"+n+"@LCL"+n+"M=D"+n+"@"+functionName+n+"0;JMP"+n+"("+functionName+".ReturnAddress"+returnAddress.toString()+")");
    returnAddress.Value := returnAddress.Value+1;
}

public myReturn(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@LCL"+n+"D=M"+n+"@5"+n+"A=D-A"+n+"D=M"+n+"@13"+n+"M=D"+n+"@SP"+n+"M=M-1"+n+"A=M"+n+"D=M"+n+"@ARG"+n+"A=M"+n+"M=D"+n+
    "@ARG"+n+"D=M"+n+"@SP"+n+"M=D+1"+n+"@LCL"+n+"M=M-1"+n+"A=M"+n+"D=M"+n+"@THAT"+n+"M=D"+n+"@LCL"+n+"M=M-1"+n+"A=M"+n+"D=M"+n+"@THIS"+n+
    "M=D"+n+"@LCL"+n+"M=M-1"+n+"A=M"+n+"D=M"+n+"@ARG"+n+"M=D"+n+"@LCL"+n+"M=M-1"+n+"A=M"+n+"D=M"+n+"@LCL"+n+"M=D"+n+"@13"+n+"A=M"+n+"0;JMP");

}



public myPush(var sentence,var asmFile, var vmFileName)
{
    if(sentence[1]=="constant")
    {
        myPushConstant(sentence[2],asmFile);       
    }
    else if(sentence[1]=="local")
    {
        myPushLocal(sentence[2],asmFile);
    }
    else if(sentence[1]=="argument")
    {
        myPushArgument(sentence[2],asmFile);       
    }
    else if(sentence[1]=="this")
    {
        myPushThis(sentence[2],asmFile);       
    }
    else if(sentence[1]=="that")
    {
        myPushThat(sentence[2],asmFile);       
    }
    else if(sentence[1]=="temp")
    {
        myPushTemp(sentence[2],asmFile);      
    }
    else if(sentence[1]=="static")
    {
        myPushStatic(sentence[2],asmFile, vmFileName);
    }
    else if(sentence[1]=="pointer")
    {
        if(sentence[2]=="0"){
            myPushPointer0(asmFile);
        }
        else if(sentence[2]=="1"){
            myPushPointer1(asmFile);
        };
        
    };
}

public myPop(var sentence,var asmFile,var vmFileName)
{
    if(sentence[1]=="this"){
        myPopThis(sentence[2],asmFile);      
    }
    else if(sentence[1]=="that"){
        myPopThat(sentence[2],asmFile);
    }
    else if(sentence[1]=="temp"){
        myPopTemp(sentence[2],asmFile);
    }
    else if(sentence[1]=="static"){
        myPopStatic(sentence[2],asmFile,vmFileName);
    }
    else if(sentence[1]=="pointer"){
        if(sentence[2]=="0"){
            myPopPointer0(asmFile);
        }
        else if(sentence[2]=="1"){
            myPopPointer1(asmFile);
        };
 
    }
    else if(sentence[1]=="local"){
        myPopLocal(sentence[2],asmFile);
    }
    else if(sentence[1]=="argument"){

        myPopArgument(sentence,asmFile);
    };
}

public bootStrap(var asmFile)
{
    var n := forward newLine.toString();
    using(auto writer := File.assign(asmFile).logger())
    writer.writeLine("@256"+n+"D=A"+n+"@SP"+n+"M=D"+n+"@Sys.init.returnAdd"+n+"D=A"+n+"@SP"+n+"A=M"+n+"M=D"+n
    +"@SP"+n+"M=M+1"+n+"@LCL"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"+n+"@ARG"+n+"D=M"+n+"@SP"+n+
    "A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"+n+"@THIS"+n+"D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"+n+"@THAT"+n+
    "D=M"+n+"@SP"+n+"A=M"+n+"M=D"+n+"@SP"+n+"M=M+1"+n+"@SP"+n+"D=M"+n+"@5"+n+"D=D-A"+n+"@ARG"+n+"M=D"+n+"@SP"
    +n+"D=M"+n+"@LCL"+n+"M=D"+n+"@Sys.init"+n+"0;JMP"+n+"(Sys.init.returnAdd)");

}
     
public vmToAsm(var myDirectory, var myVmFile,var asmFile)
{

    var fileNameReader := myVmFile;
    var fileNameWriter := asmFile;
    console.printLine(fileNameWriter);
    //console.readChar();
    
 
    // opening a text file reader
    using(auto reader := File.assign(fileNameReader).textreader())
    {
        // repeating until all the lines are read 
        while (reader.Available)
        {
            
            // read the line
            string line := reader.readLine();
            if((line[0]!="/") && (line[0]!=" ")){
                var currentSentence := line.splitBy(" "); 
                if(currentSentence[0]=="add")
                {
                    myAdd(fileNameWriter);
                }
                else if(currentSentence[0]=="sub")
                {
                    mySub(fileNameWriter);
                }
                else if(currentSentence[0]=="neg")
                {
                    myNeg(fileNameWriter);
                }
                else if(currentSentence[0]=="eq")
                {
                    myEq(fileNameWriter);
                }
                else if(currentSentence[0]=="gt")
                {
                    myGt(fileNameWriter);
                }
                else if(currentSentence[0]=="lt")
                {
                    myLt(fileNameWriter);
                }
                else if(currentSentence[0]=="and")
                {
                    myAnd(fileNameWriter);
                }
                else if(currentSentence[0]=="or")
                {   
                    myOr(fileNameWriter);
                }
                else if(currentSentence[0]=="not")
                {
                    myNot(fileNameWriter);
                }
                else if(currentSentence[0]=="push"){
                    myPush(currentSentence,fileNameWriter,findVmFileName(myVmFile));
                }
                else if(currentSentence[0]=="pop"){
                    myPop(currentSentence,fileNameWriter,findVmFileName(myVmFile));
                }
                else if(currentSentence[0]=="label"){
                    myLabel(currentSentence[1],fileNameWriter,findVmFileName(myVmFile));
                }
                else if(currentSentence[0]=="goto"){
                    myGoto(currentSentence[1],fileNameWriter,findVmFileName(myVmFile));
                }
                else if(currentSentence[0]=="if-goto"){
                    myIfGoto(currentSentence[1],fileNameWriter,findVmFileName(myVmFile));
                }
                else if(currentSentence[0]=="function"){
                    myFunction(currentSentence[1],currentSentence[2],fileNameWriter);
                }
                else if(currentSentence[0]=="call"){
                    myCall(currentSentence[1],currentSentence[2],fileNameWriter);
                }
                else if(currentSentence[0]=="return"){
                    myReturn(fileNameWriter);
                }
                
            }      
        };
    }
    
}    

public countVm(var files)
{
    var count := 0;
    for(var i:=0, i<files.Length,i+=1)
    {
        if(files[i][files[i].Length-1]=="m" && files[i][files[i].Length-2]=="v"&&files[i][files[i].Length-3]==".")
        {
            count+=1;
        };
    };
    ^count
}

public findVMfiles(var path)
{ 
    var dir := Directory.assign(path);
    var files := dir.getFiles();
    var asmFile := path.toString()+"\"+findDirectoryName(path)+".asm";
    if (countVm(files)>1)
    {
        bootStrap(asmFile);
    };
    for(var i := 0,i<files.Length,i+=1)
    {
        //console.readChar();
        if(files[i][files[i].Length-1]=="m" && files[i][files[i].Length-2]=="v"&&files[i][files[i].Length-3]==".")
        {
            vmToAsm(path,files[i],asmFile);
        };
    };
}           

public findDirectoryName(var dir)
{
    var temp := dir.toString().splitBy("\");
    ^ temp[temp.Length-1];
   
}

public findVmFileName(var file)
{
    var temp := file.toString().splitBy("\");
    var temp1 := temp[temp.Length-1];
    ^ temp1.Substring(0,temp1.Length-3);
}

public program()
{
    //delete files
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\FunctionCalls\FibonacciElement\FibonacciElement.asm").delete(); 
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\FunctionCalls\NestedCall\NestedCall.asm").delete();
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\FunctionCalls\SimpleFunction\SimpleFunction.asm").delete();
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\FunctionCalls\StaticsTest\StaticsTest.asm").delete();
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\ProgramFlow\BasicLoop\BasicLoop.asm").delete();
    File.assign("C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\ProgramFlow\FibonacciSeries\FibonacciSeries.asm").delete();
    
    //labels
    ifTrue.Value :=0;
    ifFalse.Value :=0;
    returnAddress.Value := 0;
    
    var myDirectory := system'Array.allocate:6;
    myDirectory[0] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\FunctionCalls\FibonacciElement";
    myDirectory[1] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\FunctionCalls\NestedCall";
    myDirectory[2] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\FunctionCalls\SimpleFunction";
    myDirectory[3] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\FunctionCalls\StaticsTest";
    myDirectory[4] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\ProgramFlow\BasicLoop";
    myDirectory[5] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe2\08\ProgramFlow\FibonacciSeries";

  
 
    for(var i :=0,i<myDirectory.Length,i+=1)
    {
        findVMfiles(myDirectory[i]);
    };
    console.readChar();
}