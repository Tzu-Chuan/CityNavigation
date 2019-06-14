using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
public class Farming_DB
{
    #region 私用
    string Fa_ID = string.Empty;
    string Fa_CityNo = string.Empty;
    string Fa_CityName = string.Empty;
    string Fa_FarmingLossYear = string.Empty;
    string Fa_FarmingLoss = string.Empty;
    string Fa_AnimalLossYear = string.Empty;
    string Fa_AnimalLoss = string.Empty;
    string Fa_FishLossYear = string.Empty;
    string Fa_FishLoss = string.Empty;
    string Fa_ForestLossYear = string.Empty;
    string Fa_ForestLoss = string.Empty;
    string Fa_AllLossYear = string.Empty;
    string Fa_AllLoss = string.Empty;
    string Fa_FacilityLossYear = string.Empty;
    string Fa_FacilityLoss = string.Empty;
    string Fa_FarmingOutputValueYear = string.Empty;
    string Fa_FarmingOutputValue = string.Empty;
    string Fa_FarmingOutputRateYear = string.Empty;
    string Fa_FarmingOutputRate = string.Empty;
    string Fa_FarmerYear = string.Empty;
    string Fa_Farmer = string.Empty;
    string Fa_FarmEmploymentOutputValueYear = string.Empty;
    string Fa_FarmEmploymentOutputValue = string.Empty;
    string Fa_CreateDate = string.Empty;
    string Fa_CreateID = string.Empty;
    string Fa_CreateName = string.Empty;
    string Fa_Status = string.Empty;
    string Fa_Version = string.Empty;
    #endregion

    #region 公用
    public string _Fa_ID
    {
        set { Fa_ID = value; }
    }
    public string _Fa_CityNo
    {
        set { Fa_CityNo = value; }
    }
    public string _Fa_CityName
    {
        set { Fa_CityName = value; }
    }
    public string _Fa_FarmingLossYear
    {
        set { Fa_FarmingLossYear = value; }
    }
    public string _Fa_FarmingLoss
    {
        set { Fa_FarmingLoss = value; }
    }
    public string _Fa_AnimalLossYear
    {
        set { Fa_AnimalLossYear = value; }
    }
    public string _Fa_AnimalLoss
    {
        set { Fa_AnimalLoss = value; }
    }
    public string _Fa_FishLossYear
    {
        set { Fa_FishLossYear = value; }
    }
    public string _Fa_FishLoss
    {
        set { Fa_FishLoss = value; }
    }
    public string _Fa_ForestLossYear
    {
        set { Fa_ForestLossYear = value; }
    }
    public string _Fa_ForestLoss
    {
        set { Fa_ForestLoss = value; }
    }
    public string _Fa_AllLossYear
    {
        set { Fa_AllLossYear = value; }
    }
    public string _Fa_AllLoss
    {
        set { Fa_AllLoss = value; }
    }
    public string _Fa_FacilityLossYear
    {
        set { Fa_FacilityLossYear = value; }
    }
    public string _Fa_FacilityLoss
    {
        set { Fa_FacilityLoss = value; }
    }
    public string _Fa_FarmingOutputValueYear
    {
        set { Fa_FarmingOutputValueYear = value; }
    }
    public string _Fa_FarmingOutputValue
    {
        set { Fa_FarmingOutputValue = value; }
    }
    public string _Fa_FarmingOutputRateYear
    {
        set { Fa_FarmingOutputRateYear = value; }
    }
    public string _Fa_FarmingOutputRate
    {
        set { Fa_FarmingOutputRate = value; }
    }
    public string _Fa_FarmerYear
    {
        set { Fa_FarmerYear = value; }
    }
    public string _Fa_Farmer
    {
        set { Fa_Farmer = value; }
    }
    public string _Fa_FarmEmploymentOutputValueYear
    {
        set { Fa_FarmEmploymentOutputValueYear = value; }
    }
    public string _Fa_FarmEmploymentOutputValue
    {
        set { Fa_FarmEmploymentOutputValue = value; }
    }
    public string _Fa_CreateDate
    {
        set { Fa_CreateDate = value; }
    }
    public string _Fa_CreateID
    {
        set { Fa_CreateID = value; }
    }
    public string _Fa_CreateName
    {
        set { Fa_CreateName = value; }
    }
    public string _Fa_Status
    {
        set { Fa_Status = value; }
    }
    public string _Fa_Version
    {
        set { Fa_Version = value; }
    }
    #endregion

    //取得當前最大版次
    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(Fa_Version) as strMax from Farming where Fa_Status='A'
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

}
