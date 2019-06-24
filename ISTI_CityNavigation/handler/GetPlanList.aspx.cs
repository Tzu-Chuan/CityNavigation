using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;

namespace ISTI_CityNavigation.handler
{
    public partial class GetPlanList : System.Web.UI.Page
    {
        CitySummaryTable_DB cst_db = new CitySummaryTable_DB();
        CityPlanTable_DB cpt_db = new CityPlanTable_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢計畫列表
            ///說    明:
            /// * Request["City"]: 縣市代碼
            /// * Request["ServiceType"]: 領域別
            /// * Request["PlanName"]: 計畫名稱
            /// * Request["CompanyName"]: 公司名稱
            /// * Request["SortName"]: 排序欄位名稱
            /// * Request["SortMethod"]: 排序方式
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string City = (string.IsNullOrEmpty(Request["City"])) ? "" : Request["City"].ToString().Trim();
                string ServiceType = (string.IsNullOrEmpty(Request["ServiceType"])) ? "" : Request["ServiceType"].ToString().Trim();
                string PlanName = (string.IsNullOrEmpty(Request["PlanName"])) ? "" : Request["PlanName"].ToString().Trim();
                string CompanyName = (string.IsNullOrEmpty(Request["CompanyName"])) ? "" : Request["CompanyName"].ToString().Trim();
                string SortName = (Request["SortName"] != null) ? Request["SortName"].ToString().Trim() : "";
                string SortMethod = (Request["SortMethod"] != null) ? Request["SortMethod"].ToString().Trim() : "-";
                SortMethod = (SortMethod == "+") ? "asc" : "desc";
                string SortCommand = (SortName != "") ? SortName + " " + SortMethod : "";

                string xmlstr = string.Empty;

                cst_db._CS_HostCompany = CompanyName;
                cst_db._CS_PlanName = PlanName;
                cst_db._CS_ServiceType = ServiceType;
                DataTable dt = cst_db.GetList(City, SortCommand);

                xmlstr = DataTableToXml.ConvertDatatableToXML(dt, "dataList", "data_item");
                xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                xDoc.LoadXml(xmlstr);
            }
            catch (Exception ex)
            {
                xDoc = ExceptionUtil.GetExceptionDocument(ex);
            }
            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
            xDoc.Save(Response.Output);
        }
    }
}