using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

public class Mayor_DB
{
    #region 私用
    string MR_ID = string.Empty;
    string MR_CityNo = string.Empty;
    string MR_CityName = string.Empty;
    string MR_MayorYear = string.Empty;
    string MR_Mayor = string.Empty;
    string MR_ViceMayorYear = string.Empty;
    string MR_ViceMayor = string.Empty;
    string MR_PoliticalPartyYear = string.Empty;
    string MR_PoliticalParty = string.Empty;
    string MR_AdAreaYear = string.Empty;
    string MR_AdArea = string.Empty;
    string MR_CreateDate = string.Empty;
    string MR_CreateID = string.Empty;
    string MR_CreateName = string.Empty;
    string MR_Status = string.Empty;
    string MR_Version = string.Empty;
    #endregion
    #region 公用
    public string _MR_ID
    {
        set { MR_ID = value; }
    }
    public string _MR_CityNo
    {
        set { MR_CityNo = value; }
    }
    public string _MR_CityName
    {
        set { MR_CityName = value; }
    }
    public string _MR_MayorYear
    {
        set { MR_MayorYear = value; }
    }
    public string _MR_Mayor
    {
        set { MR_Mayor = value; }
    }
    public string _MR_ViceMayorYear
    {
        set { MR_ViceMayorYear = value; }
    }
    public string _MR_ViceMayor
    {
        set { MR_ViceMayor = value; }
    }
    public string _MR_PoliticalPartyYear
    {
        set { MR_PoliticalPartyYear = value; }
    }
    public string _MR_PoliticalParty
    {
        set { MR_PoliticalParty = value; }
    }
    public string _MR_AdAreaYear
    {
        set { MR_AdAreaYear = value; }
    }
    public string _MR_AdArea
    {
        set { MR_AdArea = value; }
    }
    public string _MR_CreateDate
    {
        set { MR_CreateDate = value; }
    }
    public string _MR_CreateID
    {
        set { MR_CreateID = value; }
    }
    public string _MR_CreateName
    {
        set { MR_CreateName = value; }
    }
    public string _MR_Status
    {
        set { MR_Status = value; }
    }
    public string _MR_Version
    {
        set { MR_Version = value; }
    }
    #endregion


    //取得當前最大版次
    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(MR_Version) as strMax from Mayor where MR_Status='A'
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
    
    //取得交通總數列表資料
    public DataTable getMayorList()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();
        
        sb.Append(@"select * from Mayor where MR_CityNo=@MR_CityNo and MR_Status='A'");
        
        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oCmd.Parameters.AddWithValue("@MR_CityNo", MR_CityNo);

        oda.Fill(dt);
        return dt;
    }
}
