using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

public class Education_DB
{
    #region 私用
    string Edu_ID = string.Empty;
    string Edu_CityNo = string.Empty;
    string Edu_CityName = string.Empty;
    string Edu_15upJSDownRateYear = string.Empty;
    string Edu_15upJSDownRate = string.Empty;
    string Edu_15upHSRateYear = string.Empty;
    string Edu_15upHSRate = string.Empty;
    string Edu_15upUSUpRateYear = string.Empty;
    string Edu_15upUSUpRate = string.Empty;
    string Edu_ESStudentDropOutRateYear = string.Empty;
    string Edu_ESStudentDropOutRate = string.Empty;
    string Edu_JSStudentDropOutRateYear = string.Empty;
    string Edu_JSStudentDropOutRate = string.Empty;
    string Edu_ESStudentsYear = string.Empty;
    string Edu_ESStudents = string.Empty;
    string Edu_JSStudentsYear = string.Empty;
    string Edu_JSStudents = string.Empty;
    string Edu_HSStudentsYear = string.Empty;
    string Edu_HSStudents = string.Empty;
    string Edu_ESToHSIndigenousYear = string.Empty;
    string Edu_ESToHSIdigenous = string.Empty;
    string Edu_ESToHSIndigenousRateYear = string.Empty;
    string Edu_ESToHSIndigenousRate = string.Empty;
    string Edu_ESJSNewInhabitantsYear = string.Empty;
    string Edu_ESJSNewInhabitants = string.Empty;
    string Edu_ESJSNewInhabitantsRateYear = string.Empty;
    string Edu_ESToJSNewInhabitantsRate = string.Empty;
    string Edu_ESJSTeachersYear = string.Empty;
    string Edu_ESJSTeachers = string.Empty;
    string Edu_ESJSTeachersOfStudentRateYear = string.Empty;
    string Edu_ESJSTeachersOfStudentRate = string.Empty;
    string Edu_BudgetYear = string.Empty;
    string Edu_Budget = string.Empty;
    string Edu_BudgetUpRateYearDesc = string.Empty;
    string Edu_BudgetUpRate = string.Empty;
    string Edu_ESToHSAvgBudgetYear = string.Empty;
    string Edu_ESToHSAvgBudget = string.Empty;
    string Edu_ESJSPCNumYear = string.Empty;
    string Edu_ESJSPCNum = string.Empty;
    string Edu_ESJSAvgPCNumYear = string.Empty;
    string Edu_ESJSAvgPCNum = string.Empty;
    string Edu_CreateDate = string.Empty;
    string Edu_CreateID = string.Empty;
    string Edu_CreateName = string.Empty;
    string Edu_Status = string.Empty;
    string Edu_Version = string.Empty;



