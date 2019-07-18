using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;


public class CityPlanTable_DB
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string CP_ID = string.Empty;
    string CP_City = string.Empty;
    string CP_CityCode = string.Empty;
    string CP_PlanSchedule = string.Empty;
    string CP_No = string.Empty;
    string CP_PlanType = string.Empty;
    string CP_PlanTypeDetail = string.Empty;
    string CP_CaseNo = string.Empty;
    string CP_HostCompany = string.Empty;
    string CP_JointCompany = string.Empty;
    string CP_PlanName = string.Empty;
    string CP_ServiceArea = string.Empty;
    string CP_ServiceType = string.Empty;
    string CP_CityArea = string.Empty;
    string CP_CityAreaDetail = string.Empty;
    string CP_PlanTotalMoney = string.Empty;
    string CP_PlanSubMoney = string.Empty;
    string CP_CityTotalMoney = string.Empty;
    string CP_CitySubMoney = string.Empty;
    DateTime CP_CreateDate;
    string CP_CreateId = string.Empty;
    string CP_CreateName = string.Empty;
    int CP_Version;
    string CP_Status = string.Empty;
    #endregion
    #region 公用
    public string _CP_ID { set { CP_ID = value; } }
    public string _CP_City { set { CP_City = value; } }
    public string _CP_CityCode { set { CP_CityCode = value; } }
    public string _CP_PlanSchedule { set { CP_PlanSchedule = value; } }
    public string _CP_No { set { CP_No = value; } }
    public string _CP_PlanType { set { CP_PlanType = value; } }
    public string _CP_PlanTypeDetail { set { CP_PlanTypeDetail = value; } }
    public string _CP_CaseNo { set { CP_CaseNo = value; } }
    public string _CP_HostCompany { set { CP_HostCompany = value; } }
    public string _CP_JointCompany { set { CP_JointCompany = value; } }
    public string _CP_PlanName { set { CP_PlanName = value; } }
    public string _CP_ServiceArea { set { CP_ServiceArea = value; } }
    public string _CP_ServiceType { set { CP_ServiceType = value; } }
    public string _CP_CityArea { set { CP_CityArea = value; } }
    public string _CP_CityAreaDetail { set { CP_CityAreaDetail = value; } }
    public string _CP_PlanTotalMoney { set { CP_PlanTotalMoney = value; } }
    public string _CP_PlanSubMoney { set { CP_PlanSubMoney = value; } }
    public string _CP_CityTotalMoney { set { CP_CityTotalMoney = value; } }
    public string _CP_CitySubMoney { set { CP_CitySubMoney = value; } }
    public DateTime _CP_CreateDate { set { CP_CreateDate = value; } }
    public string _CP_CreateId { set { CP_CreateId = value; } }

    public string _CP_CreateName { set { CP_CreateName = value; } }
    public int _CP_Version { set { CP_Version = value; } }
    public string _CP_Status { set { CP_Status = value; } }
    #endregion


    public DataTable GetServiceTypeCount(string City)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"Select CP_ServiceType,COUNT(CP_ServiceType) as TypeCount from CityPlanTable where CP_Status='A' ");

        if (City != "")
            sb.Append(@"and CP_CityCode=@City ");

        sb.Append(@"group by CP_ServiceType ");

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable ds = new DataTable();

        oCmd.Parameters.AddWithValue("@City", City);

        oda.Fill(ds);
        return ds;
    }

    public int getMaxVersion(string city)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"SELECT isnull(MAX(CP_Version),0) as strMax from CityPlanTable where CP_Status='A' and CP_CityCode=@city  ");

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();

        oCmd.Parameters.AddWithValue("@city", city);
        oda.Fill(dt);


        return Int32.Parse(dt.Rows[0]["strMax"].ToString().Trim());
    }

    public void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(@"update CityPlanTable set CP_Status='D' where CP_Status='A' ");
        SqlCommand oCmd = oConn.CreateCommand();
        oCmd.CommandText = sb.ToString();

        //oCmd.Parameters.AddWithValue("@chkYear", chkYear);

        oCmd.Transaction = oTran;
        oCmd.ExecuteNonQuery();
    }

    public void DoBulkCopy(DataTable srcData, SqlTransaction oTran)
    {
        SqlBulkCopyOptions setting = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.TableLock;
        using (SqlBulkCopy sqlBC = new SqlBulkCopy(oTran.Connection, setting, oTran))
        {
            sqlBC.BulkCopyTimeout = 600; ///設定逾時的秒數
            //sqlBC.BatchSize = 1000; ///設定一個批次量寫入多少筆資料, 設定值太小會影響效能 
            ////設定 NotifyAfter 屬性，以便在每複製 10000 個資料列至資料表後，呼叫事件處理常式。
            //sqlBC.NotifyAfter = 10000;
            ///設定要寫入的資料庫
            sqlBC.DestinationTableName = "CityPlanTable";

            /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
            sqlBC.ColumnMappings.Add("CP_City", "CP_City");
            sqlBC.ColumnMappings.Add("CP_CityCode", "CP_CityCode");
            sqlBC.ColumnMappings.Add("CP_PlanSchedule", "CP_PlanSchedule");
            sqlBC.ColumnMappings.Add("CP_No", "CP_No");
            sqlBC.ColumnMappings.Add("CP_PlanType", "CP_PlanType");
            sqlBC.ColumnMappings.Add("CP_PlanTypeDetail", "CP_PlanTypeDetail");
            sqlBC.ColumnMappings.Add("CP_CaseNo", "CP_CaseNo");
            sqlBC.ColumnMappings.Add("CP_HostCompany", "CP_HostCompany");
            sqlBC.ColumnMappings.Add("CP_JointCompany", "CP_JointCompany");
            sqlBC.ColumnMappings.Add("CP_PlanName", "CP_PlanName");
            sqlBC.ColumnMappings.Add("CP_ServiceArea", "CP_ServiceArea");
            sqlBC.ColumnMappings.Add("CP_ServiceType", "CP_ServiceType");
            sqlBC.ColumnMappings.Add("CP_AllArea", "CP_AllArea");
            sqlBC.ColumnMappings.Add("CP_CityArea", "CP_CityArea");
            sqlBC.ColumnMappings.Add("CP_CityAreaDetail", "CP_CityAreaDetail");
            sqlBC.ColumnMappings.Add("CP_PlanTotalMoney", "CP_PlanTotalMoney");
            sqlBC.ColumnMappings.Add("CP_PlanSubMoney", "CP_PlanSubMoney");
            sqlBC.ColumnMappings.Add("CP_CityTotalMoney", "CP_CityTotalMoney");
            sqlBC.ColumnMappings.Add("CP_CitySubMoney", "CP_CitySubMoney");
            sqlBC.ColumnMappings.Add("CP_CreateId", "CP_CreateId");
            sqlBC.ColumnMappings.Add("CP_CreateName", "CP_CreateName");
            sqlBC.ColumnMappings.Add("CP_Version", "CP_Version");
            sqlBC.ColumnMappings.Add("CP_Status", "CP_Status");

            /// 開始寫入資料
            sqlBC.WriteToServer(srcData);
        }
    }
}
