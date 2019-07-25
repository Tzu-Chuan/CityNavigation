using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

public class Energy_DB
{
    #region 私用
    string Ene_ID = string.Empty;
    string Ene_CityNo = string.Empty;
    string Ene_CityName = string.Empty;
    string Ene_DeviceCapacityNumYear = string.Empty;
    string Ene_DeviceCapacityNum = string.Empty;
    string Ene_TPCBuyElectricityYear = string.Empty;
    string Ene_TPCBuyElectricity = string.Empty;
    string Ene_ElectricityUsedYear = string.Empty;
    string Ene_ElectricityUsed = string.Empty;
    string Ene_ReEnergyOfElectricityRateYear = string.Empty;
    string Ene_ReEnergyOfElectricityRate = string.Empty;
    string Ene_CreateDate = string.Empty;
    string Ene_CreateID = string.Empty;
    string Ene_CreateName = string.Empty;
    string Ene_Status = string.Empty;
    string Ene_Version = string.Empty;
    #endregion
    #region 公用

    public string _Ene_ID
    {
        set { Ene_ID = value; }
    }
    public string _Ene_CityNo
    {
        set { Ene_CityNo = value; }
    }
    public string _Ene_CityName
    {
        set { Ene_CityName = value; }
    }
    public string _Ene_DeviceCapacityNumYear
    {
        set { Ene_DeviceCapacityNumYear = value; }
    }
    public string _Ene_DeviceCapacityNum
    {
        set { Ene_DeviceCapacityNum = value; }
    }
    public string _Ene_TPCBuyElectricityYear
    {
        set { Ene_TPCBuyElectricityYear = value; }
    }
    public string _Ene_TPCBuyElectricity
    {
        set { Ene_TPCBuyElectricity = value; }
    }
    public string _Ene_ElectricityUsedYear
    {
        set { Ene_ElectricityUsedYear = value; }
    }
    public string _Ene_ElectricityUsed
    {
        set { Ene_ElectricityUsed = value; }
    }
    public string _Ene_ReEnergyOfElectricityRateYear
    {
        set { Ene_ReEnergyOfElectricityRateYear = value; }
    }
    public string _Ene_ReEnergyOfElectricityRate
    {
        set { Ene_ReEnergyOfElectricityRate = value; }
    }
    public string _Ene_CreateDate
    {
        set { Ene_CreateDate = value; }
    }
    public string _Ene_CreateID
    {
        set { Ene_CreateID = value; }
    }
    public string _Ene_CreateName
    {
        set { Ene_CreateName = value; }
    }
    public string _Ene_Status
    {
        set { Ene_Status = value; }
    }
    public string _Ene_Version
    {
        set { Ene_Version = value; }
    }
    #endregion


    //取得當前最大版次
    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(Ene_Version) as strMax from Energy where Ene_Status='A'
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
    
    //取得能源列表資料
    public DataTable getEnergyList()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Energy where Ene_CityNo=@Ene_CityNo and Ene_Status='A'");
        oCmd.Parameters.AddWithValue("@Ene_CityNo", Ene_CityNo);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }

    public DataTable getEnergy_All(string sortName, string sortMethod)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select * from Energy where Ene_Status='A' order by convert(float," + sortName + @") " + sortMethod);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }
}