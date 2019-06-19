using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

public class Health_DB
{
    #region 私用
    string Hea_ID = string.Empty;
    string Hea_CityNo = string.Empty;
    string Hea_CityName = string.Empty;
    string Hea_10KPeopleBedYear = string.Empty;
    string Hea_10KPeopleBed = string.Empty;
    string Hea_10KPeopleAcuteGeneralBedYear = string.Empty;
    string Hea_10KPeopleAcuteGeneralBed = string.Empty;
    string Hea_10KpeoplePractitionerYear = string.Empty;
    string Hea_10KpeoplePractitioner = string.Empty;
    string Hea_DisabledPersonOfCityRateYear = string.Empty;
    string Hea_DisabledPersonOfCityRate = string.Empty;
    string Hea_LongTermPersonYear = string.Empty;
    string Hea_LongTermPerson = string.Empty;
    string Hea_LongTermPersonOfOldMenRateYear = string.Empty;
    string Hea_LongTermPersonOfOldMenRate = string.Empty;
    string Hea_MedicalInstitutionsYear = string.Empty;
    string Hea_MedicalInstitutions = string.Empty;
    string Hea_MedicalInstitutionsAvgPersonYear = string.Empty;
    string Hea_MedicalInstitutionsAvgPerson = string.Empty;
    string Hea_GOVPayOfNHIYear = string.Empty;
    string Hea_GOVPayOfNHI = string.Empty;
    string Hea_CreateDate = string.Empty;
    string Hea_CreateID = string.Empty;
    string Hea_CreateName = string.Empty;
    string Hea_Status = string.Empty;
    string Hea_Version = string.Empty;
    #endregion
    #region 公用
    public string _Hea_ID
    {
        set { Hea_ID = value; }
    }
    public string _Hea_CityNo
    {
        set { Hea_CityNo = value; }
    }
    public string _Hea_CityName
    {
        set { Hea_CityName = value; }
    }
    public string _Hea_10KPeopleBedYear
    {
        set { Hea_10KPeopleBedYear = value; }
    }
    public string _Hea_10KPeopleBed
    {
        set { Hea_10KPeopleBed = value; }
    }
    public string _Hea_10KPeopleAcuteGeneralBedYear
    {
        set { Hea_10KPeopleAcuteGeneralBedYear = value; }
    }
    public string _Hea_10KPeopleAcuteGeneralBed
    {
        set { Hea_10KPeopleAcuteGeneralBed = value; }
    }
    public string _Hea_10KpeoplePractitionerYear
    {
        set { Hea_10KpeoplePractitionerYear = value; }
    }
    public string _Hea_10KpeoplePractitioner
    {
        set { Hea_10KpeoplePractitioner = value; }
    }
    public string _Hea_DisabledPersonOfCityRateYear
    {
        set { Hea_DisabledPersonOfCityRateYear = value; }
    }
    public string _Hea_DisabledPersonOfCityRate
    {
        set { Hea_DisabledPersonOfCityRate = value; }
    }
    public string _Hea_LongTermPersonYear
    {
        set { Hea_LongTermPersonYear = value; }
    }
    public string _Hea_LongTermPerson
    {
        set { Hea_LongTermPerson = value; }
    }
    public string _Hea_LongTermPersonOfOldMenRateYear
    {
        set { Hea_LongTermPersonOfOldMenRateYear = value; }
    }
    public string _Hea_LongTermPersonOfOldMenRate
    {
        set { Hea_LongTermPersonOfOldMenRate = value; }
    }
    public string _Hea_MedicalInstitutionsYear
    {
        set { Hea_MedicalInstitutionsYear = value; }
    }
    public string _Hea_MedicalInstitutions
    {
        set { Hea_MedicalInstitutions = value; }
    }
    public string _Hea_MedicalInstitutionsAvgPersonYear
    {
        set { Hea_MedicalInstitutionsAvgPersonYear = value; }
    }
    public string _Hea_MedicalInstitutionsAvgPerson
    {
        set { Hea_MedicalInstitutionsAvgPerson = value; }
    }
    public string _Hea_GOVPayOfNHIYear
    {
        set { Hea_GOVPayOfNHIYear = value; }
    }
    public string _Hea_GOVPayOfNHI
    {
        set { Hea_GOVPayOfNHI = value; }
    }
    public string _Hea_CreateDate
    {
        set { Hea_CreateDate = value; }
    }
    public string _Hea_CreateID
    {
        set { Hea_CreateID = value; }
    }
    public string _Hea_CreateName
    {
        set { Hea_CreateName = value; }
    }
    public string _Hea_Status
    {
        set { Hea_Status = value; }
    }
    public string _Hea_Version
    {
        set { Hea_Version = value; }
    }
    #endregion


    //取得當前最大版次
    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(Hea_Version) as strMax from Health where Hea_Status='A'
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
    
    //取得健康列表資料
    public DataTable getHealthList()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        if (Hea_CityNo == "02")
        {
            sb.Append(@"select * from Health where Hea_CityNo='02' and Hea_Status='A'");
        }

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oda.Fill(dt);
        return dt;
    }
}