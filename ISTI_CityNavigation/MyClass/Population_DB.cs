using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;


public class Population_DB
{
    #region 私用
    string P_ID = string.Empty;
    string P_CityNo = string.Empty;
    string P_CityName = string.Empty;
    string P_AreaYear = string.Empty;
    string P_Area = string.Empty;
    string P_TotalYear = string.Empty;
    string P_PeopleTotal = string.Empty;
    string P_PeopleTotalPercentYear = string.Empty;
    string P_PeopleTotalPercent = string.Empty;
    string P_Year = string.Empty;
    string P_Child = string.Empty;
    string P_ChildPercent = string.Empty;
    string P_Teenager = string.Empty;
    string P_TeenagerPercent = string.Empty;
    string P_OldMen = string.Empty;
    string P_OldMenPercent = string.Empty;
    string P_CreateDate = string.Empty;
    string P_CreateID = string.Empty;
    string P_CreateName = string.Empty;
    string P_Status = string.Empty;
    string P_Version = string.Empty;
    #endregion
    #region 公用
    public string _P_ID
    {
        set { P_ID = value; }
    }
    public string _P_CityNo
    {
        set { P_CityNo = value; }
    }
    public string _P_CityName
    {
        set { P_CityName = value; }
    }
    public string _P_AreaYear
    {
        set { P_AreaYear = value; }
    }
    public string _P_Area
    {
        set { P_Area = value; }
    }
    public string _P_TotalYear
    {
        set { P_TotalYear = value; }
    }
    public string _P_PeopleTotal
    {
        set { P_PeopleTotal = value; }
    }
    public string _P_PeopleTotalPercentYear
    {
        set { P_PeopleTotalPercentYear = value; }
    }
    public string _P_PeopleTotalPercent
    {
        set { P_PeopleTotalPercent = value; }
    }
    public string _P_Year
    {
        set { P_Year = value; }
    }
    public string _P_Child
    {
        set { P_Child = value; }
    }
    public string _P_ChildPercent
    {
        set { P_ChildPercent = value; }
    }
    public string _P_Teenager
    {
        set { P_Teenager = value; }
    }
    public string _P_TeenagerPercent
    {
        set { P_TeenagerPercent = value; }
    }
    public string _P_OldMen
    {
        set { P_OldMen = value; }
    }
    public string _P_OldMenPercent
    {
        set { P_OldMenPercent = value; }
    }
    public string _P_CreateDate
    {
        set { P_CreateDate = value; }
    }
    public string _P_CreateID
    {
        set { P_CreateID = value; }
    }
    public string _P_CreateName
    {
        set { P_CreateName = value; }
    }
    public string _P_Status
    {
        set { P_Status = value; }
    }
    public string _P_Version
    {
        set { P_Version = value; }
    }
    #endregion


    //取得當前最大版次
    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(P_Version) as strMax from Population where P_Status='A'
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

    //取得人口總數列表資料
    public DataTable getPopulationList(string sortName, string sortMethod)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();
        if (P_CityNo == "All")
        {
            sb.Append(@"select * from Population order by " + sortName + @" " + sortMethod + @"");
        }
        else {
            sb.Append(@"select * from Population where P_CityNo=@P_CityNo and P_Status='A'");
            oCmd.Parameters.AddWithValue("@P_CityNo", P_CityNo);
        }
        
        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }
}

    
