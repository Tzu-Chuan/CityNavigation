using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

public class CitySubMoney_DB
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string C_ID = string.Empty;
    string C_City = string.Empty;
    string C_PlanCount_NotAll = string.Empty;
    string C_SubMoney_NotAll = string.Empty;
    string C_PlanMoney_NotAll = string.Empty;
    string C_AssignSubMoney = string.Empty;
    string C_AssignTotalMoney = string.Empty;
    string C_CitySubMoneyRatio_NotAll = string.Empty;
    string C_CityTotalMoneyRatio_NotAll = string.Empty;
    string C_PlanCount = string.Empty;
    string C_SubMoney = string.Empty;
    string C_PlanMoney = string.Empty;
    string C_CitySubMoneyRatio = string.Empty;
    string C_CityTotalMoneyRatio = string.Empty;
    string C_CreateId = string.Empty;
    string C_CreateName = string.Empty;
    int C_Version;
    string C_Status = string.Empty;

    DateTime C_CreateDate;
    #endregion
    #region 公用
    public string _C_ID
    {
        set { C_ID = value; }
    }
    public string _C_City
    {
        set { C_City = value; }
    }
    public string _C_PlanCount_NotAll
    {
        set { C_PlanCount_NotAll = value; }
    }
    public string _C_SubMoney_NotAll
    {
        set { C_SubMoney_NotAll = value; }
    }
    public string _C_PlanMoney_NotAll
    {
        set { C_PlanMoney_NotAll = value; }
    }
    public string _C_AssignSubMoney
    {
        set { C_AssignSubMoney = value; }
    }
    public string _C_AssignTotalMoney
    {
        set { C_AssignTotalMoney = value; }
    }
    public string _C_CitySubMoneyRatio_NotAll
    {
        set { C_CitySubMoneyRatio_NotAll = value; }
    }
    public string _C_CityTotalMoneyRatio_NotAll
    {
        set { C_CityTotalMoneyRatio_NotAll = value; }
    }
    public string _C_PlanCount
    {
        set { C_PlanCount = value; }
    }
    public string _C_SubMoney
    {
        set { C_SubMoney = value; }
    }
    public string _C_PlanMoney
    {
        set { C_PlanMoney = value; }
    }
    public string _C_CitySubMoneyRatio
    {
        set { C_CitySubMoneyRatio = value; }
    }
    public string _C_CityTotalMoneyRatio
    {
        set { C_CityTotalMoneyRatio = value; }
    }
    public string _C_CreateId
    {
        set { C_CreateId = value; }
    }
    public string _C_CreateName
    {
        set { C_CreateName = value; }
    }
    public int _C_Version
    {
        set { C_Version = value; }
    }
    public string _C_Status
    {
        set { C_Status = value; }
    }
    public DateTime _C_CreateDate
    {
        set { C_CreateDate = value; }
    }
    #endregion

}