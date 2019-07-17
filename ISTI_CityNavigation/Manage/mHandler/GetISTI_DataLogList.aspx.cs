using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class GetISTI_DataLogList : System.Web.UI.Page
    {
        ImportData_Log idl_db = new ImportData_Log();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢會員Log
            ///說    明:
            /// * Request["PageNo"]: 所在頁面
            /// * Request["PageSize"]: 一頁幾筆資料
            /// * Request["SortName"]: 排序欄位名稱
            /// * Request["SortMethod"]: 排序方式
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string PageNo = (Request["PageNo"] != null) ? Request["PageNo"].ToString().Trim() : "";
                int PageSize = (Request["PageSize"] != null) ? int.Parse(Request["PageSize"].ToString().Trim()) : 10;
                string SortName = (Request["SortName"] != null) ? Request["SortName"].ToString().Trim() : "";
                string SortMethod = (Request["SortMethod"] != null) ? Request["SortMethod"].ToString().Trim() : "-";
                SortMethod = (SortMethod == "+") ? "asc" : "desc";
                string SortCommand = SortName + " " + SortMethod;

                //計算起始與結束
                int pageEnd = (int.Parse(PageNo) + 1) * PageSize;
                int pageStart = pageEnd - PageSize + 1;

                string xmlstr = string.Empty;
                string xmlstr2 = string.Empty;

                idl_db._IDL_Type = "ISTI";
                DataSet ds = idl_db.getList(pageStart.ToString(), pageEnd.ToString(), SortCommand);

                xmlstr = "<total>" + ds.Tables[0].Rows[0]["total"].ToString() + "</total>";
                xmlstr2 = DataTableToXml.ConvertDatatableToXML(ds.Tables[1], "dataList", "data_item");
                xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + xmlstr2 + "</root>";
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