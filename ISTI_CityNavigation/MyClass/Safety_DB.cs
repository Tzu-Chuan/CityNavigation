using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

public class Safety_DB
{
    #region 私用
    string Sf_ID = string.Empty;
    string Sf_CityNo = string.Empty;
    string Sf_CityName = string.Empty;
    string Sf_SoilAreaYear = string.Empty;
    string Sf_SoilArea = string.Empty;
    string Sf_UnderWaterAreaYear = string.Empty;
    string Sf_UnderWaterArea = string.Empty;
    string Sf_PM25QuantityYear = string.Empty;
    string Sf_PM25Quantity = string.Empty;
    string Sf_10KPeopleFireTimesYear = string.Empty;
    string Sf_10KPeopleFireTimes = string.Empty;
    string Sf_100KPeopleBurglaryTimesYear = string.Empty;
    string Sf_100KPeopleBurglaryTimes = string.Empty;
    string Sf_BurglaryClearanceRateYear = string.Empty;
    string Sf_BurglaryClearanceRate = string.Empty;
    string Sf_100KPeopleCriminalCaseTimesYear = string.Empty;
    string Sf_100KPeopleCriminalCaseTimes = string.Empty;
    string Sf_CriminalCaseClearanceRateYear = string.Empty;
    string Sf_CriminalCaseClearanceRate = string.Empty;
    string Sf_100KPeopleViolentCrimesTimesYear = string.Empty;
    string Sf_100KPeopleViolentCrimesTimes = string.Empty;
    string Sf_ViolentCrimesClearanceRateYear = string.Empty;
    string Sf_ViolentCrimesClearanceRate = string.Empty;
    string Sf_CreateDate = string.Empty;
    string Sf_CreateID = string.Empty;
    string Sf_CreateName = string.Empty;
    string Sf_Status = string.Empty;
    string Sf_Version = string.Empty;
    #endregion
    #region 公用
    public string _Sf_ID
    {
        set { Sf_ID = value; }
    }
    public string _Sf_CityNo
    {
        set { Sf_CityNo = value; }
    }
    public string _Sf_CityName
    {
        set { Sf_CityName = value; }
    }
    public string _Sf_SoilAreaYear
    {
        set { Sf_SoilAreaYear = value; }
    }
    public string _Sf_SoilArea
    {
        set { Sf_SoilArea = value; }
    }
    public string _Sf_UnderWaterAreaYear
    {
        set { Sf_UnderWaterAreaYear = value; }
    }
    public string _Sf_UnderWaterArea
    {
        set { Sf_UnderWaterArea = value; }
    }
    public string _Sf_PM25QuantityYear
    {
        set { Sf_PM25QuantityYear = value; }
    }
    public string _Sf_PM25Quantity
    {
        set { Sf_PM25Quantity = value; }
    }
    public string _Sf_10KPeopleFireTimesYear
    {
        set { Sf_10KPeopleFireTimesYear = value; }
    }
    public string _Sf_10KPeopleFireTimes
    {
        set { Sf_10KPeopleFireTimes = value; }
    }
    public string _Sf_100KPeopleBurglaryTimesYear
    {
        set { Sf_100KPeopleBurglaryTimesYear = value; }
    }
    public string _Sf_100KPeopleBurglaryTimes
    {
        set { Sf_100KPeopleBurglaryTimes = value; }
    }
    public string _Sf_BurglaryClearanceRateYear
    {
        set { Sf_BurglaryClearanceRateYear = value; }
    }
    public string _Sf_BurglaryClearanceRate
    {
        set { Sf_BurglaryClearanceRate = value; }
    }
    public string _Sf_100KPeopleCriminalCaseTimesYeart
    {
        set { Sf_100KPeopleCriminalCaseTimesYear = value; }
    }
    public string _Sf_100KPeopleCriminalCaseTimes
    {
        set { Sf_100KPeopleCriminalCaseTimes = value; }
    }
    public string _Sf_CriminalCaseClearanceRateYear
    {
        set { Sf_CriminalCaseClearanceRateYear = value; }
    }
    public string _Sf_CriminalCaseClearanceRate
    {
        set { Sf_CriminalCaseClearanceRate = value; }
    }
    public string _Sf_100KPeopleViolentCrimesTimesYear
    {
        set { Sf_100KPeopleViolentCrimesTimesYear = value; }
    }
    public string _Sf_100KPeopleViolentCrimesTimes
    {
        set { Sf_100KPeopleViolentCrimesTimes = value; }
    }
    public string _Sf_ViolentCrimesClearanceRateYear
    {
        set { Sf_ViolentCrimesClearanceRateYear = value; }
    }
    public string _Sf_ViolentCrimesClearanceRate
    {
        set { Sf_ViolentCrimesClearanceRate = value; }
    }
    public string _Sf_CreateDate
    {
        set { Sf_CreateDate = value; }
    }
    public string _Sf_CreateID
    {
        set { Sf_CreateID = value; }
    }
    public string _Sf_CreateName
    {
        set { Sf_CreateName = value; }
    }
    public string _Sf_Status
    {
        set { Sf_Status = value; }
    }
    public string _Sf_Version
    {
        set { Sf_Version = value; }
    }
    #endregion


    //取得當前最大版次
    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(Sf_Version) as strMax from Safety where Sf_Status='A'
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

    //取得智慧安全、治理列表資料
    public DataTable getSafetyList()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Safety where Sf_CityNo=@Sf_CityNo and Sf_Status='A'");
        oCmd.Parameters.AddWithValue("@Sf_CityNo", Sf_CityNo);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }

    public DataTable getSafety_All(string sortName, string sortMethod)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Safety where Sf_Status='A' order by convert(float,case " + sortName + @" when '─' then '0' else " + sortName + @" end) " + sortMethod);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }
}