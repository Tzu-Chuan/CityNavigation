using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

public class CitySubMoney_DB
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string C_ID = string.Empty;
    string C_City = string.Empty;
    string C_PlanCount_NotAll = string.Empty;
    string C_SubMoney_NotAll = string.Empty;
    string C_PlanMoney_NotAll = string.Empty;
    string C_AssignSubMoney = string.Empty;
    string C_AssignTotalMoney = string.Empty;
    string C_CitySubMoneyRatio_NotAll = string.Empty;
    string C_CityTotalMoneyRatio_NotAll = string.Empty;
    string C_PlanCount = string.Empty;
    string C_SubMoney = string.Empty;
    string C_PlanMoney = string.Empty;
    string C_CitySubMoneyRatio = string.Empty;
    string C_CityTotalMoneyRatio = string.Empty;
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
    public string _C_City
    {
        set { C_City = value; }
    }
    public string _C_PlanCount_NotAll
    {
        set { C_PlanCount_NotAll = value; }
    }
    public string _C_SubMoney_NotAll
    {
        set { C_SubMoney_NotAll = value; }
    }
    public string _C_PlanMoney_NotAll
    {
        set { C_PlanMoney_NotAll = value; }
    }
    public string _C_AssignSubMoney
    {
        set { C_AssignSubMoney = value; }
    }
    public string _C_AssignTotalMoney
    {
        set { C_AssignTotalMoney = value; }
    }
    public string _C_CitySubMoneyRatio_NotAll
    {
        set { C_CitySubMoneyRatio_NotAll = value; }
    }
    public string _C_CityTotalMoneyRatio_NotAll
    {
        set { C_CityTotalMoneyRatio_NotAll = value; }
    }
    public string _C_PlanCount
    {
        set { C_PlanCount = value; }
    }
    public string _C_SubMoney
    {
        set { C_SubMoney = value; }
    }
    public string _C_PlanMoney
    {
        set { C_PlanMoney = value; }
    }
    public string _C_CitySubMoneyRatio
    {
        set { C_CitySubMoneyRatio = value; }
    }
    public string _C_CityTotalMoneyRatio
    {
        set { C_CityTotalMoneyRatio = value; }
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


    public DataSet getList(string pStart, string pEnd, string sortStr)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
select Member.*,Comp.C_Item_cn as Competence
into #tmpAll from Member 
left join CodeTable as Comp on Comp.C_Group='03' and Comp.C_Item=M_Competence
where M_Status='A' ");

        if (KeyWord != "")
        {
            sb.Append(@"and ((upper(M_Name) LIKE '%' + upper(@KeyWord) + '%') ");
        }

        sb.Append(@"
--總筆數
select count(*) as total from #tmpAll
--分頁資料
select * from (
select ROW_NUMBER() over (order by " + sortStr + @") itemNo,#tmpAll.*
from #tmpAll
)#tmp where itemNo between @pStart and @pEnd

drop table #tmpAll  ");

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataSet ds = new DataSet();

        oCmd.Parameters.AddWithValue("@KeyWord", KeyWord);
        oCmd.Parameters.AddWithValue("@pStart", pStart);
        oCmd.Parameters.AddWithValue("@pEnd", pEnd);
        oda.Fill(ds);
        return ds;
    }

    public int getMaxVersion()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"SELECT isnull(MAX(C_Version),0) as strMax from CitySubMoney where C_Status='A'  ");

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
        sb.Append(@"update CitySubMoney set C_Status='D' where C_Status='A' ");
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
            sqlBC.DestinationTableName = "CitySubMoney";

            /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
            sqlBC.ColumnMappings.Add("C_City", "C_City");
            sqlBC.ColumnMappings.Add("C_PlanCount_NotAll", "C_PlanCount_NotAll");
            sqlBC.ColumnMappings.Add("C_SubMoney_NotAll", "C_SubMoney_NotAll");
            sqlBC.ColumnMappings.Add("C_PlanMoney_NotAll", "C_PlanMoney_NotAll");
            sqlBC.ColumnMappings.Add("C_AssignSubMoney", "C_AssignSubMoney");
            sqlBC.ColumnMappings.Add("C_AssignTotalMoney", "C_AssignTotalMoney");
            sqlBC.ColumnMappings.Add("C_CitySubMoneyRatio_NotAll", "C_CitySubMoneyRatio_NotAll");
            sqlBC.ColumnMappings.Add("C_CityTotalMoneyRatio_NotAll", "C_CityTotalMoneyRatio_NotAll");
            sqlBC.ColumnMappings.Add("C_PlanCount", "C_PlanCount");
            sqlBC.ColumnMappings.Add("C_SubMoney", "C_SubMoney");
            sqlBC.ColumnMappings.Add("C_PlanMoney", "C_PlanMoney");
            sqlBC.ColumnMappings.Add("C_CitySubMoneyRatio", "C_CitySubMoneyRatio");
            sqlBC.ColumnMappings.Add("C_CityTotalMoneyRatio", "C_CityTotalMoneyRatio");
            sqlBC.ColumnMappings.Add("C_CreateId", "C_CreateId");
            sqlBC.ColumnMappings.Add("C_CreateName", "C_CreateName");
            sqlBC.ColumnMappings.Add("C_Version", "C_Version");
            sqlBC.ColumnMappings.Add("C_Status", "C_Status");

            /// 開始寫入資料
            sqlBC.WriteToServer(srcData);
        }
    }
}