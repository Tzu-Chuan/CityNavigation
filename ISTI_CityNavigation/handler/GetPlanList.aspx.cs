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
            /// * Request["Area"]: 含 / 不含全區
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
                string Area = (string.IsNullOrEmpty(Request["Area"])) ? "" : Request["Area"].ToString().Trim();
                string City = (string.IsNullOrEmpty(Request["City"])) ? "" : Request["City"].ToString().Trim();
                string ServiceType = (string.IsNullOrEmpty(Request["ServiceType"])) ? "" : Request["ServiceType"].ToString().Trim();
                string PlanName = (string.IsNullOrEmpty(Request["PlanName"])) ? "" : Request["PlanName"].ToString().Trim();
                string CompanyName = (string.IsNullOrEmpty(Request["CompanyName"])) ? "" : Request["CompanyName"].ToString().Trim();
                string SortName = (Request["SortName"] != null) ? Request["SortName"].ToString().Trim() : "";
                string SortMethod = (Request["SortMethod"] != null) ? Request["SortMethod"].ToString().Trim() : "-";
                SortMethod = (SortMethod == "+") ? "asc" : "desc";
                string SortCommand = string.Empty;
                if (City != "")
                    SortCommand = (SortName != "") ? SortName + " " + SortMethod : "CONVERT(int,CP_No)";
                else
                    SortCommand = (SortName != "") ? SortName + " " + SortMethod : "CONVERT(int,CS_No)";

                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                if (Common.VeriftyToken(token))
                {
                    string xmlstr = string.Empty;
                    string xmlstr2 = string.Empty;

                    if (Area == "N")
                        cst_db._CS_AllArea = Area;
                    cst_db._CS_HostCompany = CompanyName;
                    cst_db._CS_PlanName = PlanName;
                    cst_db._CS_ServiceType = ServiceType;
                    DataSet ds = cst_db.GetList(City, SortCommand);

                    xmlstr = DataTableToXml.ConvertDatatableToXML(ds.Tables[0], "dataList", "sum_item");
                    xmlstr2 = DataTableToXml.ConvertDatatableToXML(ds.Tables[1], "dataList", "data_item");
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + xmlstr2 + "</root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                {
                    xDoc = ExceptionUtil.GetErrorMassageDocument("TokenFail");
                }
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