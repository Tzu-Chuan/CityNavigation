using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;

/// <summary>
/// Member_DB 的摘要描述
/// </summary>
public class Member_DB
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string M_ID = string.Empty;
    string M_Guid = string.Empty;
    string M_Account = string.Empty;
    string M_Pwd = string.Empty;
    string M_Name = string.Empty;
    string M_JobTitle = string.Empty;
    string M_Tel = string.Empty;
    string M_Ext = string.Empty;
    string M_Fax = string.Empty;
    string M_Phone = string.Empty;
    string M_Email = string.Empty;
    string M_Addr = string.Empty;
    string M_Competence = string.Empty;
    string M_CreateId = string.Empty;
    string M_CreateName = string.Empty;
    string M_ModId = string.Empty;
    string M_ModName = string.Empty;
    string M_Status = string.Empty;

    DateTime M_CreateDate;
    DateTime M_ModDate;
    #endregion
    #region 公用
    public string _M_ID
    {
        set { M_ID = value; }
    }
    public string _M_Guid
    {
        set { M_Guid = value; }
    }
    public string _M_Account
    {
        set { M_Account = value; }
    }
    public string _M_Pwd
    {
        set { M_Pwd = value; }
    }
    public string _M_Name
    {
        set { M_Name = value; }
    }
    public string _M_JobTitle
    {
        set { M_JobTitle = value; }
    }
    public string _M_Tel
    {
        set { M_Tel = value; }
    }
    public string _M_Ext
    {
        set { M_Ext = value; }
    }
    public string _M_Fax
    {
        set { M_Fax = value; }
    }
    public string _M_Phone
    {
        set { M_Phone = value; }
    }
    public string _M_Email
    {
        set { M_Email = value; }
    }
    public string _M_Addr
    {
        set { M_Addr = value; }
    }
    public string _M_Competence
    {
        set { M_Competence = value; }
    }
    public string _M_CreateId
    {
        set { M_CreateId = value; }
    }
    public string _M_CreateName
    {
        set { M_CreateName = value; }
    }
    public string _M_ModId
    {
        set { M_ModId = value; }
    }
    public string _M_ModName
    {
        set { M_ModName = value; }
    }
    public string _M_Status
    {
        set { M_Status = value; }
    }
    public DateTime _M_CreateDate
    {
        set { M_CreateDate = value; }
    }
    public DateTime _M_ModDate
    {
        set { M_ModDate = value; }
    }
    #endregion

    public DataSet getMemberList(string pStart, string pEnd, string sortStr,string strComp)
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
            sb.Append(@"and ((upper(M_Name) LIKE '%' + upper(@KeyWord) + '%') or (upper(M_Email) LIKE '%' + upper(@KeyWord) + '%')) ");

        if (strComp != "")
            sb.Append(@"and M_Competence=@strComp ");

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

        oCmd.Parameters.AddWithValue("@strComp", strComp);
        oCmd.Parameters.AddWithValue("@KeyWord", KeyWord);
        oCmd.Parameters.AddWithValue("@pStart", pStart);
        oCmd.Parameters.AddWithValue("@pEnd", pEnd);
        oda.Fill(ds);
        return ds;
    }

    public void addMember()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        oCmd.CommandText = @"insert into Member (
M_Guid,
M_Account,
M_Pwd,
M_Name,
M_Email,
M_Competence,
M_Status,
M_CreateId,
M_CreateName,
M_ModDate,
M_ModId,
M_ModName
) values (
@M_Guid,
@M_Account,
@M_Pwd,
@M_Name,
@M_Email,
@M_Competence,
@M_Status,
@M_CreateId,
@M_CreateName,
@M_ModDate,
@M_ModId,
@M_ModName
) ";
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        oCmd.Parameters.AddWithValue("@M_Guid", M_Guid);
        oCmd.Parameters.AddWithValue("@M_Account", M_Account);
        oCmd.Parameters.AddWithValue("@M_Pwd", M_Pwd);
        oCmd.Parameters.AddWithValue("@M_Name", M_Name);
        oCmd.Parameters.AddWithValue("@M_Email", M_Email);
        oCmd.Parameters.AddWithValue("@M_Competence", M_Competence);
        oCmd.Parameters.AddWithValue("@M_CreateId", M_CreateId);
        oCmd.Parameters.AddWithValue("@M_CreateName", M_CreateName);
        oCmd.Parameters.AddWithValue("@M_ModDate", DateTime.Now);
        oCmd.Parameters.AddWithValue("@M_ModId", M_ModId);
        oCmd.Parameters.AddWithValue("@M_ModName", M_ModName);
        oCmd.Parameters.AddWithValue("@M_Status", "A");

        oCmd.Connection.Open();
        oCmd.ExecuteNonQuery();
        oCmd.Connection.Close();
    }

    public void modMember()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        oCmd.CommandText = @"update Member set
