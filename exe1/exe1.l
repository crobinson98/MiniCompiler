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


public myPush(var sentence,var asmFile)
{
    wide newLineSymbol := forward newLine;
    if(sentence[1]=="constant")
    {
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@"+sentence[2]+(newLineSymbol).toString()+"D=A"+(newLineSymbol).toString()+"@SP"+
        (newLineSymbol).toString()+"A=M"+(newLineSymbol).toString()+"M=D"+(newLineSymbol).toString()+"@SP"+
        (newLineSymbol).toString()+"M=M+1");
        
    };
    if(sentence[1]=="local")
    {
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@"+sentence[2]+(newLineSymbol).toString()+"D=A"+(newLineSymbol).toString()+"@LCL"+(newLineSymbol).toString()+"A=M+D"+
        (newLineSymbol).toString()+"D=M"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"A=M"+(newLineSymbol).toString()+"M=D"+
        (newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M+1"); 
    };
    if(sentence[1]=="argument")
    {
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@"+sentence[2]+(newLineSymbol).toString()+"D=A"+(newLineSymbol).toString()+"@ARG"+(newLineSymbol).toString()+"A=M+D"+
        (newLineSymbol).toString()+"D=M"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"A=M"+(newLineSymbol).toString()+"M=D"+
        (newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M+1");        
    };
    if(sentence[1]=="this")
    {
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@"+sentence[2]+(newLineSymbol).toString()+"D=A"+(newLineSymbol).toString()+"@THIS"+(newLineSymbol).toString()+"A=M+D"+
        (newLineSymbol).toString()+"D=M"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"A=M"+(newLineSymbol).toString()+"M=D"+
        (newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M+1");       
    };
    if(sentence[1]=="that")
    {
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@"+sentence[2]+(newLineSymbol).toString()+"D=A"+(newLineSymbol).toString()+"@THAT"+(newLineSymbol).toString()+"A=M+D"+
        (newLineSymbol).toString()+"D=M"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"A=M"+(newLineSymbol).toString()+"M=D"+
        (newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M+1");      
    };
    if(sentence[1]=="temp")
    {
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@"+sentence[2]+(newLineSymbol).toString()+"D=A"+(newLineSymbol).toString()+"@5"+
        (newLineSymbol).toString()+"A=A+D"+(newLineSymbol).toString()+"D=M"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+
        "A=M"+(newLineSymbol).toString()+"M=D"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M+1");      
    };
    if(sentence[1]=="static")
    {
        var temp :=asmFile.splitBy("\");
        var temp1 := temp[temp.Length-1];
        var temp2 :=temp1.Substring(0,temp1.Length-4);
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@"+temp2+"."+sentence[2]+(newLineSymbol).toString()+"D=M"+(newLineSymbol).toString()+"@SP"+
        (newLineSymbol).toString()+"A=M"+(newLineSymbol).toString()+"M=D"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+
        "M=M+1");
    };
    if(sentence[1]=="pointer")
    {
        var text;
        if(sentence[2]=="0"){
            text := "@THIS";
        };
        if(sentence[2]=="1"){
            text := "@THAT";
        };
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine(text+(newLineSymbol).toString()+"D=M"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"A=M"+(newLineSymbol).toString()
        +"M=D"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M+1");
    };
}

public myPop(var sentence,var asmFile)
{
    wide newLineSymbol := forward newLine;
    if(sentence[1]=="this"){
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"+
        (newLineSymbol).toString()+"@THIS"+(newLineSymbol).toString()+"A=M");
        for(var i :=0, i<sentence[2].toInt(),i+=1){
            using(auto writer := File.assign(asmFile).logger())
            writer.writeLine("A=A+1");
        };
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("M=D"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");      
    };
    if(sentence[1]=="that"){
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"+
        (newLineSymbol).toString()+"@THAT"+(newLineSymbol).toString()+"A=M");
        for(var i :=0, i<sentence[2].toInt(),i+=1){
            using(auto writer := File.assign(asmFile).logger())
            writer.writeLine("A=A+1");
        };
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("M=D"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");
        
    };
    if(sentence[1]=="temp"){
        var temp :=5+sentence[2].toInt();
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"+(newLineSymbol).toString()
        +"@"+temp.toString()+(newLineSymbol).toString()+"M=D"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()
        +"M=M-1");
    };
    if(sentence[1]=="static"){
        var temp :=asmFile.splitBy("\");
        var temp1 := temp[temp.Length-1];
        var temp2 :=temp1.Substring(0,temp1.Length-4);
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"+(newLineSymbol).toString()
        +"@"+temp2+"."+sentence[2]+(newLineSymbol).toString()+"M=D"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()
        +"M=M-1");
    };
    if(sentence[1]=="pointer"){
        var text;
        if(sentence[2]=="0"){
            text := "THIS";
        };
        if(sentence[2]=="1"){
            text := "THAT";
        };
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"+(newLineSymbol).toString()
        +"@"+text+(newLineSymbol).toString()+"M=D"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()
        +"M=M-1");
    };
    if(sentence[1]=="local"){
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"+
        (newLineSymbol).toString()+"@LCL"+(newLineSymbol).toString()+"A=M");
        for(var i :=0, i<sentence[2].toInt(),i+=1){
            using(auto writer := File.assign(asmFile).logger())
            writer.writeLine("A=A+1");
        };
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("M=D"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");
    };
    if(sentence[1]=="argument"){

        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"+
        (newLineSymbol).toString()+"@ARG"+(newLineSymbol).toString()+"A=M");
        for(var i :=0, i<sentence[2].toInt(),i+=1){
            using(auto writer := File.assign(asmFile).logger())
            writer.writeLine("A=A+1");
        };
        using(auto writer := File.assign(asmFile).logger())
        writer.writeLine("M=D"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");
    };
}


     
public vmToAsm(var myVmFile, var myAsmFile)
{
    wide newLineSymbol := forward newLine;
    var fileNameReader := myVmFile;
    var fileNameWriter := myAsmFile;

    // opening a text file reader
    using(auto reader := File.assign(fileNameReader).textreader())
    {
        // repeating until all the lines are read 
        while (reader.Available)
        {
            
            // read the line
            string line := reader.readLine();
            if(line[0]!="/"){
                console.printLine(line);
                //console.readChar();
                var currentSentence := line.splitBy(" "); 
                if(currentSentence[0]=="add")
                {
                    using(auto writer := File.assign(fileNameWriter).logger())
                    writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"
                    +(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"M=D+M"
                    +(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");
                };
                if(currentSentence[0]=="sub")
                {
                    using(auto writer := File.assign(fileNameWriter).logger())
                    writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"
                    +(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"M=M-D"
                    +(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");
                };
                if(currentSentence[0]=="neg")
                {
                    using(auto writer := File.assign(fileNameWriter).logger())
                    writer.writeLine("@SP"+(newLineSymbol).toString()+"D=A"+(newLineSymbol).toString()+"A=M-1"
                    +(newLineSymbol).toString()+"M=D-M");
                };
                if(currentSentence[0]=="eq")
                {
                    using(auto writer := File.assign(fileNameWriter).logger())
                    writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"
                    +(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"D=M-D"+(newLineSymbol).toString()+"@IF_TRUE"+ifTrue.toString()
                    +(newLineSymbol).toString()+"D;JEQ"+(newLineSymbol).toString()+"D=0"+(newLineSymbol).toString()+"@SP"
                    +(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"M=D"
                    +(newLineSymbol).toString()+"@IF_FALSE"+ifFalse.toString()+(newLineSymbol).toString()+"0;JMP"+(newLineSymbol).toString()+"(IF_TRUE"+
                    ifTrue.toString()+")"
                    +(newLineSymbol).toString()+"D=-1"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"A=M-1"
                    +(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"M=D"+(newLineSymbol).toString()+"(IF_FALSE"+ifFalse.toString()+")"
                    +(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");
                    ifTrue.Value :=ifTrue.Value + 1;
                    ifFalse.Value := ifFalse.Value + 1;
                };
                if(currentSentence[0]=="gt")
                {
                    using(auto writer := File.assign(fileNameWriter).logger())
                    writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"
                    +(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"D=M-D"+(newLineSymbol).toString()+"@IF_TRUE"+ifTrue.toString()
                    +(newLineSymbol).toString()+"D;JGT"+(newLineSymbol).toString()+"D=0"+(newLineSymbol).toString()+"@SP"
                    +(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"M=D"
                    +(newLineSymbol).toString()+"@IF_FALSE"+ifFalse.toString()+(newLineSymbol).toString()+"0;JMP"+(newLineSymbol).toString()+"(IF_TRUE"+
                    ifTrue.toString()+")"
                    +(newLineSymbol).toString()+"D=-1"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"A=M-1"
                    +(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"M=D"+(newLineSymbol).toString()+"(IF_FALSE"+ifFalse.toString()+")"
                    +(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");
                    ifTrue.Value :=ifTrue.Value + 1;
                    ifFalse.Value := ifFalse.Value + 1;
                };
                if(currentSentence[0]=="lt")
                {

                    using(auto writer := File.assign(fileNameWriter).logger())
                    writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"
                    +(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"D=M-D"+(newLineSymbol).toString()+"@IF_TRUE"+ifTrue.toString()
                    +(newLineSymbol).toString()+"D;JLT"+(newLineSymbol).toString()+"D=0"+(newLineSymbol).toString()+"@SP"
                    +(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"M=D"
                    +(newLineSymbol).toString()+"@IF_FALSE"+ifFalse.toString()+(newLineSymbol).toString()+"0;JMP"+(newLineSymbol).toString()+"(IF_TRUE"+
                    ifTrue.toString()+")"
                    +(newLineSymbol).toString()+"D=-1"+(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"A=M-1"
                    +(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"M=D"+(newLineSymbol).toString()+"(IF_FALSE"+
                    ifFalse.toString()+")"
                    +(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");
                    ifTrue.Value :=ifTrue.Value + 1;
                    ifFalse.Value := ifFalse.Value + 1;
                };
                if(currentSentence[0]=="and")
                {
                    using(auto writer := File.assign(fileNameWriter).logger())
                    writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"
                    +(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"M=D&M"
                    +(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");
                };
                if(currentSentence[0]=="or")
                {   
                    using(auto writer := File.assign(fileNameWriter).logger())
                    writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=M"
                    +(newLineSymbol).toString()+"A=A-1"+(newLineSymbol).toString()+"M=D|M"
                    +(newLineSymbol).toString()+"@SP"+(newLineSymbol).toString()+"M=M-1");
                };
                if(currentSentence[0]=="not")
                {
                    using(auto writer := File.assign(fileNameWriter).logger())
                    writer.writeLine("@SP"+(newLineSymbol).toString()+"A=M-1"+(newLineSymbol).toString()+"D=!D"
                    +(newLineSymbol).toString()+"M=D");
                };
                if(currentSentence[0]=="push"){
                    myPush(currentSentence,myAsmFile);
                };
                if(currentSentence[0]=="pop"){
                    myPop(currentSentence,myAsmFile);
                };
            }      
        };
    }
    
}    



    
public program()
{
    ifTrue.Value :=0;
    ifFalse.Value :=0;
    var vmFiles := system'Array.allocate:5;
    vmFiles[0] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe1\Targil1\project 07\MemoryAccess\BasicTest\BasicTest.vm";
    vmFiles[1] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe1\Targil1\project 07\MemoryAccess\PointerTest\PointerTest.vm";
    vmFiles[2] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe1\Targil1\project 07\MemoryAccess\StaticTest\StaticTest.vm";
    vmFiles[3] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe1\Targil1\project 07\StackArithmetic\SimpleAdd\SimpleAdd.vm";
    vmFiles[4] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe1\Targil1\project 07\StackArithmetic\StackTest\StackTest.vm";
    
    var asmFiles := system'Array.allocate:5;
    asmFiles[0] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe1\Targil1\project 07\MemoryAccess\BasicTest\BasicTest.asm";
    asmFiles[1] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe1\Targil1\project 07\MemoryAccess\PointerTest\PointerTest.asm";
    asmFiles[2] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe1\Targil1\project 07\MemoryAccess\StaticTest\StaticTest.asm";
    asmFiles[3] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe1\Targil1\project 07\StackArithmetic\SimpleAdd\SimpleAdd.asm";
    asmFiles[4] := "C:\Users\Chaya\Documents\elena.5.0.550-i386\exe\exe1\Targil1\project 07\StackArithmetic\StackTest\StackTest.asm";
    
    for(var i :=0,i<vmFiles.Length,i+=1)
    {
        vmToAsm(vmFiles[i],asmFiles[i]);
    };
    console.readChar();
}
    
