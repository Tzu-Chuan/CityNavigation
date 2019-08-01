using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;


public class CitySummaryTable_DB
{
    string KeyWord = string.Empty;
    public string _KeyWord
    {
        set { KeyWord = value; }
    }
    #region 私用
    string CS_ID = string.Empty;
    string CS_PlanSchedule = string.Empty;
    string CS_No = string.Empty;
    string CS_PlanType = string.Empty;
    string CS_PlanTypeDetail = string.Empty;
    string CS_CaseNo = string.Empty;
    string CS_HostCompany = string.Empty;
    string CS_JointCompany = string.Empty;
    string CS_PlanName = string.Empty;
    string CS_PlanSummary = string.Empty;
    string CS_PlanDefect = string.Empty;
    string CS_NowResult = string.Empty;
    string CS_DoneResult = string.Empty;
    string CS_ServiceArea = string.Empty;
    string CS_ServiceType = string.Empty;
    string CS_AllArea = string.Empty;
    string CS_CityArea = string.Empty;
    string CS_CityAreaDetail = string.Empty;
    string CS_PlanTotalMoney = string.Empty;
    string CS_PlanSubMoney = string.Empty;
    string CS_NewTaipei_Total = string.Empty;
    string CS_Taipei_Total = string.Empty;
    string CS_Taoyuan_Total = string.Empty;
    string CS_Taichung_Total = string.Empty;
    string CS_Tainan_Total = string.Empty;
    string CS_Kaohsiung_Total = string.Empty;
    string CS_Yilan_Total = string.Empty;
    string CS_HsinchuCounty_Total = string.Empty;
    string CS_Miaoli_Total = string.Empty;
    string CS_Changhua_Total = string.Empty;
    string CS_Nantou_Total = string.Empty;
    string CS_Yunlin_Total = string.Empty;
    string CS_ChiayiCounty_Total = string.Empty;
    string CS_Pingtung_Total = string.Empty;
    string CS_Taitung_Total = string.Empty;
    string CS_Hualien_Total = string.Empty;
    string CS_Penghu_Total = string.Empty;
    string CS_Keelung_Total = string.Empty;
    string CS_HsinchuCity_Total = string.Empty;
    string CS_ChiayiCity_Total = string.Empty;
    string CS_Kinmen_Total = string.Empty;
    string CS_Lienchiang_Total = string.Empty;
    string CS_NewTaipei_Sub = string.Empty;
    string CS_Taipei_Sub = string.Empty;
    string CS_Taoyuan_Sub = string.Empty;
    string CS_Taichung_Sub = string.Empty;
    string CS_Tainan_Sub = string.Empty;
    string CS_Kaohsiung_Sub = string.Empty;
    string CS_Yilan_Sub = string.Empty;
    string CS_HsinchuCounty_Sub = string.Empty;
    string CS_Miaoli_Sub = string.Empty;
    string CS_Changhua_Sub = string.Empty;
    string CS_Nantou_Sub = string.Empty;
    string CS_Yunlin_Sub = string.Empty;
    string CS_ChiayiCounty_Sub = string.Empty;
    string CS_Pingtung_Sub = string.Empty;
    string CS_Taitung_Sub = string.Empty;
    string CS_Hualien_Sub = string.Empty;
    string CS_Penghu_Sub = string.Empty;
    string CS_Keelung_Sub = string.Empty;
    string CS_HsinchuCity_Sub = string.Empty;
    string CS_ChiayiCity_Sub = string.Empty;
    string CS_Kinmen_Sub = string.Empty;
    string CS_Lienchiang_Sub = string.Empty;
    DateTime CS_CreateDate;
    string CS_CreateId = string.Empty;
    string CS_CreateName = string.Empty;
    int CS_Version;
    string CS_Status = string.Empty;
    #endregion
    #region 公用
    public string _CS_ID { set { CS_ID = value; } }
    public string _CS_PlanSchedule { set { CS_PlanSchedule = value; } }
    public string _CS_No { set { CS_No = value; } }
    public string _CS_PlanType { set { CS_PlanType = value; } }
    public string _CS_PlanTypeDetail { set { CS_PlanTypeDetail = value; } }
    public string _CS_CaseNo { set { CS_CaseNo = value; } }
    public string _CS_HostCompany { set { CS_HostCompany = value; } }
    public string _CS_JointCompany { set { CS_JointCompany = value; } }
    public string _CS_PlanName { set { CS_PlanName = value; } }
    public string _CS_PlanSummary { set { CS_PlanSummary = value; } }
    public string _CS_PlanDefect { set { CS_PlanDefect = value; } }
    public string _CS_NowResult { set { CS_NowResult = value; } }
    public string _CS_DoneResult { set { CS_DoneResult = value; } }
    public string _CS_ServiceArea { set { CS_ServiceArea = value; } }
    public string _CS_ServiceType { set { CS_ServiceType = value; } }
    public string _CS_AllArea { set { CS_AllArea = value; } }
    public string _CS_CityArea { set { CS_CityArea = value; } }
    public string _CS_CityAreaDetail { set { CS_CityAreaDetail = value; } }
    public string _CS_PlanTotalMoney { set { CS_PlanTotalMoney = value; } }
    public string _CS_PlanSubMoney { set { CS_PlanSubMoney = value; } }
    public string _CS_NewTaipei_Total { set { CS_NewTaipei_Total = value; } }
    public string _CS_Taipei_Total { set { CS_Taipei_Total = value; } }
    public string _CS_Taoyuan_Total { set { CS_Taoyuan_Total = value; } }
    public string _CS_Taichung_Total { set { CS_Taichung_Total = value; } }
    public string _CS_Tainan_Total { set { CS_Tainan_Total = value; } }
    public string _CS_Kaohsiung_Total { set { CS_Kaohsiung_Total = value; } }
    public string _CS_Yilan_Total { set { CS_Yilan_Total = value; } }
    public string _CS_HsinchuCounty_Total { set { CS_HsinchuCounty_Total = value; } }
    public string _CS_Miaoli_Total { set { CS_Miaoli_Total = value; } }
    public string _CS_Changhua_Total { set { CS_Changhua_Total = value; } }
    public string _CS_Nantou_Total { set { CS_Nantou_Total = value; } }
    public string _CS_Yunlin_Total { set { CS_Yunlin_Total = value; } }
    public string _CS_ChiayiCounty_Total { set { CS_ChiayiCounty_Total = value; } }
    public string _CS_Pingtung_Total { set { CS_Pingtung_Total = value; } }
    public string _CS_Taitung_Total { set { CS_Taitung_Total = value; } }
    public string _CS_Hualien_Total { set { CS_Hualien_Total = value; } }
    public string _CS_Penghu_Total { set { CS_Penghu_Total = value; } }
    public string _CS_Keelung_Total { set { CS_Keelung_Total = value; } }
    public string _CS_HsinchuCity_Total { set { CS_HsinchuCity_Total = value; } }
    public string _CS_ChiayiCity_Total { set { CS_ChiayiCity_Total = value; } }
    public string _CS_Kinmen_Total { set { CS_Kinmen_Total = value; } }
    public string _CS_Lienchiang_Total { set { CS_Lienchiang_Total = value; } }
    public string _CS_NewTaipei_Sub { set { CS_NewTaipei_Sub = value; } }
    public string _CS_Taipei_Sub { set { CS_Taipei_Sub = value; } }
    public string _CS_Taoyuan_Sub { set { CS_Taoyuan_Sub = value; } }
    public string _CS_Taichung_Sub { set { CS_Taichung_Sub = value; } }
    public string _CS_Tainan_Sub { set { CS_Tainan_Sub = value; } }
    public string _CS_Kaohsiung_Sub { set { CS_Kaohsiung_Sub = value; } }
    public string _CS_Yilan_Sub { set { CS_Yilan_Sub = value; } }
    public string _CS_HsinchuCounty_Sub { set { CS_HsinchuCounty_Sub = value; } }
    public string _CS_Miaoli_Sub { set { CS_Miaoli_Sub = value; } }
    public string _CS_Changhua_Sub { set { CS_Changhua_Sub = value; } }
    public string _CS_Nantou_Sub { set { CS_Nantou_Sub = value; } }
    public string _CS_Yunlin_Sub { set { CS_Yunlin_Sub = value; } }
    public string _CS_ChiayiCounty_Sub { set { CS_ChiayiCounty_Sub = value; } }
    public string _CS_Pingtung_Sub { set { CS_Pingtung_Sub = value; } }
    public string _CS_Taitung_Sub { set { CS_Taitung_Sub = value; } }
    public string _CS_Hualien_Sub { set { CS_Hualien_Sub = value; } }
    public string _CS_Penghu_Sub { set { CS_Penghu_Sub = value; } }
    public string _CS_Keelung_Sub { set { CS_Keelung_Sub = value; } }
    public string _CS_HsinchuCity_Sub { set { CS_HsinchuCity_Sub = value; } }
    public string _CS_ChiayiCity_Sub { set { CS_ChiayiCity_Sub = value; } }
    public string _CS_Kinmen_Sub { set { CS_Kinmen_Sub = value; } }
    public string _CS_Lienchiang_Sub { set { CS_Lienchiang_Sub = value; } }
    public DateTime _CS_CreateDate { set { CS_CreateDate = value; } }
    public string _CS_CreateId { set { CS_CreateId = value; } }
    public string _CS_CreateName { set { CS_CreateName = value; } }
    public int _CS_Version { set { CS_Version = value; } }
    public string _CS_Status { set { CS_Status = value; } }
    #endregion