M_Account=@M_Account,
M_Pwd=@M_Pwd,
M_Name=@M_Name,
M_Email=@M_Email,
M_Competence=@M_Competence,
M_ModDate=@M_ModDate,
M_ModId=@M_ModId,
M_ModName=@M_ModName
where M_ID=@M_ID
";
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        oCmd.Parameters.AddWithValue("@M_ID", M_ID);
        oCmd.Parameters.AddWithValue("@M_Account", M_Account);
        oCmd.Parameters.AddWithValue("@M_Pwd", M_Pwd);
        oCmd.Parameters.AddWithValue("@M_Name", M_Name);
        oCmd.Parameters.AddWithValue("@M_Email", M_Email);
        oCmd.Parameters.AddWithValue("@M_Competence", M_Competence);
        oCmd.Parameters.AddWithValue("@M_ModDate", DateTime.Now);
        oCmd.Parameters.AddWithValue("@M_ModId", M_ModId);
        oCmd.Parameters.AddWithValue("@M_ModName", M_ModName);

        oCmd.Connection.Open();
        oCmd.ExecuteNonQuery();
        oCmd.Connection.Close();
    }

    public void DeleteMember()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        oCmd.CommandText = @"update Member set
M_Status=@M_Status,
M_ModDate=@M_ModDate,
M_ModId=@M_ModId,
M_ModName=@M_ModName
where M_ID=@M_ID
";
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        oCmd.Parameters.AddWithValue("@M_ID", M_ID);
        oCmd.Parameters.AddWithValue("@M_Status", "D");
        oCmd.Parameters.AddWithValue("@M_ModDate", DateTime.Now);
        oCmd.Parameters.AddWithValue("@M_ModId", M_ModId);
        oCmd.Parameters.AddWithValue("@M_ModName", M_ModName);

        oCmd.Connection.Open();
        oCmd.ExecuteNonQuery();
        oCmd.Connection.Close();
    }

    public DataTable getMemberById()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select Member.*,Comp.C_Item_cn as Competence from Member 
left join CodeTable as Comp on Comp.C_Group='03' and Comp.C_Item=M_Competence
where M_ID=@M_ID ");
        
        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable ds = new DataTable();
        oCmd.Parameters.AddWithValue("@M_ID", M_ID);
        oda.Fill(ds);
        return ds;
    }

    /// <summary>
    /// 檢查帳號是否存在
    /// </summary>
    public int CheckAccount()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select count(*) as num from Member where M_Status='A' and M_Account=@M_Account ");

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable ds = new DataTable();
        oCmd.Parameters.AddWithValue("@M_Account", M_Account);
        oda.Fill(ds);

        return Int32.Parse(ds.Rows[0]["num"].ToString());
    }


    /// <summary>
    /// 檢查E-mail是否存在
    /// </summary>
    public int CheckEmail()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select count(*) as num from Member where M_Status='A' and M_Email=@M_Email ");

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable ds = new DataTable();
        oCmd.Parameters.AddWithValue("@M_Email", M_Email);
        oda.Fill(ds);

        return Int32.Parse(ds.Rows[0]["num"].ToString());
    }

    /// <summary>
    /// 帳號密碼錯誤，凍結欄位 + 1
    /// </summary>
    public void addFailCount()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        oCmd.CommandText = @"
declare @tmpCount int = (select M_LoginFail from Member where M_Account=@M_Account and M_Status='A')

if @tmpCount is not null
	begin
		update Member set M_LoginFail=(@tmpCount+1) where M_Account=@M_Account and M_Status='A'
	end
";
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        oCmd.Parameters.AddWithValue("@M_Account", M_Account);

        oCmd.Connection.Open();
        oCmd.ExecuteNonQuery();
        oCmd.Connection.Close();
    }

    /// <summary>
    /// 檢查帳號是否凍結
    /// </summary>
    public int CheckAccAlive()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"select M_LoginFail from Member where M_Status='A' and M_Account=@M_Account ");

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable ds = new DataTable();
        oCmd.Parameters.AddWithValue("@M_Account", M_Account);
        oda.Fill(ds);

        if (ds.Rows.Count > 0)
            return Int32.Parse(ds.Rows[0]["M_LoginFail"].ToString());
        else
            return 0;
    }

    /// <summary>
    /// 帳號登入失敗歸0
    /// </summary>
    public void RecoverFailCount()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        oCmd.CommandText = @"update Member set M_LoginFail=0 where M_Account=@M_Account and M_Status='A' ";
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        oCmd.Parameters.AddWithValue("@M_Account", M_Account);

        oCmd.Connection.Open();
        oCmd.ExecuteNonQuery();
        oCmd.Connection.Close();
    }

    /// <summary>
    /// 解鎖凍結帳號
    /// </summary>
    public void RecoverMember()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        oCmd.CommandText = @"update Member set M_LoginFail=0 where M_ID=@M_ID ";
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        oCmd.Parameters.AddWithValue("@M_ID", M_ID);

        oCmd.Connection.Open();
        oCmd.ExecuteNonQuery();
        oCmd.Connection.Close();
    }
}