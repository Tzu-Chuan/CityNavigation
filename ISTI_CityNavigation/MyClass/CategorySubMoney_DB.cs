using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

public class CategorySubMoney_DB
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string C_ID = string.Empty;
    string C_Type = string.Empty;
    string C_PlanCount = string.Empty;
    string C_Subsidy = string.Empty;
    string C_TotalMoney = string.Empty;
    string C_SubsidyRatio = string.Empty;
    string C_TotalMoneyRatio = string.Empty;
    string C_CreateId = string.Empty;
    string C_CreateName = string.Empty;
    int C_Version;
    string C_Status = string.Empty;

    DateTime C_CreateDate;
    #endregion
    #region 公用
    public string _C_ID
    {
        set { C_ID = value; }
    }
    public string _C_Type
    {
        set { C_Type = value; }
    }
    public string _C_PlanCount
    {
        set { C_PlanCount = value; }
    }
    public string _C_Subsidy
    {
        set { C_Subsidy = value; }
    }
    public string _C_TotalMoney
    {
        set { C_TotalMoney = value; }
    }
    public string _C_SubsidyRatio
    {
        set { C_SubsidyRatio = value; }
    }
    public string _C_TotalMoneyRatio
    {
        set { C_TotalMoneyRatio = value; }
    }
    public string _C_CreateId
    {
        set { C_CreateId = value; }
    }
    public string _C_CreateName
    {
        set { C_CreateName = value; }
    }
    public int _C_Version
    {
        set { C_Version = value; }
    }
    public string _C_Status
    {
        set { C_Status = value; }
    }
    public DateTime _C_CreateDate
    {
        set { C_CreateDate = value; }
    }
    #endregion


    public int getMaxVersion()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"SELECT isnull(MAX(C_Version),0) as strMax from CategorySubMoney where C_Status='A'  ");

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
        sb.Append(@"update CategorySubMoney set C_Status='D' where C_Status='A' ");
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
            sqlBC.DestinationTableName = "CategorySubMoney";

            /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
            sqlBC.ColumnMappings.Add("C_ID", "C_ID");
            sqlBC.ColumnMappings.Add("C_Type", "C_Type");
            sqlBC.ColumnMappings.Add("C_PlanCount", "C_PlanCount");
            sqlBC.ColumnMappings.Add("C_Subsidy", "C_Subsidy");
            sqlBC.ColumnMappings.Add("C_TotalMoney", "C_TotalMoney");
            sqlBC.ColumnMappings.Add("C_SubsidyRatio", "C_SubsidyRatio");
            sqlBC.ColumnMappings.Add("C_TotalMoneyRatio", "C_TotalMoneyRatio");
            sqlBC.ColumnMappings.Add("C_CreateId", "C_CreateId");
            sqlBC.ColumnMappings.Add("C_CreateName", "C_CreateName");
            sqlBC.ColumnMappings.Add("C_Version", "C_Version");
            sqlBC.ColumnMappings.Add("C_Status", "C_Status");

            /// 開始寫入資料
            sqlBC.WriteToServer(srcData);
        }
    }
}