    public DataSet GetList(string City, string sortStr)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        if (City != "")
        {
            sb.Append(@"Select * into #tmp from CityPlanTable where CP_Status='A' ");

            if (CS_AllArea != "")
                sb.Append(@"and CP_AllArea=@AllArea ");

            if (City != "")
                sb.Append(@"and CP_CityCode=@City ");

            if (CS_HostCompany == CS_PlanName)
                sb.Append(@"and ((upper(CP_HostCompany) LIKE '%' + upper(@HostCompany) + '%') or (upper(CP_PlanName) LIKE '%' + upper(@PlanName) + '%')) ");
            else
            {
                if (CS_HostCompany != "")
                    sb.Append(@"and CP_HostCompany LIKE '%' + @HostCompany + '%' ");

                if (CS_PlanName != "")
                    sb.Append(@"and CP_PlanName LIKE '%' + @PlanName + '%' ");
            }

            if (CS_ServiceType != "")
                sb.Append(@"and CP_ServiceType=@ServiceType ");

            sb.Append(@"select count(*) as Total,
sum(CONVERT(float,CP_PlanTotalMoney)) as CP_PlanTotalMoney,
sum(CONVERT(float,CP_PlanSubMoney)) as CP_PlanSubMoney,
sum(CONVERT(float,CP_CityTotalMoney)) as CP_CityTotalMoney,
sum(CONVERT(float,CP_CitySubMoney)) as CP_CitySubMoney
from #tmp

select * from #tmp

drop table #tmp ");
        }
        else
        {
            sb.Append(@"Select * into #tmp from CitySummaryTable where CS_Status='A' ");

            if (CS_AllArea != "")
                sb.Append(@"and CS_AllArea=@AllArea ");

            if (CS_HostCompany == CS_PlanName)
                sb.Append(@"and ((upper(CS_HostCompany) LIKE '%' + upper(@HostCompany) + '%') or (upper(CS_PlanName) LIKE '%' + upper(@PlanName) + '%')) ");
            else
            {
                if (CS_HostCompany != "")
                    sb.Append(@"and CS_HostCompany LIKE '%' + @HostCompany + '%' ");

                if (CS_PlanName != "")
                    sb.Append(@"and CS_PlanName LIKE '%' + @PlanName + '%' ");
            }

            if (CS_ServiceType != "")
                sb.Append(@"and CS_ServiceType=@ServiceType ");

            sb.Append(@"select count(*) as Total,
sum(CONVERT(float,CS_PlanTotalMoney)) as CS_PlanTotalMoney,
sum(CONVERT(float,CS_PlanSubMoney)) as CS_PlanSubMoney,
sum(CONVERT(float,CS_NewTaipei_Total)) as CS_NewTaipei_Total,
sum(CONVERT(float,CS_Taipei_Total)) as CS_Taipei_Total,
sum(CONVERT(float,CS_Taoyuan_Total)) as CS_Taoyuan_Total,
sum(CONVERT(float,CS_Taichung_Total)) as CS_Taichung_Total,
sum(CONVERT(float,CS_Tainan_Total)) as CS_Tainan_Total,
sum(CONVERT(float,CS_Kaohsiung_Total)) as CS_Kaohsiung_Total,
sum(CONVERT(float,CS_Yilan_Total)) as CS_Yilan_Total,
sum(CONVERT(float,CS_HsinchuCounty_Total)) as CS_HsinchuCounty_Total,
sum(CONVERT(float,CS_Miaoli_Total)) as CS_Miaoli_Total,
sum(CONVERT(float,CS_Changhua_Total)) as CS_Changhua_Total,
sum(CONVERT(float,CS_Nantou_Total)) as CS_Nantou_Total,
sum(CONVERT(float,CS_Yunlin_Total)) as CS_Yunlin_Total,
sum(CONVERT(float,CS_ChiayiCounty_Total)) as CS_ChiayiCounty_Total,
sum(CONVERT(float,CS_Pingtung_Total)) as CS_Pingtung_Total,
sum(CONVERT(float,CS_Taitung_Total)) as CS_Taitung_Total,
sum(CONVERT(float,CS_Hualien_Total)) as CS_Hualien_Total,
sum(CONVERT(float,CS_Penghu_Total)) as CS_Penghu_Total,
sum(CONVERT(float,CS_Keelung_Total)) as CS_Keelung_Total,
sum(CONVERT(float,CS_HsinchuCity_Total)) as CS_HsinchuCity_Total,
sum(CONVERT(float,CS_ChiayiCity_Total)) as CS_ChiayiCity_Total,
sum(CONVERT(float,CS_Kinmen_Total)) as CS_Kinmen_Total,
sum(CONVERT(float,CS_Lienchiang_Total)) as CS_Lienchiang_Total,
sum(CONVERT(float,CS_NewTaipei_Sub)) as CS_NewTaipei_Sub,
sum(CONVERT(float,CS_Taipei_Sub)) as CS_Taipei_Sub,
sum(CONVERT(float,CS_Taoyuan_Sub)) as CS_Taoyuan_Sub,
sum(CONVERT(float,CS_Taichung_Sub)) as CS_Taichung_Sub,
sum(CONVERT(float,CS_Tainan_Sub)) as CS_Tainan_Sub,
sum(CONVERT(float,CS_Kaohsiung_Sub)) as CS_Kaohsiung_Sub,
sum(CONVERT(float,CS_Yilan_Sub)) as CS_Yilan_Sub,
sum(CONVERT(float,CS_HsinchuCounty_Sub)) as CS_HsinchuCounty_Sub,
sum(CONVERT(float,CS_Miaoli_Sub)) as CS_Miaoli_Sub,
sum(CONVERT(float,CS_Changhua_Sub)) as CS_Changhua_Sub,
sum(CONVERT(float,CS_Nantou_Sub)) as CS_Nantou_Sub,
sum(CONVERT(float,CS_Yunlin_Sub)) as CS_Yunlin_Sub,
sum(CONVERT(float,CS_ChiayiCounty_Sub)) as CS_ChiayiCounty_Sub,
sum(CONVERT(float,CS_Pingtung_Sub)) as CS_Pingtung_Sub,
sum(CONVERT(float,CS_Taitung_Sub)) as CS_Taitung_Sub,
sum(CONVERT(float,CS_Hualien_Sub)) as CS_Hualien_Sub,
sum(CONVERT(float,CS_Penghu_Sub)) as CS_Penghu_Sub,
sum(CONVERT(float,CS_Keelung_Sub)) as CS_Keelung_Sub,
sum(CONVERT(float,CS_HsinchuCity_Sub)) as CS_HsinchuCity_Sub,
sum(CONVERT(float,CS_ChiayiCity_Sub)) as CS_ChiayiCity_Sub,
sum(CONVERT(float,CS_Kinmen_Sub)) as CS_Kinmen_Sub,
sum(CONVERT(float,CS_Lienchiang_Sub)) as CS_Lienchiang_Sub
from #tmp

select * from #tmp

drop table #tmp ");
        }

        if (sortStr != "")
            sb.Append(@"order by " + sortStr);

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataSet ds = new DataSet();

        oCmd.Parameters.AddWithValue("@AllArea", CS_AllArea);
        oCmd.Parameters.AddWithValue("@City", City);
        oCmd.Parameters.AddWithValue("@HostCompany", CS_HostCompany);
        oCmd.Parameters.AddWithValue("@PlanName", CS_PlanName);
        oCmd.Parameters.AddWithValue("@ServiceType", CS_ServiceType);

        oda.Fill(ds);
        return ds;
    }

    public DataTable getPlanType_ddl()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"Select CS_ServiceType from CitySummaryTable 
where CS_ServiceType<>'' and CS_ServiceType is not null and CS_Status='A'
group by CS_ServiceType
order by CS_ServiceType ");

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable ds = new DataTable();

        //oCmd.Parameters.AddWithValue("@KeyWord", KeyWord);

        oda.Fill(ds);
        return ds;
    }

