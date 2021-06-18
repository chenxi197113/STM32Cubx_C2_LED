
/*
 * 文件名：flinger.em
 *
 * 步骤：
 * 1. 复制到Base项目文件夹，如；C:\Users\xxx\Documents\Source Insight 4.0\Projects\Base
 * 2. Project -> Open Project，打开Base项目；
 * 3. 将复制过去的flinger.em添加入Base项目；
 * 4. 重启SourceInsight；
 * 5. Options -> Menu Assignments，将Marco宏名添加到"Work"菜单；
 */
 
 
 
 
//获取自己的Name
macro GetMyName()
{
    return "Flinger"
}
 
//格式化日期时间，就是补0
macro FormatNum(Num)
{
    if (Num < 10)
    {
        szNum = "0@Num@";
    }
    else
    {
        return Num;
    }
    return szNum
}
 
//获取日期
macro GetDate()
{
    G_Date = GetSysTime(1)
    Year = G_Date.Year
    Month = FormatNum(G_Date.Month)
    Day = FormatNum(G_Date.Day)
 
    return "@Year@-@Month@-@Day@"
}
 
//获取日期时间
macro GetDateTime(Flag)
{
    G_Time = GetSysTime(1)
    Date = GetDate()
    Hour = FormatNum(G_Time.Hour)
    Minute = FormatNum(G_Time.Minute)
 
    if (Flag)
    {
        Second = FormatNum(G_Time.Second)
        return "@Date@ @Hour@:@Minute@:@Second@"
    }
    else
    {
        return "@Date@ @Hour@:@Minute@"
    }
}
 
//获取文件名
macro GetFileName(PathName)
{
    nLength = strlen(PathName)
    i = nLength - 1
    Name = ""
    while (i + 1)
    {
        ch = PathName[i]
        if ("\\" == "@ch@")
        {
            break
        }
        i = i - 1
    }
 
    i = i + 1
 
    while (i < nLength)
    {
        Name = cat(Name, PathName[i])
        i = i + 1
    }
 
    return Name
}
 
macro CommentFormatNum(Num)
{
    if (Num < 10)
    {
        szNum = "0000@Num@"
    }
    else if (Num < 100)
    {
        szNum = "000@Num@"
    }
    else if (Num < 1000)
    {
        szNum = "00@Num@"
    }
    else if (Num < 10000)
    {
        szNum = "0@Num@"
    }
    else
    {
        return Num
    }
 
    return szNum
}
 
//获取当前文件路径
macro Flinger_GetPath()
{
    hwnd = GetCurrentWnd()
    hbuf = GetCurrentBuf()
    lnFirst = GetWndSelLnFirst(hwnd)
    FilePath = GetBufName(hbuf)
 
    InsBufLine(hbuf, lnFirst + 1, "@FilePath@")
 
    Sel = GetWndSel(hwnd)         //创建一个Selection Record
    Sel.LnFirst = lnFirst + 1;    //赋值起始行
    Sel.LnLast = lnFirst + 1;     //赋值结束行
    Sel.ichFirst = 0;             //赋值选中起始字符
    Sel.ichLim = StrLen(FilePath);    //赋值选中结束字符
 
    SetWndSel(hwnd, Sel)    //设置选中
}
 
//添加自定义代码块注释，以区别是自己改的代码
macro Flinger_ExegesisCode()
{
    lnFirst = GetWndSelLnFirst(GetCurrentWnd())
    hbuf = GetCurrentBuf()
    date = GetDateTime(0);
    InsBufLine(hbuf, lnFirst + 0, "/*========================= Flinger Code Start =========================*/")
    InsBufLine(hbuf, lnFirst + 1, "#ifdef FLINGER_CODE /* @date@ */")
    InsBufLine(hbuf, lnFirst + 2, "")
    InsBufLine(hbuf, lnFirst + 3, "#else    /* #ifdef FLINGER_CODE */")
    InsBufLine(hbuf, lnFirst + 4, "")
    InsBufLine(hbuf, lnFirst + 5, "#endif   /* #ifdef FLINGER_CODE */")
    InsBufLine(hbuf, lnFirst + 6, "/*========================= Flinger Code End   =========================*/")
    SetBufIns(hbuf, lnFirst + 2, 0)
}
 
macro Flinger_CommentBlock()
{
    hbuf = GetCurrentBuf();
    hwnd = GetCurrentWnd();
    sel = GetWndSel(hwnd);
    Time = GetDateTime(0);
    MyName = GetMyName();
 
    //szInfo = "/*  @Time@  By  @MyName@ "       //不支持嵌套
    szInfo = "#if 0    //  @Time@  By  @MyName@"   //支持嵌套
    //szInfo = "#ifndef FLINGER_DEL     //  @Time@  By  @MyName@"
 
    Line = CommentFormatNum(sel.lnFirst + 1)
 
    InsBufLine(hbuf, sel.lnFirst, szInfo)
 
    //InsBufLine(hbuf, sel.lnLast + 2, "*/  //Comment_Start (Line:@Line@)")   //不支持嵌套,改了这必须要改下面的len比较值
    InsBufLine(hbuf, sel.lnLast + 2, "#endif")    //支持嵌套
    //InsBufLine(hbuf, sel.lnLast + 2, "#endif    // #ifndef FLINGER_DEL (Line:@Line@)")
 
    tabSize = 4;
    sel.ichFirst = sel.ichFirst + tabSize;
    sel.ichLim = sel.ichLim + tabSize;
    //SetWndSel(hwnd, sel);
}
 
