using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

public class Traffic_DB
{
    #region 私用
    string Tra_ID = string.Empty;
    string Tra_CityNo = string.Empty;
    string Tra_CityName = string.Empty;
    string Tra_PublicTransportRateYear = string.Empty;
    string Tra_PublicTransportRate = string.Empty;
    string Tra_CarParkTimeYear = string.Empty;
    string Tra_CarParkTime = string.Empty;
    string Tra_CarParkSpaceYear = string.Empty;
    string Tra_CarParkSpace = string.Empty;
    string Tra_10KHaveCarParkYear = string.Empty;
    string Tra_10KHaveCarPark = string.Empty;
    string Tra_CarCountYear = string.Empty;
    string Tra_CarCount = string.Empty;
    string Tra_100HaveCarYear = string.Empty;
    string Tra_100HaveCar = string.Empty;
    string Tra_100HaveCarRateYear = string.Empty;
    string Tra_100HaveCarRateDec = string.Empty;
    string Tra_100HaveCarRate = string.Empty;
    string Tra_10KMotoIncidentsNumYear = string.Empty;
    string Tra_10KMotoIncidentsNum = string.Empty;
    string Tra_100KNumberOfCasualtiesYear = string.Empty;
    string Tra_100KNumberOfCasualties = string.Empty;
    string Tra_CreateDate = string.Empty;
    string Tra_CreateID = string.Empty;
    string Tra_CreateName = string.Empty;
    string Tra_Status = string.Empty;
    string Tra_Version = string.Empty;
    #endregion
        
    #region 公用
    public string _Tra_ID
    {
        set { Tra_ID = value; }
    }
    public string _Tra_CityNo
    {
        set { Tra_CityNo = value; }
    }
    public string _Tra_CityName
    {
        set { Tra_CityName = value; }
    }
    public string _Tra_PublicTransportRateYear
    {
        set { Tra_PublicTransportRateYear = value; }
    }
    public string _Tra_PublicTransportRate
    {
        set { Tra_PublicTransportRate = value; }
    }
    public string _Tra_CarParkTimeYear
    {
        set { Tra_CarParkTimeYear = value; }
    }
    public string _Tra_CarParkTime
    {
        set { Tra_CarParkTime = value; }
    }
    public string _Tra_CarParkSpaceYear
    {
        set { Tra_CarParkSpaceYear = value; }
    }
    public string _Tra_CarParkSpace
    {
        set { Tra_CarParkSpace = value; }
    }
    public string _Tra_10KHaveCarParkYear
    {
        set { Tra_10KHaveCarParkYear = value; }
    }
    public string _Tra_10KHaveCarPark
    {
        set { Tra_10KHaveCarPark = value; }
    }
    public string _Tra_CarCountYear
    {
        set { Tra_CarCountYear = value; }
    }
    public string _Tra_CarCount
    {
        set { Tra_CarCount = value; }
    }
    public string _Tra_100HaveCarYear
    {
        set { Tra_100HaveCarYear = value; }
    }
    public string _Tra_100HaveCar
    {
        set { Tra_100HaveCar = value; }
    }
    public string _Tra_100HaveCarRateYear
    {
        set { Tra_100HaveCarRateYear = value; }
    }
    public string _Tra_100HaveCarRateDec
    {
        set { Tra_100HaveCarRateDec = value; }
    }
    public string _Tra_100HaveCarRate
    {
        set { Tra_100HaveCarRate = value; }
    }
    public string _Tra_10KMotoIncidentsNumYear
    {
        set { Tra_10KMotoIncidentsNumYear = value; }
    }
    public string _Tra_10KMotoIncidentsNum
    {
        set { Tra_10KMotoIncidentsNum = value; }
    }
    public string _Tra_100KNumberOfCasualtiesYear
    {
        set { Tra_100KNumberOfCasualtiesYear = value; }
    }
    public string _Tra_100KNumberOfCasualties
    {
        set { Tra_100KNumberOfCasualties = value; }
    }
    public string _Tra_CreateDate
    {
        set { Tra_CreateDate = value; }
    }
    public string _Tra_CreateID
    {
        set { Tra_CreateID = value; }
    }
    public string _Tra_CreateName
    {
        set { Tra_CreateName = value; }
    }
    public string _Tra_Status
    {
        set { Tra_Status = value; }
    }
    public string _Tra_Version
    {
        set { Tra_Version = value; }
    }
    #endregion

    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(Tra_Version) as strMax from Traffic where Tra_Status='A'
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
    public DataTable getTrafficList()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Traffic where Tra_CityNo=@Tra_CityNo and Tra_Status='A'");
        oCmd.Parameters.AddWithValue("@Tra_CityNo", Tra_CityNo);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }

    public DataTable getTraffic_All(string sortName, string sortMethod)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Traffic where Tra_Status='A' order by convert(int," + sortName + @") " + sortMethod);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }
}
