using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

public class Retail_DB
{
    #region 私用
    string Re_ID = string.Empty;
    string Re_CityNo = string.Empty;
    string Re_CityName = string.Empty;
    string Re_StreetStandYear = string.Empty;
    string Re_StreetStand = string.Empty;
    string Re_Re_StreetVendorYear = string.Empty;
    string Re_StreetVendor = string.Empty;
    string Re_StreetVendorIncomeYear = string.Empty;
    string Re_StreetVendorIncome = string.Empty;
    string Re_StreetVendorAvgIncomeYear = string.Empty;
    string Re_StreetVendorAvgIncome = string.Empty;
    string Re_RetailBusinessSalesYear = string.Empty;
    string Re_RetailBusinessSales = string.Empty;
    string Re_RetailBusinessSalesRateYearDesc = string.Empty;
    string Re_RetailBusinessSalesRate = string.Empty;
    string Re_RetailBusinessAvgSalesYear = string.Empty;
    string Re_RetailBusinessAvgSales = string.Empty;
    string Re_CreateDate = string.Empty;
    string Re_CreateID = string.Empty;
    string Re_CreateName = string.Empty;
    string Re_Status = string.Empty;
    string Re_Version = string.Empty;
    #endregion
    #region 公用
    public string _Re_ID
    {
        set { Re_ID = value; }
    }
    public string _Re_CityNo
    {
        set { Re_CityNo = value; }
    }
    public string _Re_CityName
    {
        set { Re_CityName = value; }
    }
    public string _Re_StreetStandYear
    {
        set { Re_StreetStandYear = value; }
    }
    public string _Re_StreetStand
    {
        set { Re_StreetStand = value; }
    }
    public string _Re_Re_StreetVendorYear
    {
        set { Re_Re_StreetVendorYear = value; }
    }
    public string _Re_StreetVendor
    {
        set { Re_StreetVendor = value; }
    }
    public string _Re_StreetVendorIncomeYear
    {
        set { Re_StreetVendorIncomeYear = value; }
    }
    public string _Re_StreetVendorIncome
    {
        set { Re_StreetVendorIncome = value; }
    }
    public string _Re_StreetVendorAvgIncomeYear
    {
        set { Re_StreetVendorAvgIncomeYear = value; }
    }
    public string _Re_StreetVendorAvgIncome
    {
        set { Re_StreetVendorAvgIncome = value; }
    }
    public string _Re_RetailBusinessSalesYear
    {
        set { Re_RetailBusinessSalesYear = value; }
    }
    public string _Re_RetailBusinessSales
    {
        set { Re_RetailBusinessSales = value; }
    }
    public string _Re_RetailBusinessSalesRateYearDesc
    {
        set { Re_RetailBusinessSalesRateYearDesc = value; }
    }
    public string _Re_RetailBusinessSalesRate
    {
        set { Re_RetailBusinessSalesRate = value; }
    }
    public string _Re_RetailBusinessAvgSalesYear
    {
        set { Re_RetailBusinessAvgSalesYear = value; }
    }
    public string _Re_RetailBusinessAvgSales
    {
        set { Re_RetailBusinessAvgSales = value; }
    }
    public string _Re_CreateDate
    {
        set { Re_CreateDate = value; }
    }
    public string _Re_CreateID
    {
        set { Re_CreateID = value; }
    }
    public string _Re_CreateName
    {
        set { Re_CreateName = value; }
    }
    public string _Re_Status
    {
        set { Re_Status = value; }
    }
    public string _Re_Version
    {
        set { Re_Version = value; }
    }
    #endregion


    //取得當前最大版次
    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(Re_Version) as strMax from Retail where Re_Status='A'
        ");


        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);

        int strMaxNum = 0;
        if (dt.Rows[0]["strMax"].ToString().Trim() != "")
        {
            strMaxNum = Convert.ToInt32(dt.Rows[0]["strMax"].ToString().Trim());
        }

        return strMaxNum;
    }
    
    //取得零售列表資料
    public DataTable getRetailList()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Retail where Re_CityNo=@Re_CityNo and Re_Status='A'");
        oCmd.Parameters.AddWithValue("@Re_CityNo", Re_CityNo);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }

    public DataTable getRetai_All(string sortName, string sortMethod)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Retail where Re_Status='A' order by convert(int," + sortName + @") " + sortMethod);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }
}