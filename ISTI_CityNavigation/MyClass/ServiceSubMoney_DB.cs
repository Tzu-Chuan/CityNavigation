using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

public class ServiceSubMoney_DB
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string S_ID = string.Empty;
    string S_Type = string.Empty;
    string S_PlanCount = string.Empty;
    string S_Subsidy = string.Empty;
    string S_TotalMoney = string.Empty;
    string S_SubsidyRatio = string.Empty;
    string S_TotalMoneyRatio = string.Empty;
    string S_CreateId = string.Empty;
    string S_CreateName = string.Empty;
    int S_Version;
    string S_Status = string.Empty;

    DateTime S_CreateDate;
    #endregion
    #region 公用
    public string _S_ID
    {
        set { S_ID = value; }
    }
    public string _S_Type
    {
        set { S_Type = value; }
    }
    public string _S_PlanCount
    {
        set { S_PlanCount = value; }
    }
    public string _S_Subsidy
    {
        set { S_Subsidy = value; }
    }
    public string _S_TotalMoney
    {
        set { S_TotalMoney = value; }
    }
    public string _S_SubsidyRatio
    {
        set { S_SubsidyRatio = value; }
    }
    public string _S_TotalMoneyRatio
    {
        set { S_TotalMoneyRatio = value; }
    }
    public string _S_CreateId
    {
        set { S_CreateId = value; }
    }
    public string _S_CreateName
    {
        set { S_CreateName = value; }
    }
    public int _S_Version
    {
        set { S_Version = value; }
    }
    public string _S_Status
    {
        set { S_Status = value; }
    }
    public DateTime _S_CreateDate
    {
        set { S_CreateDate = value; }
    }
    #endregion


    public int getMaxVersion()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"SELECT isnull(MAX(S_Version),0) as strMax from ServiceSubMoney where S_Status='A'  ");

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable dt = new DataTable();
        oda.Fill(dt);

        return Int32.Parse(dt.Rows[0]["strMax"].ToString().Trim());
    }

    public void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(@"update ServiceSubMoney set S_Status='D' where S_Status='A' ");
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
            sqlBC.DestinationTableName = "ServiceSubMoney";

            /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
            sqlBC.ColumnMappings.Add("S_ID", "S_ID");
            sqlBC.ColumnMappings.Add("S_Type", "S_Type");
            sqlBC.ColumnMappings.Add("S_PlanCount", "S_PlanCount");
            sqlBC.ColumnMappings.Add("S_Subsidy", "S_Subsidy");
            sqlBC.ColumnMappings.Add("S_TotalMoney", "S_TotalMoney");
            sqlBC.ColumnMappings.Add("S_SubsidyRatio", "S_SubsidyRatio");
            sqlBC.ColumnMappings.Add("S_TotalMoneyRatio", "S_TotalMoneyRatio");
            sqlBC.ColumnMappings.Add("S_CreateId", "S_CreateId");
            sqlBC.ColumnMappings.Add("S_CreateName", "S_CreateName");
            sqlBC.ColumnMappings.Add("S_Version", "S_Version");
            sqlBC.ColumnMappings.Add("S_Status", "S_Status");

            /// 開始寫入資料
            sqlBC.WriteToServer(srcData);
        }
    }
}