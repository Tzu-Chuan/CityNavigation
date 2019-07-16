using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

public class ImportData_Log
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string IDL_ID = string.Empty;
    string IDL_Type = string.Empty;
    string IDL_IP = string.Empty;
    string IDL_Description = string.Empty;
    string IDL_ModId = string.Empty;
    string IDL_ModName = string.Empty;
    DateTime IDL_ModDate;
    #endregion
    #region 公用
    public string _IDL_ID { set { IDL_ID = value; } }
    public string _IDL_Type { set { IDL_Type = value; } }
    public string _IDL_IP { set { IDL_IP = value; } }
    public string _IDL_Description { set { IDL_Description = value; } }
    public string _IDL_ModId { set { IDL_ModId = value; } }
    public string _IDL_ModName { set { IDL_ModName = value; } }
    public DateTime _IDL_ModDate { set { IDL_ModDate = value; } }
    #endregion

    public DataSet getList(string pStart, string pEnd, string sortStr)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
select * into #tmpAll from ImportData_Log where 1=1");

        //if (KeyWord != "")
        //    sb.Append(@"and ((upper(M_Name) LIKE '%' + upper(@KeyWord) + '%') or (upper(M_Email) LIKE '%' + upper(@KeyWord) + '%')) ");

        if (IDL_Type != "")
            sb.Append(@"and IDL_Type=@IDL_Type ");

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

        oCmd.Parameters.AddWithValue("@IDL_Type", IDL_Type);
        oCmd.Parameters.AddWithValue("@pStart", pStart);
        oCmd.Parameters.AddWithValue("@pEnd", pEnd);
        oda.Fill(ds);
        return ds;
    }

    public void addLog()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        oCmd.CommandText = @"insert into ImportData_Log (
IDL_Type,
IDL_IP,
IDL_Description,
IDL_ModId,
IDL_ModName
) values (
@IDL_Type,
@IDL_IP,
@IDL_Description,
@IDL_ModId,
@IDL_ModName
) ";

        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        oCmd.Parameters.AddWithValue("@IDL_Type", IDL_Type);
        oCmd.Parameters.AddWithValue("@IDL_IP", IDL_IP);
        oCmd.Parameters.AddWithValue("@IDL_Description", IDL_Description);
        oCmd.Parameters.AddWithValue("@IDL_ModId", IDL_ModId);
        oCmd.Parameters.AddWithValue("@IDL_ModName", IDL_ModName);

        oCmd.Connection.Open();
        oCmd.ExecuteNonQuery();
        oCmd.Connection.Close();
    }
}