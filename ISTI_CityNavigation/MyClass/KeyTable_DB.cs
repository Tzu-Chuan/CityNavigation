using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;


public class KeyTable_DB
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string K_ID = string.Empty;
    string K_Word = string.Empty;
    string K_Code = string.Empty;
    string K_ItemNo = string.Empty;
    #endregion
    #region 公用
    public string _K_ID
    {
        set { K_ID = value; }
    }
    public string _K_Word
    {
        set { K_Word = value; }
    }
    public string _K_Code
    {
        set { K_Code = value; }
    }
    public string _K_ItemNo
    {
        set { K_ItemNo = value; }
    }
    #endregion

    public DataTable GetGlobalList()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
select * into #tmp from KeyTable where 1=1 ");

        if (KeyWord != "")
            sb.Append(@"and upper(K_Word) LIKE '%' + upper(@KeyWord) + '%' ");

        if (K_Code != "")
            sb.Append(@"and K_Code=@K_Code ");

        sb.Append(@"
SELECT DISTINCT K_Code,
 STUFF((
	 SELECT '、' + aa.K_Word FROM #tmp aa
	 where aa.K_Code=bb.K_Code
	 for xml path('')
 ), 1, 1, '') as Keyword
FROM #tmp bb

drop table #tmp
");

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable ds = new DataTable();

        oCmd.Parameters.AddWithValue("@KeyWord", KeyWord);
        oCmd.Parameters.AddWithValue("@K_Code", K_Code);

        oda.Fill(ds);
        return ds;
    }
}