    #endregion
    #region 公用
    public string _Edu_ID
    {
        set { Edu_ID = value; }
    }
    public string _Edu_CityNo
    {
        set { Edu_CityNo = value; }
    }
    public string _Edu_CityName
    {
        set { Edu_CityName = value; }
    }
    public string _Edu_15upJSDownRateYear
    {
        set { Edu_15upJSDownRateYear = value; }
    }
    public string _Edu_15upJSDownRate
    {
        set { Edu_15upJSDownRate = value; }
    }
    public string _Edu_15upHSRateYear
    {
        set { Edu_15upHSRateYear = value; }
    }
    public string _Edu_15upHSRate
    {
        set { Edu_15upHSRate = value; }
    }
    public string _Edu_15upUSUpRateYear
    {
        set { Edu_15upUSUpRateYear = value; }
    }
    public string _Edu_15upUSUpRate
    {
        set { Edu_15upUSUpRate = value; }
    }
    public string _Edu_ESStudentDropOutRateYear
    {
        set { Edu_ESStudentDropOutRateYear = value; }
    }
    public string _Edu_ESStudentDropOutRate
    {
        set { Edu_ESStudentDropOutRate = value; }
    }
    public string _Edu_JSStudentDropOutRateYear
    {
        set { Edu_JSStudentDropOutRateYear = value; }
    }
    public string _Edu_JSStudentDropOutRate
    {
        set { Edu_JSStudentDropOutRate = value; }
    }
    public string _Edu_ESStudentsYear
    {
        set { Edu_ESStudentsYear = value; }
    }
    public string _Edu_ESStudents
    {
        set { Edu_ESStudents = value; }
    }
    public string _Edu_JSStudentsYear
    {
        set { Edu_JSStudentsYear = value; }
    }
    public string _Edu_JSStudents
    {
        set { Edu_JSStudents = value; }
    }
    public string _Edu_HSStudentsYear
    {
        set { Edu_HSStudentsYear = value; }
    }
    public string _Edu_HSStudents
    {
        set { Edu_HSStudents = value; }
    }
    public string _Edu_ESToHSIndigenousYear
    {
        set { Edu_ESToHSIndigenousYear = value; }
    }
    public string _Edu_ESToHSIdigenous
    {
        set { Edu_ESToHSIdigenous = value; }
    }
    public string _Edu_ESToHSIndigenousRateYear
    {
        set { Edu_ESToHSIndigenousRateYear = value; }
    }
    public string _Edu_ESToHSIndigenousRate
    {
        set { Edu_ESToHSIndigenousRate = value; }
    }
    public string _Edu_ESJSNewInhabitantsYear
    {
        set { Edu_ESJSNewInhabitantsYear = value; }
    }
    public string _Edu_ESJSNewInhabitants
    {
        set { Edu_ESJSNewInhabitants = value; }
    }
    public string _Edu_ESJSNewInhabitantsRateYear
    {
        set { Edu_ESJSNewInhabitantsRateYear = value; }
    }
    public string _Edu_ESToJSNewInhabitantsRate
    {
        set { Edu_ESToJSNewInhabitantsRate = value; }
    }
    public string _Edu_ESJSTeachersYear
    {
        set { Edu_ESJSTeachersYear = value; }
    }
    public string _Edu_ESJSTeachers
    {
        set { Edu_ESJSTeachers = value; }
    }
    public string _Edu_ESJSTeachersOfStudentRateYear
    {
        set { Edu_ESJSTeachersOfStudentRateYear = value; }
    }
    public string _Edu_ESJSTeachersOfStudentRate
    {
        set { Edu_ESJSTeachersOfStudentRate = value; }
    }
    public string _Edu_BudgetYear
    {
        set { Edu_BudgetYear = value; }
    }
    public string _Edu_Budget
    {
        set { Edu_Budget = value; }
    }
    public string _Edu_BudgetUpRateYearDesc
    {
        set { Edu_BudgetUpRateYearDesc = value; }
    }
    public string _Edu_BudgetUpRate
    {
        set { Edu_BudgetUpRate = value; }
    }
    public string _PEdu_ESToHSAvgBudgetYear
    {
        set { Edu_ESToHSAvgBudgetYear = value; }
    }
    public string _Edu_ESToHSAvgBudget
    {
        set { Edu_ESToHSAvgBudget = value; }
    }
    public string _Edu_ESJSPCNumYear
    {
        set { Edu_ESJSPCNumYear = value; }
    }
    public string _Edu_ESJSPCNum
    {
        set { Edu_ESJSPCNum = value; }
    }
    public string _Edu_ESJSAvgPCNumYear
    {
        set { Edu_ESJSAvgPCNumYear = value; }
    }
    public string _Edu_ESJSAvgPCNum
    {
        set { Edu_ESJSAvgPCNum = value; }
    }
    public string _Edu_CreateDate
    {
        set { Edu_CreateDate = value; }
    }
    public string _Edu_CreateID
    {
        set { Edu_CreateID = value; }
    }
    public string _Edu_CreateName
    {
        set { Edu_CreateName = value; }
    }
    public string _Edu_Status
    {
        set { Edu_Status = value; }
    }
    public string _Edu_Version
    {
        set { Edu_Version = value; }
    }
    #endregion


    //取得當前最大版次
    public int getMaxVersin()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
            SELECT MAX(Edu_Version) as strMax from Education where Edu_Status='A'
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