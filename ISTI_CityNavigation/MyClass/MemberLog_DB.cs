using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

public class MemberLog_DB
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string ML_ID = string.Empty;
    string ML_IP = string.Empty;
    string ML_ChangeGuid = string.Empty;
    string ML_Description = string.Empty;
    string ML_ModId = string.Empty;
    string ML_ModName = string.Empty;
    DateTime ML_ModDate;
    #endregion
    #region 公用
    public string _ML_ID { set { ML_ID = value; } }
    public string _ML_IP { set { ML_IP = value; } }
    public string _ML_ChangeGuid { set { ML_ChangeGuid = value; } }
    public string _ML_Description { set { ML_Description = value; } }
    public string _ML_ModId { set { ML_ModId = value; } }
    public string _ML_ModName { set { ML_ModName = value; } }
    public DateTime _ML_ModDate { set { ML_ModDate = value; } }
    #endregion

    public DataSet getList(string pStart, string pEnd, string sortStr)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
select * into #tmpAll from Member_Log ");

        //if (KeyWord != "")
        //    sb.Append(@"and ((upper(M_Name) LIKE '%' + upper(@KeyWord) + '%') or (upper(M_Email) LIKE '%' + upper(@KeyWord) + '%')) ");

        //if (strComp != "")
        //    sb.Append(@"and M_Competence=@strComp ");

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
        
        //oCmd.Parameters.AddWithValue("@KeyWord", KeyWord);
        oCmd.Parameters.AddWithValue("@pStart", pStart);
        oCmd.Parameters.AddWithValue("@pEnd", pEnd);
        oda.Fill(ds);
        return ds;
    }

    public void addLog()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        oCmd.CommandText = @"insert into Member_Log (
ML_IP,
ML_ChangeGuid,
ML_Description,
ML_ModId,
ML_ModName
) values (
@ML_IP,
@ML_ChangeGuid,
@ML_Description,
@ML_ModId,
@ML_ModName
) ";

        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        oCmd.Parameters.AddWithValue("@ML_IP", ML_IP);
        oCmd.Parameters.AddWithValue("@ML_ChangeGuid", ML_ChangeGuid);
        oCmd.Parameters.AddWithValue("@ML_Description", ML_Description);
        oCmd.Parameters.AddWithValue("@ML_ModId", ML_ModId);
        oCmd.Parameters.AddWithValue("@ML_ModName", ML_ModName);

        oCmd.Connection.Open();
        oCmd.ExecuteNonQuery();
        oCmd.Connection.Close();
    }
}