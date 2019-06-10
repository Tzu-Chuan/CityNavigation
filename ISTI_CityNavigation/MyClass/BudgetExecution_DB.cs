using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

public class BudgetExecution_DB
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string B_ID = string.Empty;
    string B_Commission = string.Empty;
    string B_Subsidy = string.Empty;
    string B_Sub01 = string.Empty;
    string B_Sub02 = string.Empty;
    string B_Sub03 = string.Empty;
    string B_RemainBudget = string.Empty;
    string B_Rate = string.Empty;
    string B_CreateId = string.Empty;
    string B_CreateName = string.Empty;
    int B_Version;
    string B_Status = string.Empty;

    DateTime B_CreateDate;
    #endregion
    #region 公用
    public string _B_ID
    {
        set { B_ID = value; }
    }
    public string _B_Commission
    {
        set { B_Commission = value; }
    }
    public string _B_Sub01
    {
        set { B_Sub01 = value; }
    }
    public string _B_Sub02
    {
        set { B_Sub02 = value; }
    }
    public string _B_Sub03
    {
        set { B_Sub03 = value; }
    }
    public string _B_RemainBudget
    {
        set { B_RemainBudget = value; }
    }
    public string _B_Rate
    {
        set { B_Rate = value; }
    }
    public string _B_CreateId
    {
        set { B_CreateId = value; }
    }
    public string _B_CreateName
    {
        set { B_CreateName = value; }
    }
    public int _B_Version
    {
        set { B_Version = value; }
    }
    public string _B_Status
    {
        set { B_Status = value; }
    }
    public DateTime _B_CreateDate
    {
        set { B_CreateDate = value; }
    }
    #endregion


    public int getMaxVersion()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"SELECT isnull(MAX(B_Version),0) as strMax from BudgetExecution where B_Status='A'  ");

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
        sb.Append(@"update BudgetExecution set B_Status='D' where B_Status='A' ");
        SqlCommand oCmd = oConn.CreateCommand();
        oCmd.CommandText = sb.ToString();

        //oCmd.Parameters.AddWithValue("", KeyWord);

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
            sqlBC.DestinationTableName = "BudgetExecution";

            /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
            sqlBC.ColumnMappings.Add("B_Commission", "B_Commission");
            sqlBC.ColumnMappings.Add("B_Subsidy", "B_Subsidy");
            sqlBC.ColumnMappings.Add("B_Sub01", "B_Sub01");
            sqlBC.ColumnMappings.Add("B_Sub02", "B_Sub02");
            sqlBC.ColumnMappings.Add("B_Sub03", "B_Sub03");
            sqlBC.ColumnMappings.Add("B_RemainBudget", "B_RemainBudget");
            sqlBC.ColumnMappings.Add("B_Rate", "B_Rate");
            sqlBC.ColumnMappings.Add("B_CreateId", "B_CreateId");
            sqlBC.ColumnMappings.Add("B_CreateName", "B_CreateName");
            sqlBC.ColumnMappings.Add("B_Version", "B_Version");
            sqlBC.ColumnMappings.Add("B_Status", "B_Status");

            /// 開始寫入資料
            sqlBC.WriteToServer(srcData);
        }
    }
}