    public int getMaxVersion()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"SELECT isnull(MAX(CS_Version),0) as strMax from CitySummaryTable where CS_Status='A'  ");

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
        sb.Append(@"update CitySummaryTable set CS_Status='D' where CS_Status='A' ");
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
            sqlBC.DestinationTableName = "CitySummaryTable";

            /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
            sqlBC.ColumnMappings.Add("CS_PlanSchedule", "CS_PlanSchedule");
            sqlBC.ColumnMappings.Add("CS_No", "CS_No");
            sqlBC.ColumnMappings.Add("CS_PlanType", "CS_PlanType");
            sqlBC.ColumnMappings.Add("CS_PlanTypeDetail", "CS_PlanTypeDetail");
            sqlBC.ColumnMappings.Add("CS_CaseNo", "CS_CaseNo");
            sqlBC.ColumnMappings.Add("CS_HostCompany", "CS_HostCompany");
            sqlBC.ColumnMappings.Add("CS_JointCompany", "CS_JointCompany");
            sqlBC.ColumnMappings.Add("CS_PlanName", "CS_PlanName");
            sqlBC.ColumnMappings.Add("CS_PlanSummary", "CS_PlanSummary");
            sqlBC.ColumnMappings.Add("CS_PlanDefect", "CS_PlanDefect");
            sqlBC.ColumnMappings.Add("CS_NowResult", "CS_NowResult");
            sqlBC.ColumnMappings.Add("CS_DoneResult", "CS_DoneResult");
            sqlBC.ColumnMappings.Add("CS_ServiceArea", "CS_ServiceArea");
            sqlBC.ColumnMappings.Add("CS_ServiceType", "CS_ServiceType");
            sqlBC.ColumnMappings.Add("CS_AllArea", "CS_AllArea");
            sqlBC.ColumnMappings.Add("CS_CityArea", "CS_CityArea");
            sqlBC.ColumnMappings.Add("CS_CityAreaDetail", "CS_CityAreaDetail");
            sqlBC.ColumnMappings.Add("CS_PlanTotalMoney", "CS_PlanTotalMoney");
            sqlBC.ColumnMappings.Add("CS_PlanSubMoney", "CS_PlanSubMoney");
            sqlBC.ColumnMappings.Add("CS_NewTaipei_Total", "CS_NewTaipei_Total");
            sqlBC.ColumnMappings.Add("CS_Taipei_Total", "CS_Taipei_Total");
            sqlBC.ColumnMappings.Add("CS_Taoyuan_Total", "CS_Taoyuan_Total");
            sqlBC.ColumnMappings.Add("CS_Taichung_Total", "CS_Taichung_Total");
            sqlBC.ColumnMappings.Add("CS_Tainan_Total", "CS_Tainan_Total");
            sqlBC.ColumnMappings.Add("CS_Kaohsiung_Total", "CS_Kaohsiung_Total");
            sqlBC.ColumnMappings.Add("CS_Yilan_Total", "CS_Yilan_Total");
            sqlBC.ColumnMappings.Add("CS_HsinchuCounty_Total", "CS_HsinchuCounty_Total");
            sqlBC.ColumnMappings.Add("CS_Miaoli_Total", "CS_Miaoli_Total");
            sqlBC.ColumnMappings.Add("CS_Changhua_Total", "CS_Changhua_Total");
            sqlBC.ColumnMappings.Add("CS_Nantou_Total", "CS_Nantou_Total");
            sqlBC.ColumnMappings.Add("CS_Yunlin_Total", "CS_Yunlin_Total");
            sqlBC.ColumnMappings.Add("CS_ChiayiCounty_Total", "CS_ChiayiCounty_Total");
            sqlBC.ColumnMappings.Add("CS_Pingtung_Total", "CS_Pingtung_Total");
            sqlBC.ColumnMappings.Add("CS_Taitung_Total", "CS_Taitung_Total");
            sqlBC.ColumnMappings.Add("CS_Hualien_Total", "CS_Hualien_Total");
            sqlBC.ColumnMappings.Add("CS_Penghu_Total", "CS_Penghu_Total");
            sqlBC.ColumnMappings.Add("CS_Keelung_Total", "CS_Keelung_Total");
            sqlBC.ColumnMappings.Add("CS_HsinchuCity_Total", "CS_HsinchuCity_Total");
            sqlBC.ColumnMappings.Add("CS_ChiayiCity_Total", "CS_ChiayiCity_Total");
            sqlBC.ColumnMappings.Add("CS_Kinmen_Total", "CS_Kinmen_Total");
            sqlBC.ColumnMappings.Add("CS_Lienchiang_Total", "CS_Lienchiang_Total");
            sqlBC.ColumnMappings.Add("CS_NewTaipei_Sub", "CS_NewTaipei_Sub");
            sqlBC.ColumnMappings.Add("CS_Taipei_Sub", "CS_Taipei_Sub");
            sqlBC.ColumnMappings.Add("CS_Taoyuan_Sub", "CS_Taoyuan_Sub");
            sqlBC.ColumnMappings.Add("CS_Taichung_Sub", "CS_Taichung_Sub");
            sqlBC.ColumnMappings.Add("CS_Tainan_Sub", "CS_Tainan_Sub");
            sqlBC.ColumnMappings.Add("CS_Kaohsiung_Sub", "CS_Kaohsiung_Sub");
            sqlBC.ColumnMappings.Add("CS_Yilan_Sub", "CS_Yilan_Sub");
            sqlBC.ColumnMappings.Add("CS_HsinchuCounty_Sub", "CS_HsinchuCounty_Sub");
            sqlBC.ColumnMappings.Add("CS_Miaoli_Sub", "CS_Miaoli_Sub");
            sqlBC.ColumnMappings.Add("CS_Changhua_Sub", "CS_Changhua_Sub");
            sqlBC.ColumnMappings.Add("CS_Nantou_Sub", "CS_Nantou_Sub");
            sqlBC.ColumnMappings.Add("CS_Yunlin_Sub", "CS_Yunlin_Sub");
            sqlBC.ColumnMappings.Add("CS_ChiayiCounty_Sub", "CS_ChiayiCounty_Sub");
            sqlBC.ColumnMappings.Add("CS_Pingtung_Sub", "CS_Pingtung_Sub");
            sqlBC.ColumnMappings.Add("CS_Taitung_Sub", "CS_Taitung_Sub");
            sqlBC.ColumnMappings.Add("CS_Hualien_Sub", "CS_Hualien_Sub");
            sqlBC.ColumnMappings.Add("CS_Penghu_Sub", "CS_Penghu_Sub");
            sqlBC.ColumnMappings.Add("CS_Keelung_Sub", "CS_Keelung_Sub");
            sqlBC.ColumnMappings.Add("CS_HsinchuCity_Sub", "CS_HsinchuCity_Sub");
            sqlBC.ColumnMappings.Add("CS_ChiayiCity_Sub", "CS_ChiayiCity_Sub");
            sqlBC.ColumnMappings.Add("CS_Kinmen_Sub", "CS_Kinmen_Sub");
            sqlBC.ColumnMappings.Add("CS_Lienchiang_Sub", "CS_Lienchiang_Sub");
            sqlBC.ColumnMappings.Add("CS_CreateId", "CS_CreateId");
            sqlBC.ColumnMappings.Add("CS_CreateName", "CS_CreateName");
            sqlBC.ColumnMappings.Add("CS_Version", "CS_Version");
            sqlBC.ColumnMappings.Add("CS_Status", "CS_Status");

            /// 開始寫入資料
            sqlBC.WriteToServer(srcData);
        }
    }

    public DataTable GetVersionDDL()
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        StringBuilder sb = new StringBuilder();

        sb.Append(@"
select top 3 CS_CreateDate,CS_Version,
CONVERT(nvarchar,CS_CreateDate,112)+'-'+CONVERT(nvarchar,CS_Version) ddlstr,
(select top 1 CS_CreateDate from CitySummaryTable where CS_Status='A') NowDate,
(select top 1 CS_Version from CitySummaryTable where CS_Status='A') NowVer
from CitySummaryTable
group by CS_CreateDate,CS_Version
order by CS_CreateDate desc ");

        oCmd.CommandText = sb.ToString();
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);
        DataTable ds = new DataTable();

        //oCmd.Parameters.AddWithValue("@KeyWord", KeyWord);

        oda.Fill(ds);
        return ds;
    }

    public void ChangeIDB_Version(string version)
    {
        SqlCommand oCmd = new SqlCommand();
        oCmd.Connection = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
        oCmd.CommandText = @"
declare @ver nvarchar(10) = @version
update CitySummaryTable set CS_Status='D' where CS_Status='A'
update CitySummaryTable set CS_Status='A' where CS_Version=@ver
update CityPlanTable set CP_Status='D' where CP_Status='A'
update CityPlanTable set CP_Status='A' where CP_Version=@ver
update BudgetExecution set B_Status='D' where B_Status='A'
update BudgetExecution set B_Status='A' where B_Version=@ver
update CategorySubMoney set C_Status='D' where C_Status='A'
update CategorySubMoney set C_Status='A' where C_Version=@ver
update ServiceSubMoney set S_Status='D' where S_Status='A'
update ServiceSubMoney set S_Status='A' where S_Version=@ver
update CitySubMoney set C_Status='D' where C_Status='A'
update CitySubMoney set C_Status='A' where C_Version=@ver
";
        oCmd.CommandType = CommandType.Text;
        SqlDataAdapter oda = new SqlDataAdapter(oCmd);

        oCmd.Parameters.AddWithValue("@version", version);

        oCmd.Connection.Open();
        oCmd.ExecuteNonQuery();
        oCmd.Connection.Close();
    }
}