//文件头部插入信息
macro Flinger_InsertFileHeader()
{
    MyName = GetMyName()
    C_Time = GetSysTime(1)
    Year = C_Time.Year
    E_Year = Year + 1
    Date = GetDateTime(0)
    MyFilename = GetFileName(GetBufName(GetCurrentBuf()))
 
    hbuf = GetCurrentBuf()
    InsBufLine(hbuf, 0, "/*********************************************************************")
    InsBufLine(hbuf, 1, " * 版权所有: Copyright (c) @Year@-@E_Year@  XXX Company. All rights reserved.")
    InsBufLine(hbuf, 2, " * 系统名称: ")
    InsBufLine(hbuf, 3, " * 文件名称: @MyFilename@")
    InsBufLine(hbuf, 4, " * 内容摘要: 简要描述本文件的内容，包括主要模块、函数及其功能的说明")
    InsBufLine(hbuf, 5, " * 当前版本: ")
    InsBufLine(hbuf, 6, " * 作    者: @MyName@")
    InsBufLine(hbuf, 7, " * 设计日期: @Date@")
    InsBufLine(hbuf, 8, " * 修改记录: ")
    InsBufLine(hbuf, 9, " * 日    期          版    本          修改人          修改摘要")
    InsBufLine(hbuf, 10, "**********************************************************************/")
    InsBufLine(hbuf, 11, "")
    InsBufLine(hbuf, 12, "")
    InsBufLine(hbuf, 13, "")
    InsBufLine(hbuf, 14, "")
 
    SetBufIns(hbuf, 2, 20)
}
 
//函数前插入的信息(光标放在函数名 才可获取到函数名信息 否则报错)
macro Flinger_InsertFuncHeader()
{
    MyName = GetMyName()
    Date = GetDateTime(0)
    hbuf = GetCurrentBuf()
    FunName = GetCurSymbol()
    lnFirst = GetSymbolLine(FunName)
    if (lnFirst < 0)
    {
        lnFirst = GetWndSelLnFirst(GetCurrentWnd())
    }
    InsBufLine(hbuf, lnFirst + 0, "")
    InsBufLine(hbuf, lnFirst + 1, "/***********************************************************************")
    InsBufLine(hbuf, lnFirst + 2, " * 函数名称: @FunName@")
    InsBufLine(hbuf, lnFirst + 3, " * 作    者: @MyName@")
    InsBufLine(hbuf, lnFirst + 4, " * 设计日期: @Date@")
    InsBufLine(hbuf, lnFirst + 5, " * 功能描述: ")
    InsBufLine(hbuf, lnFirst + 6, " * 参    数: 多个参数时，参数会有多行")
    InsBufLine(hbuf, lnFirst + 7, " * 返 回 值: ")
    InsBufLine(hbuf, lnFirst + 8, " * 修改日期:          修改人          修改内容")
    InsBufLine(hbuf, lnFirst + 9, " ***********************************************************************/")
 
    SetBufIns(hbuf, lnFirst + 5, 28)
}
 
