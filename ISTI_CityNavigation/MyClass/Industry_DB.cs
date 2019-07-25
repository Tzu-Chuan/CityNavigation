using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

public class Industry_DB
{
    #region 私用
    string Ind_ID = string.Empty;
    string Ind_CityNo = string.Empty;
    string Ind_CityName = string.Empty;
    string Ind_BusinessYear = string.Empty;
    string Ind_Business = string.Empty;
    string Ind_FactoryYear = string.Empty;
    string Ind_Factory = string.Empty;
    string Ind_IncomeYear = string.Empty;
    string Ind_Income = string.Empty;
    string Ind_SalesYear = string.Empty;
    string Ind_Sales = string.Empty;
    string Ind_CreateDate = string.Empty;
    string Ind_CreateID = string.Empty;
    string Ind_CreateName = string.Empty;
    string Ind_Status = string.Empty;
    string Ind_Version = string.Empty;
    #endregion

    #region 公用
    public string _Ind_ID
    {
        set { Ind_ID = value; }
    }
    public string _Ind_CityNo
    {
        set { Ind_CityNo = value; }
    }
    public string _Ind_CityName
    {
        set { Ind_CityName = value; }
    }
    public string _Ind_BusinessYear
    {
        set { Ind_BusinessYear = value; }
    }
    public string _Ind_Business
    {
        set { Ind_Business = value; }
    }
    public string _Ind_FactoryYear
    {
        set { Ind_FactoryYear = value; }
    }
    public string _Ind_Factory
    {
        set { Ind_Factory = value; }
    }
    public string _Ind_IncomeYear
    {
        set { Ind_IncomeYear = value; }
    }
    public string _Ind_Income
    {
        set { Ind_Income = value; }
    }
    public string _Ind_SalesYear
    {
        set { Ind_SalesYear = value; }
    }
    public string _Ind_Sales
    {
        set { Ind_Sales = value; }
    }
    public string _Ind_CreateDate
    {
        set { Ind_CreateDate = value; }
    }
    public string _Ind_CreateID
    {
        set { Ind_CreateID = value; }
    }
    public string _Ind_CreateName
    {
        set { Ind_CreateName = value; }
    }
    public string _Ind_Status
    {
        set { Ind_Status = value; }
    }
    public string _Ind_Version
    {
        set { Ind_Version = value; }
    }
    #endregion

    //取得當前最大版次
    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(Ind_Version) as strMax from Industry where Ind_Status='A'
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
    
    //取得產業列表資料
    public DataTable getIndustryList()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Industry where Ind_CityNo=@Ind_CityNo and Ind_Status='A'");
        oCmd.Parameters.AddWithValue("@Ind_CityNo", Ind_CityNo);


        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }

    public DataTable getIndustry_All(string sortName, string sortMethod)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();
        if(sortName!= "Ind_Business")
            sb.Append(@"select * from Industry where Ind_Status='A' order by convert(float," + sortName + @") " + sortMethod);
        else
            sb.Append(@"select * from Industry where Ind_Status='A' order by (" + sortName + @") " + sortMethod);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }
}
