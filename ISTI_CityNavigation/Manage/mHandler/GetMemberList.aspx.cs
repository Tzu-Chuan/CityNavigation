using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class GetMemberList : System.Web.UI.Page
    {
        Member_DB m_db = new Member_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢會員列表
            ///說明:
            /// * Request["group"]: CodeTable Group 代碼
            /// * Request["item"]: CodeTable Item 代碼
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string SearchStr = (Request["SearchStr"] != null) ? Request["SearchStr"].ToString().Trim() : "";
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

                m_db._KeyWord = SearchStr;
                DataSet ds = m_db.getMemberList(pageStart.ToString(), pageEnd.ToString(), SortCommand);

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