//头文件布局
macro Flinger_InsertHeaderFileLayout()
{
    Flinger_InsertFileHeader()
    FileHeaderLine = 15
 
    hbuf = GetCurrentBuf()
    InsBufLine(hbuf, 0 +FileHeaderLine, "#ifndef __XXX_H__")
    InsBufLine(hbuf, 1 +FileHeaderLine, "#define __XXX_H__")
    InsBufLine(hbuf, 2 +FileHeaderLine, "/********************************** 其它条件编译选项 ***********************************/")
    InsBufLine(hbuf, 3 +FileHeaderLine, "")
    InsBufLine(hbuf, 4 +FileHeaderLine, "")
    InsBufLine(hbuf, 5 +FileHeaderLine, "/********************************** 标准库头文件 ***********************************/")
    InsBufLine(hbuf, 6 +FileHeaderLine, "#include <xxx.h>")
    InsBufLine(hbuf, 7 +FileHeaderLine, "")
    InsBufLine(hbuf, 8 +FileHeaderLine, "")
    InsBufLine(hbuf, 9 +FileHeaderLine, "/********************************** 非标准库头文件 ***********************************/")
    InsBufLine(hbuf, 10+FileHeaderLine, "#include \"xxx.h\"")
    InsBufLine(hbuf, 11+FileHeaderLine, "")
    InsBufLine(hbuf, 12+FileHeaderLine, "")
    InsBufLine(hbuf, 13+FileHeaderLine, "/********************************** 常量定义 ***********************************/")
    InsBufLine(hbuf, 14+FileHeaderLine, "")
    InsBufLine(hbuf, 15+FileHeaderLine, "")
    InsBufLine(hbuf, 16+FileHeaderLine, "/********************************** 全局宏 ***********************************/")
    InsBufLine(hbuf, 17+FileHeaderLine, "")
    InsBufLine(hbuf, 18+FileHeaderLine, "")
    InsBufLine(hbuf, 19+FileHeaderLine, "/********************************** 数据类型 ***********************************/")
    InsBufLine(hbuf, 20+FileHeaderLine, "")
    InsBufLine(hbuf, 21+FileHeaderLine, "")
    InsBufLine(hbuf, 22+FileHeaderLine, "/********************************** 函数声明 ***********************************/")
    InsBufLine(hbuf, 23+FileHeaderLine, "")
    InsBufLine(hbuf, 24+FileHeaderLine, "")
    InsBufLine(hbuf, 25+FileHeaderLine, "/********************************** 类定义 ***********************************/")
    InsBufLine(hbuf, 26+FileHeaderLine, "")
    InsBufLine(hbuf, 27+FileHeaderLine, "")
    InsBufLine(hbuf, 28+FileHeaderLine, "/********************************** 模板 ***********************************/")
    InsBufLine(hbuf, 29+FileHeaderLine, "")
    InsBufLine(hbuf, 30+FileHeaderLine, "")
    InsBufLine(hbuf, 31+FileHeaderLine, "#endif /* __XXX_H__ */")
    InsBufLine(hbuf, 32+FileHeaderLine, "")
 
    SetBufIns(hbuf, 32+FileHeaderLine, 20)
}
 
//源文件布局
macro Flinger_InsertSourceFileLayout()
{
    Flinger_InsertFileHeader()
    FileHeaderLine = 15
 
    hbuf = GetCurrentBuf()
    InsBufLine(hbuf, 0 +FileHeaderLine, "/********************************** 标准库头文件 ***********************************/")
    InsBufLine(hbuf, 1 +FileHeaderLine, "#include <xxx.h>")
    InsBufLine(hbuf, 2 +FileHeaderLine, "")
    InsBufLine(hbuf, 3 +FileHeaderLine, "")
    InsBufLine(hbuf, 4 +FileHeaderLine, "/********************************** 非标准库头文件 ***********************************/")
    InsBufLine(hbuf, 5 +FileHeaderLine, "#include \"xxx.h\"")
    InsBufLine(hbuf, 6 +FileHeaderLine, "")
    InsBufLine(hbuf, 7 +FileHeaderLine, "")
    InsBufLine(hbuf, 8 +FileHeaderLine, "/********************************** 常量定义 ***********************************/")
    InsBufLine(hbuf, 9 +FileHeaderLine, "")
    InsBufLine(hbuf, 10+FileHeaderLine, "")
    InsBufLine(hbuf, 11+FileHeaderLine, "/********************************** 文件内部使用的宏 ***********************************/")
    InsBufLine(hbuf, 12+FileHeaderLine, "")
    InsBufLine(hbuf, 13+FileHeaderLine, "")
    InsBufLine(hbuf, 14+FileHeaderLine, "/********************************** 文件内部使用的数据类型 ***********************************/")
    InsBufLine(hbuf, 15+FileHeaderLine, "")
    InsBufLine(hbuf, 16+FileHeaderLine, "")
    InsBufLine(hbuf, 17+FileHeaderLine, "/********************************** 静态全局变量 ***********************************/")
    InsBufLine(hbuf, 18+FileHeaderLine, "")
    InsBufLine(hbuf, 19+FileHeaderLine, "")
    InsBufLine(hbuf, 20+FileHeaderLine, "/********************************** 全局变量 ***********************************/")
    InsBufLine(hbuf, 21+FileHeaderLine, "")
    InsBufLine(hbuf, 22+FileHeaderLine, "")
    InsBufLine(hbuf, 23+FileHeaderLine, "/********************************** 局部函数声明 ***********************************/")
    InsBufLine(hbuf, 24+FileHeaderLine, "")
    InsBufLine(hbuf, 25+FileHeaderLine, "")
    InsBufLine(hbuf, 26+FileHeaderLine, "/********************************** 局部函数 ***********************************/")
    InsBufLine(hbuf, 27+FileHeaderLine, "")
    InsBufLine(hbuf, 28+FileHeaderLine, "")
    InsBufLine(hbuf, 29+FileHeaderLine, "/********************************** 全局函数 ***********************************/")
    InsBufLine(hbuf, 30+FileHeaderLine, "")
    InsBufLine(hbuf, 31+FileHeaderLine, "")
    InsBufLine(hbuf, 32+FileHeaderLine, "/********************************** 类的实现 ***********************************/")
    InsBufLine(hbuf, 33+FileHeaderLine, "")
    InsBufLine(hbuf, 34+FileHeaderLine, "")
 
    SetBufIns(hbuf, 34+FileHeaderLine, 20)
}
